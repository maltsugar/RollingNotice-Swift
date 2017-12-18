//
//  GYNoticeViewCell.swift
//  RollingNotice-Swift
//
//  Created by qm on 2017/12/14.
//  Copyright © 2017年 qm. All rights reserved.
//

import UIKit

open class GYNoticeViewCell: UIView {
    
    open private(set) var contentView: UIView?
    
    open private(set) var textLabel: UILabel?
    
    @objc open private(set) var reuseIdentifier: String?
    
    public required init(reuseIdentifier: String?){
        super.init(frame: CGRect.zero)
        print("init a cell from code: %p", self)
        self.reuseIdentifier = reuseIdentifier
        setupInitialUI()
    }
    
    public required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        print("init a cell from xib")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView?.frame = self.bounds
        self.textLabel?.frame = CGRect.init(x: 10, y: 0, width: self.frame.size.width - 20, height: self.frame.size.height)
    }
    
    deinit {
        print(#function)
    }
}

extension GYNoticeViewCell{
    fileprivate func setupInitialUI() {
        self.backgroundColor = UIColor.white
        self.contentView = UIView()
        self.addSubview(self.contentView!)
        self.textLabel = UILabel()
        self.contentView!.addSubview(self.textLabel!)
        
        self.contentView!.backgroundColor = UIColor.white
    }
}
