//
//  ViewController.swift
//  DrawPathViewSwiftDemo
//
//  Created by Ahmet Kazim Günay on 15/12/15.
//  Copyright © 2015 Ahmet Kazim Günay. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DrawPathViewDelegate {
    
    lazy var drawView : DrawPathView = {
        let dv = DrawPathView(frame: self.view.bounds)
        dv.lineWidth = 10.0
        dv.delegate = self
        return dv
    }()
    
    final let selectedBorderWidth = CGFloat(3)
    final let bottomViewHeight = CGFloat(44)
    final let buttonHeight = CGFloat(40)
    final let colors = [UIColor.red, UIColor.green, UIColor.orange, UIColor.yellow, UIColor.purple]
    
    // MARK: - View lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(drawView)
        addBottomButtons()
        addTopButtons()
    }
    
    // MARK: - Private -
    
    private func addBottomButtons() {
        
        for i in 0..<colors.count {
            let btn = UIButton(type: UIButtonType.system)
            let buttonContainerWidth = view.frame.size.width
            let xPos = CGFloat(i) * (buttonContainerWidth / 5) + 10
            let yPos = view.frame.size.height - bottomViewHeight
            btn.tag = i
            
            btn.backgroundColor = colors[i]
            btn.frame = CGRect(x:xPos, y:yPos, width:buttonHeight, height:buttonHeight)
            btn.layer.cornerRadius = buttonHeight / 2
            btn.layer.borderColor = UIColor.darkGray.cgColor
            btn.layer.borderWidth = i == 0 ? selectedBorderWidth : 0
            btn.layer.masksToBounds = true
            btn.addTarget(self, action:#selector(btnColorTapped(sender:)), for: .touchUpInside)
            
            view.addSubview(btn)
        }
    }
    
    private func addTopButtons() {
        
        for i in 0..<2 {
            let btn = UIButton(type: UIButtonType.system)
            let buttonContainerWidth = view.frame.size.width
            let xPos = CGFloat(i) * (buttonContainerWidth / 2) + 10
            let yPos = CGFloat(22)
            btn.tag = i
            btn.frame = CGRect(x:xPos, y:yPos, width:buttonContainerWidth / 2 - 30, height:buttonHeight)
            btn.setTitle(i == 0 ? "Erase Last" : "Erase All", for: .normal)
            btn.setTitleColor(UIColor.blue, for: .normal)
            btn.addTarget(self, action:#selector(btnEraseTapped(sender:)), for: .touchUpInside)

            view.addSubview(btn)
        }
    }
    
    // MARK: - Button Actions -
    
    internal func btnColorTapped(sender : UIButton) {
        let index = sender.tag
        let selectedColor = colors[index]
        drawView.changeStrokeColor(selectedColor)
        
        clearButtons()
        sender.layer.borderWidth = selectedBorderWidth
    }
    
    private func clearButtons () {
        for subview in view.subviews {
            if subview is UIButton {
                subview.layer.borderWidth = 0
            }
        }
    }
    
    internal func btnEraseTapped(sender : UIButton) {
        
        let index = sender.tag;
        switch index {
        case 0: drawView.clearLast()
        case 1: drawView.clearAll()
        default:break
        }
    }
    
    // MARK: - DrawPathView Delegate -

    func viewDrawStartedDrawing() {
        print("Started Drawing")
    }
    
    func viewDrawEndedDrawing() {
        print("Ended Drawing")
    }
    
    // MARK: - Memory Management -

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
