//
//  ViewController.swift
//  RollingNotice-Swift
//
//  Created by qm on 2017/12/13.
//  Copyright © 2017年 qm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var arr0: Array<Dictionary<String,Any> >?
    var arr1: Array<String>?
    var noticeView0: GYRollingNoticeView?
    var noticeView1: GYRollingNoticeView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let w = UIScreen.main.bounds.size.width
        let lab = UILabel.init(frame: CGRect.init(x: 0, y: 40, width: w, height: 100))
        lab.numberOfLines = 0
        lab.textAlignment = .center
        lab.text = "滚动公告、广告，支持自定义cell，模仿淘宝头条等等。 \nUITableViewCell重用理念，支持请Star!"
        self.view.addSubview(lab)
        
        arr0 = [
            ["arr": [["tag": "手机", "title": "小米千元全面屏：抱歉，久等！625献上"], ["tag": "萌宠", "title": "可怜狗狗被抛弃，苦苦等候主人半年"]], "img": "tb_icon2"],
            ["arr": [["tag": "手机", "title": "三星中端新机改名，全面屏火力全开"], ["tag": "围观", "title": "主人假装离去，狗狗直接把孩子推回去了"]], "img": "tb_icon3"],
            ["arr": [["tag": "园艺", "title": "学会这些，这5种花不用去花店买了"], ["tag": "手机", "title": "华为nova2S发布，剧透了荣耀10？"]], "img": "tb_icon5"],
            ["arr": [["tag": "开发", "title": "iOS 内购最新讲解"], ["tag": "博客", "title": "技术博客那些事儿"]], "img": "tb_icon6"],
            ["arr": [["tag": "招聘", "title": "招聘XX高级开发工程师"], ["tag": "资讯", "title": "如何写一篇好的技术博客"]], "img": "tb_icon7"]
        ]
        arr1 = ["00000", "11111", "22222", "33333", "44444"]
        
        creatRoolingViewWith(arr: arr0!, isFirst: true)
        creatRoolingViewWith(arr: arr1!, isFirst: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.arr1 = ["zzzzzz", "aaaaa", "bbbbb", "ccccc", "ddddd", "eeeeee"]
            self.noticeView1?.reloadDataAndStartRoll()
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
//            self.noticeView0?.stopRoll()
//            self.noticeView1?.stopRoll()
//        }
    }
    
    
    
    
    
}

extension ViewController {
    
    fileprivate func creatRoolingViewWith(arr: Array<Any>, isFirst: Bool) {
        let w = UIScreen.main.bounds.size.width
        var frame = CGRect.init(x: 0, y: 150, width: w, height: 50)
        if !isFirst {
            frame = CGRect.init(x: 0, y: 250, width: w, height: 30)
        }
        
        let noticeView = GYRollingNoticeView.init(frame: frame)
        noticeView.dataSource = self
        noticeView.delegate = self
        self.view.addSubview(noticeView)
        
        if (isFirst) {
            noticeView0 = noticeView
            noticeView.register(UINib.init(nibName: "CustomNoticeCell", bundle: nil), forCellReuseIdentifier: "CustomNoticeCell")
            noticeView.register(UINib.init(nibName: "CustomNoticeCell2", bundle: nil), forCellReuseIdentifier: "CustomNoticeCell2")
            
        }else{
            noticeView1 = noticeView
            noticeView.register(GYNoticeViewCell.self, forCellReuseIdentifier: "GYNoticeViewCell")
        }
        
        noticeView.reloadDataAndStartRoll()
    }
}



extension ViewController: GYRollingNoticeViewDelegate, GYRollingNoticeViewDataSource {
    func numberOfRowsFor(roolingView: GYRollingNoticeView) -> Int {
        if roolingView == noticeView0 {
            return self.arr0!.count
        }else
        {
            return self.arr1!.count
        }
    }
    
    func rollingNoticeView(roolingView: GYRollingNoticeView, cellAtIndex index: Int) -> GYNoticeViewCell {
        
        if roolingView == noticeView0 {
            
            if index < 3 {
                let cell = roolingView.dequeueReusableCell(withIdentifier: "CustomNoticeCell") as! CustomNoticeCell
                cell.noticeCellWith(array: arr0!, forIndex: index)
                return cell
            }
            
            let cell = roolingView.dequeueReusableCell(withIdentifier: "CustomNoticeCell2") as! CustomNoticeCell2
            let dic = arr0![index]
            cell.lab0.text = ((dic["arr"] as! Array).first as Dictionary! )["title"]
            cell.lab1.text = ((dic["arr"] as! Array).last as Dictionary! )["title"]
            return cell
            
        }else
        {
            let cell = roolingView.dequeueReusableCell(withIdentifier: "GYNoticeViewCell")
            cell!.textLabel?.text = arr1![index]
            cell!.contentView?.backgroundColor = UIColor.red
            if index % 2 == 0 {
                cell!.contentView?.backgroundColor = UIColor.orange
            }
            
            return cell!
        }

    }
    
    
    func rollingNoticeView(_ roolingView: GYRollingNoticeView, didClickAt index: Int) {
         print("did click index: \(index)")
    }
    
    
}

