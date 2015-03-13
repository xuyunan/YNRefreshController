//
//  YNRefreshController.swift
//  YNRefreshController
//
//  Created by Tommy on 15/3/14.
//  Copyright (c) 2015年 xu_yunan@163.com. All rights reserved.
//

import Foundation
import UIKit

class YNRefreshController : NSObject {
    
    var scrollView: UIScrollView!
    
    init(scrollView: UIScrollView) {
        self.scrollView = scrollView
        super.init()
    }
    
    lazy var pullController: YNPullController = {
        return YNPullController()
        }()
    
    lazy var moreController: YNMoreController = {
        return YNMoreController(scrollView: self.scrollView)
        }()
    
    func pullHandler(handler: YNRefreshHandler) {
        // ...
    }

    func moreHandler(handler: YNRefreshHandler) {
        moreController.refreshHandler(handler)
    }
    
    func stopRefreshing() {
        // ...
    }
    
    func stopLoading() {
        self.moreController.refreshState = .Normal
    }
}