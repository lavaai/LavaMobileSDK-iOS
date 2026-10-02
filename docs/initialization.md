# Initialization

[Integration guide](README.md)

## Full `initialize` signature

```swift
public static func initialize(
    appKey: String,
    clientId: String,
    logLevel: LavaLogLevel = .warn,
    serverLogLevel: LavaLogLevel = .error,
    piConsentFlags: Set<LavaPIConsentFlag>? = nil,
    customPiConsentMapping: [String: Set<LavaPIConsentFlag>]? = nil,
    customPiConsentFlags: Set<String>? = nil,
    piConsentCallback: OnConsentResult? = nil,
    presentOverlayFunction: PresentOverlayFunction? = nil,
    hostAppUIReady: Bool = true,
    onInitCompleted: OnInitializeCompletion? = nil,
    customUserAgent: String? = nil,
    onSdkMessage: OnSdkMessage? = nil
)
```

| Parameter | Description | Required |
| --- | --- | --- |
| `appKey` | App key, provided by LAVA | Yes |
| `clientId` | Client ID, provided by LAVA | Yes |
| `logLevel` | Development log level | Yes |
| `serverLogLevel` | Log level for SDK logs sent to LAVA, useful for debugging | |
| `piConsentFlags` | Default personal information flags. See [Personal information consent](consent.md). | |
| `customPiConsentMapping` | A custom map of PI consent flag values. Overrides the default consent flags from LAVA. See [Personal information consent](consent.md). | |
| `customPiConsentFlags` | Custom PI consent flags. Override the default consent flags from LAVA. See [Personal information consent](consent.md). | |
| `piConsentCallback` | Called when there is a personal information consent error. See [Personal information consent](consent.md). | |
| `presentOverlayFunction` | Lets the host app control how the push notification overlay is presented. By default the SDK uses the top-most `UIViewController`. | |
| `hostAppUIReady` | When `false`, the host app says when it is ready so the SDK can run actions such as push notifications or deep links. | |
| `onInitCompleted` | Called when the SDK is ready, so the app can run follow-up work such as showing the in-app pass. | |
| `customUserAgent` | Custom user-agent string used by the in-app pass for web features such as SSO. | |
| `onSdkMessage` | Lets the SDK tell the host app about certain events. See [SDK message callback](sdk-messages.md). | |

## Pending UI tasks and initialization callback

LAVA UI work, such as a push notification overlay, waits until your app has finished its own UI setup. By default the SDK assumes the app is ready when you call `Lava.initialize()`. If the app must do other work first, such as network requests, pass `hostAppUIReady: false`:

```swift
Lava.initialize(
    appKey: lavaConfig.appKey,
    clientId: lavaConfig.clientId,
    logLevel: .verbose,
    serverLogLevel: .verbose,
    hostAppUIReady: false,
    onInitCompleted: onLavaSDKInitialized
)

func onLavaSDKInitialized() {
    print("LAVA SDK INITIALIZED")
}
```

- `hostAppUIReady` turns off the default, which assumes the app is ready as soon as the SDK is initialized.
- `onInitCompleted` is the callback the SDK calls when it finishes its own initialization.
- `onLavaSDKInitialized` is that callback. Use it for work that should run on your side.

When the app finishes its initialization, tell the SDK to run pending UI tasks:

```swift
Lava.shared.finishAppInitialization()
```

This signals that the app is ready. The SDK then runs pending UI tasks, including a notification overlay.

## Pending auth tasks

Call SDK APIs such as `showPass()` from the success callback of `setEmail()` when you can. That gives those calls an access token.

Starting in version 2.0.30, pending auth tasks delay API calls until authentication finishes. Use this when a small set of SDK calls should run from a quick action, such as a button tap:

```swift
Lava.shared.setEmail(email: email, onSuccess: {}, onError: { err in })
Lava.shared.showPass()
```

In this snippet, showing the in-app pass is delayed until `setEmail()` succeeds.

---

[Integration guide](README.md) · [Previous: Getting started](getting-started.md) · [Next: Personal information consent](consent.md)
