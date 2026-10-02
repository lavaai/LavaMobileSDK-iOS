# Change log

[Integration guide](README.md)

## v2.0.34

### Features

- Handle a Lava pass deep link as a host-owned `UIViewController`. The SDK prepares the pass (page + `linkPass` payload). The host pushes, presents, or embeds it.
- Parse a named portal page from a pass deep link without presenting (`PassPage.parse(fromDeepLink:)`).

Existing `handleDeepLink` still presents the pass (full screen or inset via `setDefaultPassPresentation`). `PassPresentation` does not store host controllers.

## v2.0.33

### Features

- Show the in-app pass as an inset overlay so the host app can keep its own chrome (for example a bottom tab bar) visible and tappable.
- Embed the in-app pass in a host-owned `UIViewController` so the pass can be a real tab in the host layout.
- Open a named portal page (pass, history, benefits, or any page ID provided by the portal).
- Ask the pass whether the user can leave (unfinished forms can block). Force-hide on logout.

Existing `showPass()` / `showPass(useVisibleViewController:onError:)` is unchanged and still opens full screen.

### Deprecated

- `setEmail()` will be removed in future releases. Use `setUserId()` with `id` set to the user email and `type` set to `"email"`.

## v2.0.32

### Features

- Show an error dialog when there are errors loading the in-app pass.
- Track when users open the in-app pass.
- Track when users open LAVA deep links.
- Send a `pass_container_closed` message to the host app when the pass container is closed.

### Enhancements

- Return `false` from `handleNotification` and `handleDeepLink` if the input cannot be handled by LAVA.

### Bug fixes

- Fix the blank screen when the in-app pass web view is terminated by the OS.

---

[Integration guide](README.md) · [Next: Getting started](getting-started.md)
