//
//  GYNoticeViewCell.swift
//  RollingNotice-Swift
//
//  Created by qm on 2017/12/14.
//  Copyright © 2017年 qm. All rights reserved.
//

import UIKit

open class GYNoticeViewCell: UIView {
    
    open var contentView: UIView? {
        get {return _contentView}
    }
    fileprivate lazy var _contentView: UIView? = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        self.addSubview(view)
        isAddedContentView = true
        return view
    }()
    
    open var textLabel: UILabel? {
        get {return _textLabel}
    }
    fileprivate lazy var _textLabel: UILabel? = {
        let lab = UILabel()
        self._contentView!.addSubview(lab)
        return lab
    }()
    
    open var reuseIdentifier: String? {
        get{return _reuseIdentifier}
    }
    @objc fileprivate var _reuseIdentifier: String?
    
    fileprivate var isAddedContentView = false
    
    public required init(reuseIdentifier: String?){
        super.init(frame: CGRect.zero)
        print("init a cell from code: %p", self)
        self._reuseIdentifier = reuseIdentifier
        setupInitialUI()
    }
    
    public required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        print("init a cell from xib")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if isAddedContentView {
            self.contentView?.frame = self.bounds
            self.textLabel?.frame = CGRect.init(x: 10, y: 0, width: self.frame.size.width - 20, height: self.frame.size.height)
        }
        
    }
    
    deinit {
        print(#function)
    }
}

extension GYNoticeViewCell{
    fileprivate func setupInitialUI() {
        self.backgroundColor = UIColor.white
    }
}
