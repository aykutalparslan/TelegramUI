import Foundation
import AsyncDisplayKit
import Display
import Postbox
import TelegramCore

class ChatInputPanelNode: ASDisplayNode {
    var account: Account?
    var interfaceInteraction: ChatPanelInterfaceInteraction?
    var peer: Peer?
    
    func updateFrames(transition: ContainedViewLayoutTransition) {
    }
}