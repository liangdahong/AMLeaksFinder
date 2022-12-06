
//
//  PushNoLeakVC.swift
//  AMLeaksFinder_Example
//
//  Created by liangdahong on 2020/8/12.
//  Copyright © 2020 ios@liangdahong.com. All rights reserved.
//

import UIKit

private var key = 0

class PushNoLeakVC: AMBaseVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topView.didClickBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        do {
            let v = LeakView()
            view.addSubview(v)
            v.frame = .init(x: 0, y: 0, width: 100, height: 100)
            objc_setAssociatedObject(v, &key, v, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        do {
            let v = IgnoreLeakView()
            view.addSubview(v)
            v.frame = .init(x: 0, y: 0, width: 100, height: 100)
            objc_setAssociatedObject(v, &key, v, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    class LeakView: UIView { }
    class IgnoreLeakView: UIView { }
}
