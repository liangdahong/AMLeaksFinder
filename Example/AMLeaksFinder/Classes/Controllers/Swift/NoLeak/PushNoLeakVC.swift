
//
//  PushNoLeakVC.swift
//  AMLeaksFinder_Example
//
//  Created by liangdahong on 2020/8/12.
//  Copyright © 2020 ios@liangdahong.com. All rights reserved.
//

import UIKit

class PushNoLeakVC: AMBaseVC {

    class VC: UIViewController {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ooooooooo\(NSStringFromClass(VC.self))")
        
        topView.didClickBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
