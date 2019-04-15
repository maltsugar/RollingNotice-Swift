//
//  GYRollingNoticeView.swift
//  RollingNotice-Swift
//
//  Created by qm on 2017/12/13.
//  Copyright © 2017年 qm. All rights reserved.
//

import UIKit

@objc public protocol GYRollingNoticeViewDataSource : NSObjectProtocol {
    func numberOfRowsFor(roolingView: GYRollingNoticeView) -> Int
    func rollingNoticeView(roolingView: GYRollingNoticeView, cellAtIndex index: Int) -> GYNoticeViewCell
}

@objc public protocol GYRollingNoticeViewDelegate: NSObjectProtocol {
    @objc optional func rollingNoticeView(_ roolingView: GYRollingNoticeView, didClickAt index: Int)
}


open class GYRollingNoticeView: UIView {
    weak open var dataSource : GYRollingNoticeViewDataSource?
    weak open var delegate : GYRollingNoticeViewDelegate?
    open var stayInterval = 2.0
    open private(set) var currentIndex = 0
    
    // MARK: private properties
    private lazy var cellClsDict: Dictionary = { () -> [String : Any] in
        var tempDict = Dictionary<String, Any>()
        return tempDict
    }()
    private lazy var reuseCells: Array = { () -> [GYNoticeViewCell] in
        var tempArr = Array<GYNoticeViewCell>()
        return tempArr
    }()
    
    private var timer: Timer?
    private var currentCell: GYNoticeViewCell?
    private var willShowCell: GYNoticeViewCell?
    private var isAnimating = false
    
    // MARK: -
    open func register(_ cellClass: Swift.AnyClass?, forCellReuseIdentifier identifier: String) {
        self.cellClsDict[identifier] = cellClass
    }
    
    open func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        self.cellClsDict[identifier] = nib
    }
    
    open func dequeueReusableCell(withIdentifier identifier: String) -> GYNoticeViewCell? {
        for cell in self.reuseCells {
            guard let reuseIdentifier = cell.reuseIdentifier else { return nil }
            if reuseIdentifier.elementsEqual(identifier) {
                return cell
            }
        }
        
        if let cellCls = self.cellClsDict[identifier] {
            if let nib = cellCls as? UINib {
                let arr = nib.instantiate(withOwner: nil, options: nil)
                if let cell = arr.first as? GYNoticeViewCell {
                    cell.setValue(identifier, forKeyPath: "reuseIdentifier")
                    return cell
                }
                return nil
            }
            
            if let noticeCellCls = cellCls as? GYNoticeViewCell.Type {
                let cell = noticeCellCls.self.init(reuseIdentifier: identifier)
                return cell
            }
            
        }
        return nil
    }
    
    open func reloadDataAndStartRoll() {
        stopRoll()
        layoutCurrentCellAndWillShowCell()
        
        guard let count = self.dataSource?.numberOfRowsFor(roolingView: self) else {
            return
        }
        
        guard count >= 2 else {
            return
        }
        
        timer = Timer.scheduledTimer(timeInterval: stayInterval, target: self, selector: #selector(GYRollingNoticeView.timerHandle), userInfo: nil, repeats: true)
        if let __timer = timer {
            RunLoop.current.add(__timer, forMode: .common)
        }
        
    }
    
    // 如果想要释放，请在合适的地方停止timer。 If you want to release, please stop the timer in the right place,for example '-viewDidDismiss'
    open func stopRoll() {
        
        if let rollTimer = timer {
            rollTimer.invalidate()
            timer = nil
        }
        
        isAnimating = false
        currentIndex = 0
        currentCell?.removeFromSuperview()
        willShowCell?.removeFromSuperview()
        currentCell = nil
        willShowCell = nil
        self.reuseCells.removeAll()
    }
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNoticeViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNoticeViews()
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
}

// MARK: private funcs
extension GYRollingNoticeView{
    
    @objc fileprivate func timerHandle() {
        if isAnimating {
            return
        }
        layoutCurrentCellAndWillShowCell()
        currentIndex += 1
        
        let w = self.frame.size.width
        let h = self.frame.size.height
        
        isAnimating = true
        UIView.animate(withDuration: 0.5, animations: {
            self.currentCell?.frame = CGRect.init(x: 0, y: -h, width: w, height: h)
            self.willShowCell?.frame = CGRect.init(x: 0, y: 0, width: w, height: h)
        }) { (flag) in
            if let cell0 = self.currentCell, let cell1 = self.willShowCell {
                self.reuseCells.append(cell0)
                cell0.removeFromSuperview()
                self.currentCell = cell1
            }
            self.isAnimating = false
        }
    }
    
    
    fileprivate func layoutCurrentCellAndWillShowCell() {
        guard let count = (self.dataSource?.numberOfRowsFor(roolingView: self)) else { return }
        
        if (currentIndex > count - 1) {
            currentIndex = 0
        }
        
        var willShowIndex = currentIndex + 1
        if (willShowIndex > count - 1) {
            willShowIndex = 0
        }
        //    print(">>>>%d", currentIndex)
        
        let w = self.frame.size.width
        let h = self.frame.size.height
        
//        print("count: \(count),  currentIndex:\(currentIndex)  willShowIndex: \(willShowIndex)")
        
        if currentCell == nil {
            // 第一次没有currentcell
            // currentcell is null at first time
            if let cell = self.dataSource?.rollingNoticeView(roolingView: self, cellAtIndex: currentIndex) {
                currentCell = cell
                cell.frame  = CGRect.init(x: 0, y: 0, width: w, height: h)
                self.addSubview(cell)
            }
            
            return
        }
        
        
        if let cell = self.dataSource?.rollingNoticeView(roolingView: self, cellAtIndex: willShowIndex) {
            willShowCell = cell
            cell.frame = CGRect.init(x: 0, y: h, width: w, height: h)
            self.addSubview(cell)
        }
        
        
        
        guard let _cCell = currentCell, let _wCell = willShowCell else {
            return
        }
        if GYRollingDebugLog {
            print("currentCell  %p", _cCell)
            print("willShowCell %p", _wCell)
        }
        
        let currentCellIdx = self.reuseCells.firstIndex(of: _cCell)
        let willShowCellIdx = self.reuseCells.firstIndex(of: _wCell)
        
        if let index = currentCellIdx {
            self.reuseCells.remove(at: index)
        }
        
        if let index = willShowCellIdx {
            self.reuseCells.remove(at: index)
        }
        
    }
    
    @objc fileprivate func handleCellTapAction(){
        guard let count = self.dataSource?.numberOfRowsFor(roolingView: self) else {
            return
        }
        
        if (currentIndex > count - 1) {
            currentIndex = 0;
        }
        self.delegate?.rollingNoticeView?(self, didClickAt: currentIndex)
    }
    
    fileprivate func setupNoticeViews() {
        self.clipsToBounds = true
        self.addGestureRecognizer(self.createTapGesture())
    }
    
    fileprivate func createTapGesture() -> UITapGestureRecognizer {
        return UITapGestureRecognizer.init(target: self, action: #selector(GYRollingNoticeView.handleCellTapAction))
    }
    
}


