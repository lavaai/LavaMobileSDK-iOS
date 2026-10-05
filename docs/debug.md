# Debug information

[Integration guide](README.md)

## Get debug information

| Personal information consent | Collected data |
| --- | --- |
| Strictly Necessary, Functional | User ID, email, device ID, device name, device model, IP address, language, notification token, OS version, SDK version, platform, screen size |

```swift
public func getDebugInfo() -> DebugInfo
```

**Usage**

```swift
Lava.shared.getDebugInfo()
```

`DebugInfo` is declared as follows:

```swift
public struct DebugInfo: Codable {
    public var userId: String?
    public var email: String?
    public var firstName: String?
    public var lastName: String?
    public var phoneNumber: String?
    public var userType: String?
    public var notificationToken: String?
    public var authorizationToken: String?
    public var tokenExpiresAt: String?

    public var deviceId: String?
    public var deviceName: String?
    public var deviceModel: String?
    public var language: String?
    public var ipAddress: String?
    public var osVersion: String?
    public var platform: String? = "iOS"
    public var screenWidth: String?
    public var screenHeight: String?

    public var appVersion: String?
    public var sdkVersion: String?
    public var server: String?
}
```

---

[Integration guide](README.md) · [Previous: Personal information consent](consent.md) · [Next: Deep linking](deep-linking.md)
