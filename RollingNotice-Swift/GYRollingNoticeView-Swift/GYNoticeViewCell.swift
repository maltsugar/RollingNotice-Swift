//
//  GYNoticeViewCell.swift
//  RollingNotice-Swift
//
//  Created by qm on 2017/12/14.
//  Copyright © 2017年 qm. All rights reserved.
//

import UIKit


let GYRollingDebugLog = false

open class GYNoticeViewCell: UIView {
    
    open private(set) lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        self.addSubview(view)
        isAddedContentView = true
        return view
    }()
    
    open private(set) lazy var textLabel: UILabel = {
        let lab = UILabel()
        self.contentView.addSubview(lab)
        return lab
    }()
    
    @objc open private(set) var reuseIdentifier: String?
    fileprivate var isAddedContentView = false
    
    public required init(reuseIdentifier: String?){
        super.init(frame: CGRect.zero)
        
        if GYRollingDebugLog {
            print("init a cell from code: %p", self)
        }
        self.reuseIdentifier = reuseIdentifier
        setupInitialUI()
    }
    
    public required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        if GYRollingDebugLog {
            print("init a cell from xib")
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if isAddedContentView {
            self.contentView.frame = self.bounds
            self.textLabel.frame = CGRect.init(x: 10, y: 0, width: self.frame.size.width - 20, height: self.frame.size.height)
        }
        
    }
    
    deinit {
        
        if GYRollingDebugLog {
            print(#function)
        }
    }
}

extension GYNoticeViewCell{
    fileprivate func setupInitialUI() {
        self.backgroundColor = UIColor.white
    }
}
