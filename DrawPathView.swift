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
    optional func viewDrawStartedDrawing()
    /// Triggered when user just finished  drawing
    optional func viewDrawEndedDrawing()
}

public class DrawPathView: UIView {
    
    /// A counter to determine if there are enough points to make a quadcurve
    private var ctr = 0
    
    /// The path to stroke
    private var path : UIBezierPath?
    
    /// After the user lifts their finger and the line has been finished the same line is rendered to an image and the UIBezierPath is cleared to prevent performance degradation when lots of lines are on screen
    private var incrementalImage : UIImage?
    
    /// Initial Image If user needs to draw lines on image firstly
    private var initialImage : UIImage?
    
    /// This array stores the points that make each line
    private lazy var pts = Array<CGPoint!>(count: 5, repeatedValue: nil)
    
    var delegate : DrawPathViewDelegate?
    
    /// Stroke color of drawing path, default is red.
    var strokeColor = UIColor.redColor()
    
    /// Stores all ımages to get back to last - 1 image. Becase erase last needs this :)
    private var allImages = Array<UIImage>()
    
    // MARK: - Initialize -
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.multipleTouchEnabled = true
        self.backgroundColor = UIColor.whiteColor()
        createPath()
    }
    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        self.multipleTouchEnabled = true
        self.backgroundColor = UIColor.whiteColor()
        createPath()
    }
    
    convenience init(initialImage: UIImage) {
        self.init()
        self.incrementalImage = initialImage
        self.initialImage = initialImage;
        self.multipleTouchEnabled = true
        self.backgroundColor = UIColor.whiteColor()
        if let img = incrementalImage {
            img.drawInRect(self.bounds)
        }
        createPath()
    }
    
    // MARK: - Setup -
    
    private func createPath() {
        path = UIBezierPath()
        path!.lineWidth = 2
    }
    
    /// Erases All paths
    func clearAll() {
        allImages.removeAll()
        ctr = 0
        path?.removeAllPoints()
        path = nil
        incrementalImage = initialImage
        createPath()
        setNeedsDisplay()
    }
    
    /// Erases Last Path
    func clearLast() {
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
    
    internal func changeStrokeColor(color:UIColor!) {
        strokeColor = color
    }
    
    // MARK: - Draw Method -
    
    override public func drawRect(rect: CGRect) {
        if let img = incrementalImage {
            img.drawInRect(rect)
            strokeColor.setStroke()
            if let pth = path {
                pth.stroke()
            }
        } else {
            let rectPth = UIBezierPath(rect: self.bounds)
            UIColor.whiteColor().setFill()
            rectPth.fill()
        }
    }
    
    // MARK: - Touch Events -
    
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        delegate?.viewDrawStartedDrawing?()
        
        ctr = 0
        let touch =  touches.first
        let p = (touch?.locationInView(self))!
        pts[0] = p
        if let pth = path {
            pth.moveToPoint(p)
        }
        drawBitmap(false)
    }
    
    override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch =  touches.first
        let p = (touch?.locationInView(self))!
        ctr++
        pts[ctr] = p
        
        if ctr == 4 {
            // move the endpoint to the middle of the line joining the second control point of the first Bezier segment and the first control point of the second Bezier segment
            pts[3] = CGPointMake((pts[2].x + pts[4].x)/2.0, (pts[2].y + pts[4].y)/2.0)
            if let pth = path {
                pth.moveToPoint(pts[0])
                pth.addCurveToPoint(pts[3], controlPoint1: pts[1], controlPoint2: pts[2])
            }
            setNeedsDisplay()
            pts[0] = pts[3]
            pts[1] = pts[4]
            ctr = 1
        }
    }
    
    override public func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        touchesEnded(touches!, withEvent: event)
    }
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        delegate?.viewDrawEndedDrawing?()
        drawBitmap(true)
        setNeedsDisplay()
        if let pth = path {
            pth.removeAllPoints()
        }
        ctr = 0
    }
    
    // MARK: - Bitmap -
    
    func drawBitmap(endDrawing:Bool) {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0.0)
        drawRect(self.bounds)
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
