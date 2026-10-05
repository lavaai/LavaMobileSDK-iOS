# Authentication and profile

[Integration guide](README.md)

By default, when you call `Lava.shared.start()` in `AppDelegate`, the SDK gathers enough information to authenticate the app. That only updates the device identity on the LAVA backend.

To use features such as LAVA push notifications or the in-app pass, authenticate by setting the user email with `setEmail()`, or by setting an external id with `setUserId()`.

## Set email

| Personal information consent | Collected data |
| --- | --- |
| Strictly Necessary, Functional | Email, device ID, device name, device model, IP address, language, notification token, OS version, SDK version, platform, screen size |

> **Deprecated.** `setEmail()` will be removed in a future release. Use [`setUserId()`](#set-user-id) with the email as `id` and `type` set to `"email"`.

Provide a valid email to authenticate as a normal user. After that succeeds, the app can use the rest of the SDK.

To switch users, set the new email. To stop working as the current user (for example on logout), pass `nil`.

```swift
public func setEmail(
    email: String?,
    onSuccess: @escaping OnSuccess,
    onError: @escaping OnError
)
```

**Usage**

```swift
Lava.shared.setEmail(email: email) {
    // Successful
} onError: { error in
    // Error
}
```

### Error handling

If `setEmail` fails, `onError` runs with an `Error`. Use `localizedDescription` in the app.

## Set user ID

| Personal information consent | Collected data |
| --- | --- |
| Strictly Necessary, Functional | Email, device ID, device name, device model, IP address, language, notification token, OS version, SDK version, platform, screen size |

If the app does not use email as the user identity, authenticate with `setUserId`. This is the usual path when users are identified on an external system such as NBA ID. Contact LAVA to configure it.

Use either `setEmail` or `setUserId`, not both.

```swift
public func setUserId(
    id: String?,
    type: String?,
    onSuccess: @escaping OnSuccess,
    onError: @escaping OnError
)
```

| Parameter | Required | Data type | Description |
| --- | --- | --- | --- |
| `id` | No | `String` | External identifier. Can be an email or a UUID. Passing `nil` logs the user out. |
| `type` | No | `String` | External system used to authenticate the user. Can be `email` or `nba_id_encrypted`. `nil` defaults to `email`. |
| `onSuccess` | Yes | `OnSuccess` | Success callback. |
| `onError` | Yes | `OnError` | Error callback. |

**Usage**

```swift
Lava.shared.setUserId(id: id, type: type) {
    // Successful
} onError: { error in
    // Error
}
```

### Error handling

As with `setEmail`, failure calls `onError` with an `Error`. This method also supports NBA ID authentication. In those cases the error is an `NBAIDError`, which has `description` and `errorDescription`.

| `NBAIDError` case | Meaning |
| --- | --- |
| `NBA_ID_00` | NBA ID service not configured for this environment |
| `NBA_ID_01` | Failed to acquire an NBA service token |
| `NBA_ID_02` | NBA account not found |
| `NBA_ID_03` | Ticketmaster account not linked |

```swift
Lava.shared.setUserId(
    id: email,
    type: "nba_id_encrypted"
) {
    // Successful
} onError: { [weak self] error in
    var errorMessage = error.localizedDescription

    if let nbaIDError = error as? NBAIDError {
        switch nbaIDError {
        case .NBA_ID_00:
            errorMessage = "NBA ID service not configured for this environment"
        case .NBA_ID_01:
            errorMessage = "Failed to acquire an NBA service token"
        case .NBA_ID_02:
            errorMessage = "NBA account not found"
        case .NBA_ID_03:
            errorMessage = "Ticketmaster account not linked"
        }
    } else {
        // Handle non NBA ID errors
    }

    self?.showAlert(title: "Error", message: "\(errorMessage)")
}
```

## LAVA user

| Personal information consent | Collected data |
| --- | --- |
| Strictly Necessary, Functional | Access token |

Check whether the app is authenticated for LAVA APIs by reading `LavaUser`:

```swift
public func getLavaUser() -> LavaUser?
```

`nil` means the app is unauthenticated. Otherwise `LavaUser` says whether the user is anonymous or a normal user.

**Usage**

```swift
if let _ = Lava.shared.getLavaUser() {
    // Go to home screen
} else {
    // Go to login screen
}
```

```swift
public struct LavaUser: Codable {
    public var email: String?

    public var isAnonymous: Bool {
        return email == nil
    }

    public var isNormalUser: Bool {
        return email != nil
    }
}
```

## Profile

A regular login (with email) enables editable access to a user's LAVA profile.

### Get profile

| Personal information consent | Collected data |
| --- | --- |
| Strictly Necessary, Functional | Access token, secure member token |

```swift
public func getProfile(
    onSuccess: @escaping OnSuccessWithData<UserProfile>,
    onError: @escaping OnError
)
```

**Usage**

```swift
Lava.shared.getProfile { userProfile in
    // Success
} onError: { error in
    // Error
}
```

```swift
public struct UserProfile: Codable {
    public var firstName: String?
    public var lastName: String?
    public var phoneNumber: String?
}
```

### Update profile

| Personal information consent | Collected data |
| --- | --- |
| Strictly Necessary, Functional | Access token, secure member token, first name, last name, phone number |

Updates merge the fields you send with what the server already has. Updating only the first name leaves the rest of the profile unchanged. Deleting a field is not supported. You can remove the content of a field by providing a non-nil value for it.

```swift
public func updateProfile(
    userProfile: UserProfile,
    onSuccess: @escaping OnSuccessWithData<UserProfile>,
    onError: @escaping OnError
)
```

**Usage**

```swift
Lava.shared.updateProfile(userProfile: userProfile) { userProfile in
    // Success
} onError: { error in
    // Error
}
```

---

[Integration guide](README.md) · [Previous: Deep linking](deep-linking.md) · [Next: Push notifications](push-notifications.md)
