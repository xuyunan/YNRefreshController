//
//  YNMoreController.swift
//  YNRefreshController
//
//  Created by Tommy on 15/3/13.
//  Copyright (c) 2015年 xu_yunan@163.com. All rights reserved.
//

import Foundation
import UIKit

typealias YNRefreshHandler = () -> Void

enum YNRefreshState : Printable {
    case Normal
    case Loading
    case Dragging;
    
    var description: String {
        get {
            switch self {
            case .Normal:
                return "Normal"
            case .Loading:
                return "Loading"
            case .Dragging:
                return "Dragging"
            }
        }
    }
}

class YNMoreController : NSObject {
    
    let refreshView: YNRefreshView!
    let scrollView: UIScrollView!
    var originalInsetBottom: CGFloat!
    var newInsetBottom: CGFloat {
        get {
            return originalInsetBottom + additionalInsetBottom
        }
    }
    var additionalInsetBottom: CGFloat {
        get {
            return self.refreshView.bounds.height
        }
    }
    
    var refreshState: YNRefreshState = .Normal {
        didSet {
            if oldValue != self.refreshState {
                self.refreshStateDidChanged(self.refreshState)
            }
        }
    }
    
    var isLoading: Bool {
        get {
            return self.refreshState == .Loading
        }
    }
    
    var refreshHandler: YNRefreshHandler?
    
    init(scrollView: UIScrollView) {
        super.init()
        self.scrollView = scrollView
        self.originalInsetBottom = scrollView.contentInset.bottom
        self.refreshView = YNRefreshView()
        refreshView.textLabel.text = "上拉加载更多..."
        scrollView.addSubview(refreshView)
        layoutSubviews()
        addObservers()
    }

    func layoutSubviews() {
        var frame = refreshView.frame
        frame.origin.y = scrollView.contentSize.height
        refreshView.frame = frame
    }
    
    func addObservers() {
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.New, context: nil)
        scrollView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    func removeObservers() {
        scrollView.removeObserver(self, forKeyPath: "contentOffset")
        scrollView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "contentOffset" {
            
            if scrollView.contentOffset.y > 0 && scrollView.contentSize.height > scrollView.bounds.size.height {
                if refreshView.hidden {
                    refreshView.hidden = false
                }
            } else {
                if !refreshView.hidden {
                    refreshView.hidden = true
                }
                return
            }
            
            if !self.isLoading {

                var distanceToBottom = scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentSize.height
                if distanceToBottom > additionalInsetBottom {
                    if scrollView.dragging {
                        self.refreshState = .Dragging
                    } else {
                        self.refreshState = .Loading;
                    }
                } else {
                    self.refreshState = .Normal;
                }
            }
        } else if keyPath == "contentSize" {
            layoutSubviews()
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    func refreshStateDidChanged(newState: YNRefreshState) {
        
        var inset = scrollView.contentInset
        
        switch newState {
        case .Normal:
            inset.bottom = originalInsetBottom
            scrollView.contentInset = inset
            refreshView.textLabel.text = "上拉加载更多..."
        case .Loading:
            inset.bottom = newInsetBottom
            scrollView.contentInset = inset
            refreshView.textLabel.text = "加载中..."
            
            if let refreshHandler = refreshHandler {
                refreshHandler()
            }
        case .Dragging:
            scrollView.contentInset = inset
            refreshView.textLabel.text = "松开加载更多..."
        }
    }
    
    func refreshHandler(handler: YNRefreshHandler) {
        refreshHandler = handler
    }
    
    deinit {
        removeObservers()
    }
}