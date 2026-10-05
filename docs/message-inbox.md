# Message inbox

[Integration guide](README.md)

| Personal information consent | Collected data |
| --- | --- |
| Strictly Necessary, Functional | Access token |

## Get messages

```swift
public func getMessages(
    onSuccess: @escaping OnSuccessWithData<MessageListResponse>,
    onError: @escaping OnError
)
```

**Usage**

```swift
Lava.shared.getMessages { messageList in
    // Success
} onError: { error in
    // Error
}
```

```swift
public struct MessageListResponse: Codable {
    public var messages: [Message] = []
}

public struct Message: Codable {
    public var title: String?
    public var messageId: String?
    public var read: Bool? = false
    public var payload: String?
    public var createdAt: Date?
    public var expiresAt: Date?

    public func isExpired() -> Bool {
        guard let expiresAt = expiresAt,
              expiresAt >= Date() else {
            return true
        }

        return false
    }
}
```

## Batch delete messages

| Personal information consent | Collected data |
| --- | --- |
| Strictly Necessary, Functional | Access token, message IDs |

```swift
public func batchDeleteMessages(
    messageIds: MessageIds,
    onSuccess: @escaping OnSuccessWithData<String>,
    onError: @escaping OnError
)
```

**Usage**

```swift
Lava.shared.batchDeleteMessages(messageIds: messageIds) { result in
    // Success
} onError: { error in
    // Error
}
```

```swift
public struct MessageIds: Codable {
    public var ids: [String] = []

    public init(ids: [String]) {
        self.ids = ids
    }
}
```

## Mark messages read or unread

| Personal information consent | Collected data |
| --- | --- |
| Strictly Necessary, Functional | Access token, message IDs |

```swift
public func markMessages(
    messageReadUpdate: MessageReadUpdate,
    onSuccess: @escaping OnSuccessWithData<String>,
    onError: @escaping OnError
)
```

**Usage**

```swift
Lava.shared.markMessages(messageReadUpdate: messageReadUpdate) { result in
    // Success
} onError: { error in
    // Error
}
```

```swift
public struct MessageReadUpdate: Codable {
    public var read: Bool = true
    public var ids: [String] = []

    public init(read: Bool, ids: [String]) {
        self.read = read
        self.ids = ids
    }
}
```

## Display a single message

| Personal information consent | Collected data |
| --- | --- |
| Strictly Necessary, Functional | Access token, message ID |

The SDK no longer displays a single inbox message on its own, so the host app controls it. Show it with `showNotification`, then mark it read:

```swift
Lava.shared.showNotification(messageId: messageId, payload: message.payload)

if let messageId = message.messageId {
    let messageUpdate = MessageReadUpdate(
        read: true,
        ids: [messageId]
    )

    Lava.shared.markMessages(messageReadUpdate: messageUpdate) { _ in
        // Reload the message list
    } onError: { err in
        print(err)
    }
}
```

---

[Integration guide](README.md) · [Previous: Push notifications](push-notifications.md) · [Next: Track](track.md)
