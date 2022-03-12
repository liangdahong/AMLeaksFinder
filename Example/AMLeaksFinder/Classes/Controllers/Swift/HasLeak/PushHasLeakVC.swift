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
        
        AMLeaksFinder.addLeakCallback { memoryLeakModels, viewMemoryLeakModels in
            print(memoryLeakModels.first?.memoryLeakDeallocModel?.controller ?? "")
            print(viewMemoryLeakModels.first?.viewMemoryLeakDeallocModel?.view ?? "")
            print("vc 泄漏: \(memoryLeakModels.count), view 泄漏：\(viewMemoryLeakModels.count)")
        }
    }
}
