# Deep linking

[Integration guide](README.md)

There are two ways to set up a deep link: a custom URL scheme, or a Universal Link.

## Custom URL scheme (deprecated)

### Setup

Declare a custom URL scheme in `Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLName</key>
        <string>YOUR CUSTOM URL NAME</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>YOUR CUSTOM SCHEME</string>
        </array>
    </dict>
</array>
```

See Apple's guide on [defining a custom URL scheme](https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app).

### Handle a deep link

| Personal information consent | Collected data |
| --- | --- |
| Strictly Necessary | Access token |

Add this method in `AppDelegate` so the SDK can handle deep links:

```swift
public func handleDeepLink(
    url: URL,
    onError: OnError? = nil
) -> Bool
```

- `url`: deep link target.
- `onError`: optional callback when there is a consent error.

**Usage**

Handle deep links with the consent error callback when you need to ask for Functional consent:

```swift
func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
) -> Bool {
    if Lava.shared.canHandleDeepLink(url: url) {
        return Lava.shared.handleDeepLink(url: url) { err in
            showConsentScreen(err.localizedDescription)
        }
    } else {
        // Handle other deep links
        return false
    }
}

func showConsentScreen(_ errorMessage: String) {
    // Navigate to the consent screen
}
```

If the app does not need consent management:

```swift
func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
) -> Bool {
    return Lava.shared.handleDeepLink(url: url)
}
```

To present a pass deep link yourself, see [Handle a pass deep link as a view controller](pass.md#handle-a-pass-deep-link-as-a-view-controller).

### Check if a link can be handled

| Personal information consent | Collected data |
| --- | --- |
| Strictly Necessary | Access token |

Call `canHandleDeepLink` before asking the SDK to open a link. Use this when the app, or another library, also handles deep links.

```swift
public func canHandleDeepLink(url: URL) -> Bool
```

**Usage**

```swift
func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
) -> Bool {
    if Lava.shared.canHandleDeepLink(url: url) {
        return Lava.shared.handleDeepLink(url: url)
    } else {
        return true
    }
}
```

## Universal Link

Universal Links are the preferred way to deep link into the app.

### 1. Set up the associated domain

Serve a static JSON file at:

```text
https://<fully qualified domain>/.well-known/apple-app-site-association
```

```json
{
  "applinks": {
    "details": [
      {
        "appIDs": ["Your app ID"],
        "components": [
          {
            "/": "/lava/inapp/pass",
            "comment": "Support LAVA in-app pass"
          }
        ]
      }
    ]
  }
}
```

Add the Associated Domains entitlement in Xcode. See Apple's guide on [supporting associated domains](https://developer.apple.com/documentation/Xcode/supporting-associated-domains).

### 2. Respond to a Universal Link in `AppDelegate`

```swift
func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
) -> Bool {
    guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
          let incomingURL = userActivity.webpageURL else {
        return false
    }

    let handled = Lava.shared.handleDeepLink(url: incomingURL)

    if handled == false {
        // Handle other deep links in the app
    }

    return true
}
```

## Consistency of deep links between iOS and Android

When you ship both an iOS app and an Android app, pick a scheme and host so both apps open the same links the same way.

- Option 1: both Android and iOS use a custom URL scheme.
- Option 2: Android uses App Links, and iOS uses Universal Links.

---

[Integration guide](README.md) · [Previous: Debug information](debug.md) · [Next: Authentication and profile](authentication.md)
