# Pass

[Integration guide](README.md)

## Show the membership pass

| Personal information consent | Collected data |
| --- | --- |
| Strictly Necessary, Functional | Access token |

Show the membership pass on its own screen:

```swift
public func showPass(
    useVisibleViewController: UIViewController? = nil,
    onError: OnError? = nil
)
```

- `useVisibleViewController`: the view controller used to show the in-app pass.
- `onError`: called when there is a consent error.

**Usage**

Show the pass with the consent error callback when you need to ask for Functional consent:

```swift
@IBAction func onButtonTap(_ sender: Any) {
    Lava.shared.showPass { err in
        showConsentDialog(err.localizedDescription)
    }
}

func showConsentDialog(_ errorMessage: String) {
    // Display the consent selection screen
}
```

If the app does not need to handle consent:

```swift
Lava.shared.showPass()
```

Starting in version 2.0.33, you can also show the pass inset (the SDK attaches it inside the current view controller and reserves space for your chrome) or embed it (the SDK returns a `UIViewController` that you place in your own layout).

Do not use `presentOverlayFunction` for the pass. That callback is for the push notification overlay. Inset attach is a child view controller with Auto Layout.

| Mode | Who presents | Typical use |
| --- | --- | --- |
| Full screen | SDK modal | Existing `showPass()` |
| Inset | SDK, inside the host view controller | Keep a bottom tab bar visible |
| Embed | Host app | Pass is a real tab or a custom frame |

> **Note**
>
> To handle `pass_closed` or `pass_container_closed`, see [SDK message callback](sdk-messages.md).

## Choose a presentation

`PassPresentation` describes how the pass is shown. Insets are points reserved around the pass so your chrome stays tappable. Zero insets are full screen.

```swift
public struct PassPresentation {
    public var insets: PassInsets
    public var showsCloseButton: Bool?
}

public struct PassInsets {
    public var top: CGFloat
    public var left: CGFloat
    public var bottom: CGFloat
    public var right: CGFloat
}
```

`showsCloseButton` is forwarded to the pass HTML. `nil` means automatic: show the close button only for full-screen presentation.

**Usage**

```swift
// Full screen (same as today)
PassPresentation.fullScreen

// Inset: reserve 56 pt at the bottom for a tab bar
PassPresentation.inset(bottom: 56)

// Inset: keep the top bar and the bottom tabs
PassPresentation.inset(top: 64, bottom: 80)
```

## Named pages

Open a specific page inside the pass. Page IDs are open strings so the portal can add pages without an SDK release. Well-known constants:

```swift
PassPage.pass                      // "pass"
PassPage.history                   // "history"
PassPage.benefits                  // "benefits"
PassPage(rawValue: "rewards")      // any portal page ID
```

Deep links such as `…/lava/inapp/pass?page=history` and `…/lava/inapp/pass/benefits` are parsed the same way.

## Show the pass inset above your chrome

| Personal information consent | Collected data |
| --- | --- |
| Strictly Necessary, Functional | Access token |

When `presentation` has non-zero insets, the SDK attaches the pass as a child view controller of the visible host and leaves the reserved edges empty so a tab bar (or other chrome) stays visible and tappable.

```swift
public func showPass(
    page: PassPage = .pass,
    useVisibleViewController: UIViewController? = nil,
    presentation: PassPresentation = .fullScreen,
    onError: OnError? = nil
)
```

- `page`: named portal page to open. Defaults to `pass`.
- `useVisibleViewController`: the host view controller used to present or attach the pass.
- `presentation`: full screen or inset (reserved space in points). Defaults to full screen.
- `onError`: called when there is a consent error.

**Usage**

```swift
// Measure the chrome you want to keep (tab bar + home indicator, and the
// navigation bar / status bar if you want that visible too). Values are in points.
Lava.shared.showPass(
    page: .pass,
    useVisibleViewController: self,
    presentation: .inset(top: topBar, bottom: tabBar)
) { err in
    showConsentDialog(err.localizedDescription)
}
```

If the app does not need to handle consent:

```swift
Lava.shared.showPass(
    page: .pass,
    useVisibleViewController: self,
    presentation: .inset(bottom: 56)
)
```

