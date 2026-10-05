# Track

[Integration guide](README.md)

## Track events

| Personal information consent | Collected data |
| --- | --- |
| Strictly Necessary, Targeting | Access token, user activities |

```swift
public func track(event: TrackEvent)
```

**Usage**

```swift
let event = TrackEvent(
    action: TrackEvent.ACTION_VIEW_SCREEN,
    category: "HOME",
    trackerType: TrackEvent.TRACKER_TYPE_EVENT
)

Lava.shared.track(event: event)
```

```swift
public struct TrackEvent: Codable {
    public static let TRACKER_TYPE_EVENT = "event"
    public static let ACTION_VIEW_SCREEN = "ViewScreen"

    var action: String? = nil
    var category: String? = nil
    var metaData: [String: String]? = nil
    var path: String? = nil
    var tags: [String]? = nil
    var trackerType: String? = TRACKER_TYPE_EVENT
    var userParams: [String: String]? = nil
}
```

---

[Integration guide](README.md) · [Previous: Message inbox](message-inbox.md) · [Next: Secure member token](secure-token.md)
