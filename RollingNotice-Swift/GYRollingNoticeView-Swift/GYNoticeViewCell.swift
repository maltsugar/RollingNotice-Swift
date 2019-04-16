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
    
    
    /// leading >= 0
    open var textLabelLeading: CGFloat
    /// trailing >= 0
    open var textLabelTrailing: CGFloat
    
    
    public required init(reuseIdentifier: String?, textLabelLeading: CGFloat = 10, textLabelTrailing: CGFloat = 10){
        
        self.textLabelLeading = textLabelLeading
        self.textLabelTrailing = textLabelTrailing
        self.reuseIdentifier = reuseIdentifier
        
        
        super.init(frame: .zero)
        
        if GYRollingDebugLog {
            print(String(format: "init a cell from code: %p", self))
        }
        
        setupInitialUI()
    }
    
    public required init?(coder aDecoder: NSCoder){
        self.textLabelLeading = 10
        self.textLabelTrailing = 10
        super.init(coder: aDecoder)
        if GYRollingDebugLog {
            print(String(format: "init a cell from xib: %p", self))
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if isAddedContentView {
            self.contentView.frame = self.bounds
            
            var lead = textLabelLeading
            if lead < 0 {
                lead = 0
            }
            var trai = textLabelTrailing
            if trai < 0 {
                trai = 0
            }

            var width = self.frame.size.width - lead - trai
            if width < 0 {
                width = 0
            }
            self.textLabel.frame = CGRect(x: lead, y: 0, width: width, height: self.frame.size.height)
        }
        
    }
    
    deinit {
        
        if GYRollingDebugLog {
            print(String(format: "cell deinit %p", self))
        }
    }
}

extension GYNoticeViewCell{
    fileprivate func setupInitialUI() {
        self.backgroundColor = UIColor.white
    }
}