> **Notes**
>
> - Pass a visible view controller. The SDK attaches to that controller's view.
> - Include `view.safeAreaInsets` (status bar and home indicator) in the inset values so the pass does not sit under the clock or the system gesture area.
> - Close goes through the leave guard. See [Leave the pass](#leave-the-pass).
> - Opening another pass (full screen, inset, or embed) dismisses the pass that is already showing.

## Embed the pass in your own layout

| Personal information consent | Collected data |
| --- | --- |
| Strictly Necessary, Functional | Access token |

Use embed when the pass should be a real tab, or sit in a frame the SDK should not know about. The SDK does not present or attach the view controller.

```swift
public func createPassViewController(page: PassPage = .pass) -> UIViewController
```

- `page`: named portal page to open. Defaults to `pass`.

Returns a pass `UIViewController` for your container. The portal close button is hidden.

**Usage**

```swift
let passVC = Lava.shared.createPassViewController(page: .pass)
addChild(passVC)
passContainer.addSubview(passVC.view)
passVC.view.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    passVC.view.topAnchor.constraint(equalTo: passContainer.topAnchor),
    passVC.view.leadingAnchor.constraint(equalTo: passContainer.leadingAnchor),
    passVC.view.trailingAnchor.constraint(equalTo: passContainer.trailingAnchor),
    passVC.view.bottomAnchor.constraint(equalTo: passContainer.bottomAnchor)
])
passVC.didMove(toParent: self)
```

Keep-alive contract when the user switches tabs:

1. Create the view controller once and add it as a child of your container.
2. When the user leaves the Pass tab, hide the container (`isHidden = true`). Do not `removeFromParent()`.
3. When the user returns to Pass, show the same instance. The portal does not reload.
4. Call `hidePass(force: true)` on logout, or when you destroy the screen.

You do not need to call `requestHidePass` on every tab change. That API is only for when you are about to destroy the pass.

## Navigate to another page

| Personal information consent | Collected data |
| --- | --- |
| Strictly Necessary, Functional | Access token |

```swift
public func navigatePass(
    to page: PassPage,
    completion: ((PassNavigationResult) -> Void)? = nil
)
```

- `page`: named portal page to open.
- `completion`: optional callback for whether navigation was allowed.

Navigation is a request. The portal can block it, for example when a form is unfinished. `PassNavigationResult` is either `.allowed` or `.blocked(reason:)`.

**Usage**

```swift
Lava.shared.navigatePass(to: .history) { result in
    switch result {
    case .allowed:
        break
    case .blocked(let reason):
        // reason may explain why the user must stay
        break
    }
}
```

## Leave the pass

| Personal information consent | Collected data |
| --- | --- |
| Strictly Necessary, Functional | Access token |

Hide is no longer fire-and-forget when the portal can block leaving.

```swift
public func requestHidePass(completion: @escaping (PassNavigationResult) -> Void)
public func hidePass(force: Bool = false)
```

- `completion`: callback for whether hiding was allowed.
- `force`: when `true`, skips the leave guard. Use this for logout or session end only.

**Usage**

```swift
Lava.shared.requestHidePass { result in
    if case .allowed = result {
        // Safe to leave
    }
}

Lava.shared.hidePass(force: true)
```

## Default presentation for pass deep links

When a pass deep link does not specify a presentation, the SDK uses the default (full screen). Change that so links such as `/lava/inapp/pass` open inset above your tabs.

```swift
public func setDefaultPassPresentation(_ presentation: PassPresentation)
```

**Usage**

```swift
Lava.shared.setDefaultPassPresentation(.inset(bottom: 56))
```

## Pass lifecycle and page listeners

```swift
public func setPassLifecycleListener(_ listener: PassLifecycleListener?)
public func setPassPageListener(_ listener: PassPageListener?)
```

`PassCloseReason` is `.closeButton`, `.hostDismissed`, or `.containerRemoved`.

**Usage**

```swift
Lava.shared.setPassLifecycleListener { reason in
    // Update your UI after the pass is closed
}

Lava.shared.setPassPageListener { page in
    // Sync your own sub-navigation with page.rawValue
}
```

`pass_closed` and `pass_container_closed` via the [SDK message callback](sdk-messages.md) continue to work as documented.

## Handle a pass deep link as a view controller

| Personal information consent | Collected data |
| --- | --- |
| Strictly Necessary, Functional | Access token |

When the host app owns navigation (`UINavigationController.push`, a modal present, or a custom container), do not call `handleDeepLink`. That API still presents the pass. Use the factory instead. The SDK does not present or attach the view controller.

```swift
public func handleDeepLinkAsViewController(_ url: URL) -> UIViewController?
public func handleDeepLinkAsViewController(deepLinkPath: String) -> UIViewController?
```

- `url` / `deepLinkPath`: the same input as `handleDeepLink`: a full URL, or any string containing `lava/inapp/pass`.

Returns a pass `UIViewController` configured with the parsed page and the raw string for `linkPass`, or `nil` when this is not a pass UI link.

- Trigger links (`lava/trigger/…`) return `nil`. Keep using `handleDeepLink` for those.
- Unrelated URLs return `nil`.
- If the user is not logged in yet, the factory still returns a configured view controller. The web view waits on auth the same way embed already does.
- Path-only strings such as `lava/inapp/pass?page=history` are accepted by the factory. `canHandleDeepLink(url:)` still requires a URL with a scheme (`https://` or your app scheme).

Inspect the page without presenting:

```swift
PassPage.parse(fromDeepLink: url.absoluteString)
```

The `?page=` query wins over a path segment (`lava/inapp/pass/history`). If no page is specified, the result is `.pass`.

**Usage**

```swift
if Lava.shared.canHandleDeepLink(url: url),
   let passVC = Lava.shared.handleDeepLinkAsViewController(url) {
    navigationController?.pushViewController(passVC, animated: true)
} else {
    // Trigger, unrelated, or the host wants the SDK to present
    _ = Lava.shared.handleDeepLink(url: url)
}
```

Keep the child mounted when switching tabs (`hide` / `show`; do not remove it). Call `hidePass(force: true)` on logout.

## Custom user-agent for the in-app pass

When the in-app pass needs a custom user-agent, for example to integrate with an external system, pass it to `Lava.initialize()`. See [Initialization](initialization.md) (`customUserAgent`).

---

[Integration guide](README.md) · [Previous: Secure member token](secure-token.md) · [Next: SDK message callback](sdk-messages.md)
