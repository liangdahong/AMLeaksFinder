//
//  ViewHasLeakVC.swift
//  AMLeaksFinder_Example
//
//  Created by liangdahong on 2022/4/4.
//  Copyright © 2022 ios@liangdahong.com. All rights reserved.
//

import UIKit

class ViewHasLeakVC: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var button: UIButton!
    var key: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objc_setAssociatedObject(bgView, &key, button, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(button, &key, bgView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
