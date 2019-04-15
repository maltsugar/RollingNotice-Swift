//
//  CustomNoticeCell.swift
//  RollingNotice-Swift
//
//  Created by qm on 2017/12/15.
//  Copyright © 2017年 qm. All rights reserved.
//

import UIKit

class CustomNoticeCell: GYNoticeViewCell {

    @IBOutlet weak var tailIconImgView: UIImageView!
    @IBOutlet weak var tagLab0: UILabel!
    @IBOutlet weak var titleLab0: UILabel!
    @IBOutlet weak var tagLab1: UILabel!
    @IBOutlet weak var titleLab1: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tagLab0.layer.borderColor = UIColor.orange.cgColor
        tagLab0.layer.borderWidth = 0.5
        tagLab0.layer.cornerRadius = 3
        
        tagLab1.layer.borderColor = UIColor.orange.cgColor
        tagLab1.layer.borderWidth = 0.5
        tagLab1.layer.cornerRadius = 3
    }
    
    public func noticeCellWith(array: Array<Dictionary<String,Any> >, forIndex index: Int) {
        let dic = array[index]
        tailIconImgView.image = UIImage.init(named: dic["img"] as! String)
        tagLab0.text = ((dic["arr"] as! Array<Dictionary<String,Any> >).first as! Dictionary)["tag"]
        titleLab0.text = ((dic["arr"] as! Array<Dictionary<String,Any> >).first as! Dictionary)["title"]
        
        tagLab1.text = ((dic["arr"] as! Array<Dictionary<String,Any> >).last as! Dictionary)["tag"]
        titleLab1.text = ((dic["arr"] as! Array<Dictionary<String,Any> >).last as! Dictionary)["title"]

    }
    
}
