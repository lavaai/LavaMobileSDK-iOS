# Personal information consent

[Integration guide](README.md)

Some SDK functions send personal information (for example an email address) that is covered by privacy regulations. Each feature section lists the consent it needs.

Examples include `setEmail()` and tracking a button click. The SDK exposes two ways for the user to set consent:

1. `initialize()` — pass consent when the app opens.
2. `setPIConsentFlags()` — update the consent list later, when the user changes it in your app.

Keep the consent list in the app and pass it to the SDK when it changes.

## When your app is opening

Pass the initial consent list to `initialize()`. That list applies to anonymous users and is stored by the SDK. After login, call `setPIConsentFlags()` to apply the list for that user.

```swift
public static func initialize(
    appKey: String,
    clientId: String,
    piConsentFlags: Set<LavaPIConsentFlag>? = nil,
    piConsentCallback: OnConsentResult? = nil
)
```

**Usage**

```swift
Lava.initialize(
    appKey: lavaConfig.appKey,
    clientId: lavaConfig.clientId,
    piConsentFlags: [
        LavaPIConsentFlag.strictlyNecessary,
        LavaPIConsentFlag.performanceAndLogging,
        LavaPIConsentFlag.functional,
        LavaPIConsentFlag.targeting
    ],
    piConsentCallback: { err, shouldLogout in
        if err != nil {
            print(err?.localizedDescription ?? "Unknown consent error")
        }

        if shouldLogout {
            // Perform necessary navigation
        }
    }
)
```

> **Notes**
>
> - If the user allows no consent, pass an empty list as `piConsentFlags`.
> - `piConsentFlags` set to `nil`, or omitting the argument, means the user agrees to every consent type.

`LavaPIConsentFlag` has these values:

```swift
public enum LavaPIConsentFlag: String, Codable, CaseIterable {
    case strictlyNecessary = "StrictlyNecessary"
    case performanceAndLogging = "PerformanceAndLogging"
    case functional = "Functional"
    case targeting = "Targeting"
}
```

| Flag | Meaning |
| --- | --- |
| Strictly Necessary | Lets the LAVA backend access and store user identity, including device ID and access token. |
| Performance and Logging | Required for the SDK to report errors and debug information. |
| Functional | Required for most SDK APIs: `setEmail`, `getMessages`, `showNotification`, and similar calls. |
| Targeting | Required if the host app calls `track()`. |

`piConsentCallback` has this type:

```swift
public typealias OnConsentResult = (_ error: Error?, _ shouldLogout: Bool) -> Void
```

If updating the consent list fails, the callback is invoked with an error. Otherwise the first argument is `nil`. `shouldLogout` is `true` when `StrictlyNecessary` is disabled. Use that to drive navigation in the app.

## Required consent for specific features

| Feature | Method | Consent |
| --- | --- | --- |
| Debug information | `getDebugInfo()` | Strictly Necessary, Functional |
| Deep linking | `handleDeepLink()` | Strictly Necessary |
| Deep linking | `canHandleDeepLink()` | Strictly Necessary |
| Authentication | `setEmail()` | Strictly Necessary, Functional |
| Authentication | `getLavaUser()` | Strictly Necessary |
| Profile | `getProfile()` | Strictly Necessary, Functional |
| Profile | `updateProfile()` | Strictly Necessary, Functional |
| Push notifications | `setNotificationToken()` | Strictly Necessary, Functional |
| Push notifications | `handleNotification()` | Strictly Necessary, Functional |
| Push notifications | `canHandlePushNotification()` | Strictly Necessary |
| Push notifications | `setCustomStyle()` | Strictly Necessary |
| Message inbox | `getMessages()` | Strictly Necessary, Functional |
| Message inbox | `batchDeleteMessages()` | Strictly Necessary, Functional |
| Message inbox | `markMessages()` | Strictly Necessary, Functional |
| Message inbox | `showNotification()` | Strictly Necessary, Functional |
| Track | `track()` | Strictly Necessary, Targeting |
| Secure member token | `setSecureMemberToken()` | Strictly Necessary |
| Secure member token | `subscribeSecureMemberTokenExpiry()` | Strictly Necessary |
| Secure member token | `unsubscribeSecureMemberTokenExpiry()` | Strictly Necessary |
| Pass | `showPass()` | Strictly Necessary, Functional |
| Pass | `createPassViewController()` | Strictly Necessary, Functional |
| Pass | `navigatePass()` | Strictly Necessary, Functional |
| Pass | `requestHidePass()` | Strictly Necessary, Functional |
| Pass | `hidePass()` | Strictly Necessary, Functional |

## Update the consent list

After the user changes consent in your app, send the new list to the SDK:

```swift
public func setPIConsentFlags(
    piConsentFlags: Set<LavaPIConsentFlag>,
    piConsentCallback: OnConsentResult?
)
```

`OnConsentResult` works the same way as in `initialize()`.

**Usage**

```swift
Lava.shared.setPIConsentFlags(
    piConsentFlags: itemsToUpdate,
    piConsentCallback: { err, shouldLogout in
        if err != nil {
            print(err?.localizedDescription ?? "Unknown consent error")
        }

        if shouldLogout {
            // Perform necessary navigation
        }
    }
)
```

## Custom consent mapping

You can use your own consent names. Pass a `[String: Set<LavaPIConsentFlag>]` to `initialize()`, plus the set of consent strings that are currently granted:

```swift
public static func initialize(
    appKey: String,
    clientId: String,
    customPiConsentMapping: [String: Set<LavaPIConsentFlag>]? = nil,
    customPiConsentFlags: Set<String>? = nil,
    piConsentCallback: OnConsentResult? = nil
)
```

**Usage**

```swift
Lava.initialize(
    appKey: lavaConfig.appKey,
    clientId: lavaConfig.clientId,
    customPiConsentMapping: [
        "Consent01": [.strictlyNecessary],
        "Consent02": [.performanceAndLogging],
        "Consent03": [.functional],
        "Consent04": [.targeting]
    ],
    customPiConsentFlags: [
        "Consent01",
        "Consent02",
        "Consent03",
        "Consent04",
    ],
    piConsentCallback: { err, shouldLogout in
        print(err?.localizedDescription ?? "Unknown consent error")
    }
)
```

Later, change the granted set with:

```swift
public func setCustomPIConsentFlags(
    customPIConsentFlags: Set<String>,
    piConsentCallback: OnConsentResult?
)
```

**Usage**

```swift
let newConsentList = [
    "Consent01",
    "Consent02",
]

Lava.shared.setCustomPIConsentFlags(
    customPIConsentFlags: consentFlags,
    piConsentCallback: callback
)
```

## Built-in OneTrust consent mapping

The SDK includes a OneTrust mapping you can pass as the custom consent map:

```swift
public final class LavaConsent {
    public static let OneTrustDefaultConsentMapping: [String: Set<LavaPIConsentFlag>] = [
        "C0001": [.strictlyNecessary],
        "C0002": [.performanceAndLogging],
        "C0003": [.functional],
        "C0004": [.targeting],
        "C0005": [],
    ]
}
```

**Usage**

```swift
Lava.initialize(
    appKey: lavaConfig.appKey,
    clientId: lavaConfig.clientId,
    customPiConsentMapping: LavaConsent.OneTrustDefaultConsentMapping,
    customPiConsentFlags: [
        "C0001",
        "C0002",
        "C0003",
        "C0004",
    ],
    piConsentCallback: { err, shouldLogout in
        print(err?.localizedDescription ?? "Unknown consent error")
    }
)
```

---

[Integration guide](README.md) · [Previous: Initialization](initialization.md) · [Next: Debug information](debug.md)
