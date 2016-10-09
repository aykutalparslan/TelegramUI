import Postbox
import TelegramCore

enum ChatHistoryEntry: Identifiable, Comparable {
    case HoleEntry(MessageHistoryHole)
    case MessageEntry(Message, Bool)
    case UnreadEntry(MessageIndex)
    
    var stableId: UInt64 {
        switch self {
            case let .HoleEntry(hole):
                return UInt64(hole.stableId) | ((UInt64(1) << 40))
            case let .MessageEntry(message, _):
                return UInt64(message.stableId) | ((UInt64(2) << 40))
            case .UnreadEntry:
                return UInt64(3) << 40
        }
    }
    
    var index: MessageIndex {
        switch self {
            case let .HoleEntry(hole):
                return hole.maxIndex
            case let .MessageEntry(message, _):
                return MessageIndex(message)
            case let .UnreadEntry(index):
                return index
        }
    }
}

func ==(lhs: ChatHistoryEntry, rhs: ChatHistoryEntry) -> Bool {
    switch lhs {
        case let .HoleEntry(lhsHole):
            switch rhs {
            case let .HoleEntry(rhsHole) where lhsHole == rhsHole:
                return true
            default:
                return false
            }
        case let .MessageEntry(lhsMessage, lhsRead):
            switch rhs {
                case let .MessageEntry(rhsMessage, rhsRead) where MessageIndex(lhsMessage) == MessageIndex(rhsMessage) && lhsMessage.flags == rhsMessage.flags && lhsRead == rhsRead:
                    if lhsMessage.media.count != rhsMessage.media.count {
                        return false
                    }
                    for i in 0 ..< lhsMessage.media.count {
                        if !lhsMessage.media[i].isEqual(rhsMessage.media[i]) {
                            return false
                        }
                    }
                    return true
                default:
                    return false
            }
        case let .UnreadEntry(lhsIndex):
            switch rhs {
            case let .UnreadEntry(rhsIndex) where lhsIndex == rhsIndex:
                return true
            default:
                return false
            }
        }
}

func <(lhs: ChatHistoryEntry, rhs: ChatHistoryEntry) -> Bool {
    let lhsIndex = lhs.index
    let rhsIndex = rhs.index
    if lhsIndex == rhsIndex {
        return lhs.stableId < rhs.stableId
    } else {
        return lhsIndex < rhsIndex
    }
}