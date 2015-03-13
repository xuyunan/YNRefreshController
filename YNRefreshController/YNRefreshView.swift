//
//  YNRefreshView.swift
//  YNRefreshController
//
//  Created by Tommy on 15/3/13.
//  Copyright (c) 2015年 xu_yunan@163.com. All rights reserved.
//

import Foundation
import UIKit

class YNRefreshView: UIView {
    
    var textLabel: UILabel
    
    override init() {
        var width = UIScreen.mainScreen().bounds.size.width;
        textLabel = UILabel(frame: CGRectMake(0, 0, width, 44))
        textLabel.textAlignment = NSTextAlignment.Center
        super.init(frame: CGRectMake(0, 0, width, 44))
        addSubview(textLabel)
        // backgroundColor = UIColor.greenColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}