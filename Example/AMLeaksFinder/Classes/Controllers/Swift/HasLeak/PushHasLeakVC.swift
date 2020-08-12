//
//  PushHasLeakVC.swift
//  AMLeaksFinder_Example
//
//  Created by liangdahong on 2020/8/12.
//  Copyright © 2020 ios@liangdahong.com. All rights reserved.
//

import UIKit

class PushHasLeakVC: AMBaseVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 存在泄漏
        topView.didClickBlock = {
            self.navigationController?.popViewController(animated: true)
        }
    // 正确的方式
    //        topView.didClickBlock = { [weak self] in
    //            self?.navigationController?.popViewController(animated: true)
    //        }
    }
}
