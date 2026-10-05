# SDK message callback

[Integration guide](README.md)

Since version 2.0.30, the SDK can send messages to the host app. Initialize with a callback, or set one later. The SDK keeps only the last callback you set.

`MessageType` identifies the message:

```swift
public enum MessageType: String {
    case passClosed = "pass_closed"
    case passContainerClosed = "pass_container_closed"
}
```

| Message type | Use case |
| --- | --- |
| `passClosed` | After the in-app pass content is rendered, a tap on the close button is delivered through `onSdkMessage`. |
| `passContainerClosed` | After the in-app pass container is closed by the user, or because of an error, the message is delivered through `onSdkMessage`. |

## Initialize the SDK with the callback

Pass the callback to `initialize`. The full parameter list is in [Initialization](initialization.md). The callback-focused form is:

```swift
public static func initialize(
    appKey: String,
    clientId: String,
    logLevel: LavaLogLevel = .warn,
    onSdkMessage: OnSdkMessage? = nil
)
```

```swift
public typealias OnSdkMessage = (_ messageType: String, _ message: String) -> Void
```

**Usage**

```swift
Lava.initialize(
    appKey: lavaConfig.appKey,
    clientId: lavaConfig.clientId,
    logLevel: .error,
    onSdkMessage: { messageType, message in
        if messageType == MessageType.passClosed.rawValue {
            let event = TrackEvent(
                category: "DEBUG",
                path: message,
                trackerType: "log"
            )

            Lava.shared.track(event: event)
        }
    }
)
```

## Set the SDK message callback

You can also set the callback later, in the place that needs it. For example, put it on a view controller if the message should trigger navigation.

```swift
public func setOnSdkMessage(_ onSdkMessage: @escaping OnSdkMessage)
```

**Usage**

```swift
Lava.shared.setOnSdkMessage { messageType, message in
    if messageType == MessageType.passClosed.rawValue {
        let event = TrackEvent(
            category: "DEBUG",
            path: message,
            trackerType: "log"
        )

        Lava.shared.track(event: event)
    }
}
```

---

[Integration guide](README.md) · [Previous: Pass](pass.md)
