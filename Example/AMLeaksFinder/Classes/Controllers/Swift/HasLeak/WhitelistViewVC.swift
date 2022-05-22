
import UIKit

fileprivate var key = 0

class WhitelistViewVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myView = MyView()
        myView.frame = .init(x: 100, y: 100, width: 100, height: 100)
        myView.backgroundColor = .red
        view.addSubview(myView)
        objc_setAssociatedObject(myView, &key, myView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    class MyView: UIView { }
}
