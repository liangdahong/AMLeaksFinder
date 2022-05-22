
import UIKit

fileprivate var key: UInt8?

class WhitelistVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objc_setAssociatedObject(self, &key, self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

