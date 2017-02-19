//
//  DrawPathView.swift
//  DrawPathView
//
//  Created by Ahmet Kazım Günay on 08/10/15.
//  Copyright © 2015 Ahmet Kazım Günay. All rights reserved.
//

import UIKit

@objc public protocol DrawPathViewDelegate {
    /// Triggered when user just started  drawing
    @objc optional func viewDrawStartedDrawing()
    /// Triggered when user just finished  drawing
    @objc optional func viewDrawEndedDrawing()
}

open class DrawPathView: UIView {
    
    /// A counter to determine if there are enough points to make a quadcurve
    fileprivate var ctr = 0
    
    /// The path to stroke
    fileprivate var path : UIBezierPath?
    
    /// After the user lifts their finger and the line has been finished the same line is rendered to an image and the UIBezierPath is cleared to prevent performance degradation when lots of lines are on screen
    fileprivate var incrementalImage : UIImage?
    
    /// Initial Image If user needs to draw lines on image firstly
    fileprivate var initialImage : UIImage?
    
    /// This array stores the points that make each line
    fileprivate lazy var pts = Array<CGPoint!>(repeating: nil, count: 5)
    
    open var delegate : DrawPathViewDelegate?
    
    /// Stroke color of drawing path, default is red.
    fileprivate var strokeColor = UIColor.red
    
    /// Stores all ımages to get back to last - 1 image. Becase erase last needs this :)
    fileprivate var allImages = Array<UIImage>()
    
    public var lineWidth: CGFloat = 2.0 {
        
        didSet {
            createPath()
        }
    }

    
    // MARK: - Initialize -
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.isMultipleTouchEnabled = true
        self.backgroundColor = UIColor.white
        createPath()
    }
    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        self.isMultipleTouchEnabled = true
        self.backgroundColor = UIColor.white
        createPath()
    }
    
    public init(initialImage: UIImage) {
        self.init()
        self.incrementalImage = initialImage
        self.initialImage = initialImage;
        self.isMultipleTouchEnabled = true
        self.backgroundColor = UIColor.white
        if let img = incrementalImage {
            img.draw(in: self.bounds)
        }
        createPath()
    }
    
    // MARK: - Setup -
    
    fileprivate func createPath() {
        path = nil
        path = UIBezierPath()
        path!.lineWidth = lineWidth
    }
    
    /// Erases All paths
    open func clearAll() {
        allImages.removeAll()
        ctr = 0
        path?.removeAllPoints()
        path = nil
        incrementalImage = initialImage
        createPath()
        setNeedsDisplay()
    }
    
    /// Erases Last Path
    open func clearLast() {
        if allImages.count == 0 {
            return
        }
        ctr = 0
        path?.removeAllPoints()
        path = nil
        allImages.removeLast()
        incrementalImage = allImages.last
        createPath()
        setNeedsDisplay()
    }
    
    // MARK: - Change Stroke Color -
    
    open func changeStrokeColor(_ color:UIColor!) {
        strokeColor = color
    }
    
    // MARK: - Draw Method -
    
    override open func draw(_ rect: CGRect) {
        if let img = incrementalImage {
            img.draw(in: rect)
            strokeColor.setStroke()
            if let pth = path {
                pth.stroke()
            }
        } else {
            let rectPth = UIBezierPath(rect: self.bounds)
            UIColor.white.setFill()
            rectPth.fill()
        }
    }
    
    // MARK: - Touch Events -
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        delegate?.viewDrawStartedDrawing?()
        
        ctr = 0
        let touch =  touches.first
        let p = (touch?.location(in: self))!
        pts[0] = p
        if let pth = path {
            pth.move(to: p)
        }
        drawBitmap(false)
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch =  touches.first
        let p = (touch?.location(in: self))!
        ctr += 1
        pts[ctr] = p
        
        if ctr == 4 {
            // move the endpoint to the middle of the line joining the second control point of the first Bezier segment and the first control point of the second Bezier segment
            pts[3] = CGPoint(x: (pts[2].x + pts[4].x)/2.0, y: (pts[2].y + pts[4].y)/2.0)
            if let pth = path {
                pth.move(to: pts[0])
                pth.addCurve(to: pts[3], controlPoint1: pts[1], controlPoint2: pts[2])
            }
            setNeedsDisplay()
            pts[0] = pts[3]
            pts[1] = pts[4]
            ctr = 1
        }
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        delegate?.viewDrawEndedDrawing?()
        drawBitmap(true)
        setNeedsDisplay()
        if let pth = path {
            pth.removeAllPoints()
        }
        ctr = 0
    }
    
    // MARK: - Bitmap -
    
    fileprivate func drawBitmap(_ endDrawing:Bool) {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0.0)
        draw(self.bounds)
        if let pth = path {
            pth.stroke()
        }
        incrementalImage = UIGraphicsGetImageFromCurrentImageContext()
        if endDrawing {
            if let _ = incrementalImage {
                allImages.append(incrementalImage!)
            }
        }
        UIGraphicsEndImageContext()
    }
}
