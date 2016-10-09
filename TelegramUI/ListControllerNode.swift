import Foundation
import AsyncDisplayKit
import Display

public class ListControllerNode: ASDisplayNode {
    let listView: ListView
    
    override init() {
        self.listView = ListView()
        
        super.init(viewBlock: {
            return UITracingLayerView()
        }, didLoad: nil)
        
        self.addSubnode(self.listView)
    }
    
    func containerLayoutUpdated(_ layout: ContainerViewLayout, navigationBarHeight: CGFloat, transition: ContainedViewLayoutTransition) {
        var duration: Double = 0.0
        var curve: UInt = 0
        switch transition {
            case .immediate:
                break
            case let .animated(animationDuration, animationCurve):
                duration = animationDuration
                switch animationCurve {
                    case .easeInOut:
                        break
                    case .spring:
                        curve = 7
                }
        }
        
        let listViewCurve: ListViewAnimationCurve
        if curve == 7 {
            listViewCurve = .Spring(duration: duration)
        } else {
            listViewCurve = .Default
        }
        
        var insets = layout.insets(options: [.input])
        insets.top += navigationBarHeight
        
        self.listView.bounds = CGRect(x: 0.0, y: 0.0, width: layout.size.width, height: layout.size.height)
        self.listView.position = CGPoint(x: layout.size.width / 2.0, y: layout.size.height / 2.0)
        
        self.listView.deleteAndInsertItems(deleteIndices: [], insertIndicesAndItems: [], updateIndicesAndItems: [], options: [.Synchronous, .LowLatency], scrollToItem: nil, updateSizeAndInsets: ListViewUpdateSizeAndInsets(size: layout.size, insets: insets, duration: duration, curve: listViewCurve), stationaryItemRange: nil, completion: { _ in })
    }
}