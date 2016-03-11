//
//  KCFloatingActionButton.swift
//
//  Created by LeeSunhyoup on 2015. 10. 4..
//  Copyright © 2015년 kciter. All rights reserved.
//

import UIKit

/**
 Floating Action Button Object. It has `KCFloatingActionButtonItem` objects.
 KCFloatingActionButton support storyboard designable.
 */
@IBDesignable
public class KCFloatingActionButton: UIView {
    // MARK: - Properties

    /**
    `KCFloatingActionButtonItem` objects.
    */
    public var items: [KCFloatingActionButtonItem] = []

    /**
     Button color.
     */
    @IBInspectable public var buttonColor: UIColor = UIColor(red: 73/255.0, green: 151/255.0, blue: 241/255.0, alpha: 1) {
        didSet {
            circleLayer.backgroundColor = buttonColor.CGColor
        }
    }

    /**
     Plus icon color inside button.
     */
    @IBInspectable public var plusColor: UIColor = UIColor(white: 0.2, alpha: 1) {
        didSet {
            plusLayer.strokeColor = plusColor.CGColor
        }
    }

    /**
     Background overlaying color.
     */
    @IBInspectable public var overlayColor: UIColor = UIColor.blackColor().colorWithAlphaComponent(0.3) {
        didSet {
            overlayLayer.backgroundColor = overlayColor.CGColor
        }
    }

    /**
     The space between the item and item.
     */
    @IBInspectable public var itemSpace: CGFloat = 14

    /**
     Child item's default size.
     */
    @IBInspectable public var itemSize: CGFloat = 42

    /**
     Child item's default button color.
     */
    @IBInspectable public var itemButtonColor: UIColor = UIColor.whiteColor()

    /**
     Child item's default shadow color.
     */
    @IBInspectable public var itemShadowColor: UIColor = UIColor.blackColor()

    /**

     */
    public var closed: Bool = true

    /**
     Button shape layer.
     */
    private var circleLayer: CAShapeLayer = CAShapeLayer()

    /**
     Plus icon shape layer.
     */
    private var plusLayer: CAShapeLayer = CAShapeLayer()

    /**
     If you keeping touch inside button, button overlaid with tint layer.
     */
    private var tintLayer: CAShapeLayer = CAShapeLayer()

    /**
     If you show items, background overlaid with overlayColor.
     */
    private var overlayLayer: CAShapeLayer = CAShapeLayer()

    // MARK: - Initialize

    /**
    Initialize with custom frame.
    */
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    /**
     Initialize from storyboard.
     */
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        backgroundColor = UIColor.clearColor()
        clipsToBounds = false
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.mainScreen().scale
        setOverlayLayer()
        setCircleLayer()
        setPlusLayer()
        setShadow()
    }

    /**
     Items open.
     */
    public func open() {
        UIView.animateWithDuration(0.3, delay: 0,
            usingSpringWithDamping: 0.55,
            initialSpringVelocity: 0.3,
            options: [.CurveEaseInOut], animations: { () -> Void in
                self.plusLayer.transform = CATransform3DMakeRotation(self.degreesToRadians(-45), 0.0, 0.0, 1.0)
                self.overlayLayer.opacity = 1
            }, completion: nil)

        var itemHeight: CGFloat = 0
        var delay = 0.0
        for item in items {
            if item.hidden == true { continue }
            itemHeight += item.size
            itemHeight += self.itemSpace
            item.frame.origin = CGPointMake(self.bounds.height/2-item.size/2, -itemHeight)
            item.layer.transform = CATransform3DMakeScale(0.4, 0.4, 1)
            UIView.animateWithDuration(0.3, delay: delay,
                usingSpringWithDamping: 0.55,
                initialSpringVelocity: 0.3,
                options: [.CurveEaseInOut], animations: { () -> Void in
                    item.layer.transform = CATransform3DMakeScale(1, 1, 1)
                    item.alpha = 1
                }, completion: nil)

            delay += 0.1
        }
        closed = false
    }

    /**
     Items close.
     */
    public func close() {
        UIView.animateWithDuration(0.3, delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.8,
            options: [], animations: { () -> Void in
                self.plusLayer.transform = CATransform3DMakeRotation(self.degreesToRadians(0), 0.0, 0.0, 1.0)
                self.overlayLayer.opacity = 0
            }, completion: nil)

        var delay = 0.0
        for item in items.reverse() {
            if item.hidden == true { continue }
            UIView.animateWithDuration(0.15, delay: delay, options: [], animations: { () -> Void in
                item.layer.transform = CATransform3DMakeScale(0.4, 0.4, 1)
                item.alpha = 0
                }, completion: nil)
            delay += 0.1
        }
        closed = true
    }

    /**
     Items open or close.
     */
    public func toggle() {
        if closed == true {
            open()
        } else {
            close()
        }
    }

    /**
     Add custom item
     */
    public func addItem(item item: KCFloatingActionButtonItem) {
        item.alpha = 0
        items.append(item)
        addSubview(item)
    }

    /**
     Add item with title.
     */
    public func addItem(title title: String) -> KCFloatingActionButtonItem {
        let item = KCFloatingActionButtonItem()
        itemDefaultSet(item)
        item.title = title
        addItem(item: item)
        return item
    }

    /**
     Add item with title and icon.
     */
    public func addItem(title: String, icon: UIImage) -> KCFloatingActionButtonItem {
        let item = KCFloatingActionButtonItem()
        itemDefaultSet(item)
        item.title = title
        item.icon = icon
        addItem(item: item)
        return item
    }

    /**
     Add item with title, icon or handler.
     */
    public func addItem(title: String, icon: UIImage, handler: ((KCFloatingActionButtonItem) -> Void)) -> KCFloatingActionButtonItem {
        let item = KCFloatingActionButtonItem()
        itemDefaultSet(item)
        item.title = title
        item.icon = icon
        item.handler = handler
        addItem(item: item)
        return item
    }

    /**
     Add item with icon.
     */
    public func addItem(icon icon: UIImage) -> KCFloatingActionButtonItem {
        let item = KCFloatingActionButtonItem()
        itemDefaultSet(item)
        item.icon = icon
        addItem(item: item)
        return item
    }

    /**
     Add item with icon and handler.
     */
    public func addItem(icon: UIImage, handler: ((KCFloatingActionButtonItem) -> Void)) -> KCFloatingActionButtonItem {
        let item = KCFloatingActionButtonItem()
        itemDefaultSet(item)
        item.icon = icon
        item.handler = handler
        addItem(item: item)
        return item
    }

    /**
     Remove item.
     */
    public func removeItem(item item: KCFloatingActionButtonItem) {
        guard let index = items.indexOf(item) else { return }
        items[index].removeFromSuperview()
        items.removeAtIndex(index)
    }

    /**
     Remove item with index.
     */
    public func removeItem(index index: Int) {
        items[index].removeFromSuperview()
        items.removeAtIndex(index)
    }

    public override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        if closed == false {
            for item in items {
                if item.hidden == true { continue }
                let itemPoint = item.convertPoint(point, fromView: self)
                if let itemView = item.hitTest(itemPoint, withEvent: event) {
                    return itemView
                }
            }

            let buttonPoint = self.convertPoint(point, fromView: self)
            if CGRectContainsPoint(self.bounds, buttonPoint) == false {
                close()
                return super.hitTest(point, withEvent: event)
            }
        }

        return super.hitTest(point, withEvent: event)
    }

    override public var bounds: CGRect {
        didSet {

            let size = min(bounds.size.width, bounds.size.height)

            circleLayer.frame = CGRectMake(0, 0, size, size)
            circleLayer.cornerRadius = size/2

            plusLayer.frame = CGRectMake(0, 0, size, size)
            plusLayer.path = plusBezierPath(size).CGPath

            tintLayer.frame = CGRectMake(0, 0, size, size)
            tintLayer.cornerRadius = size/2
        }
    }

    public override func layoutSubviews() {
        superview?.layoutSubviews()
        let point = convertPoint(CGPointZero, fromView: self.window)
        overlayLayer.frame = CGRectMake(point.x,
            point.y,
            UIScreen.mainScreen().bounds.width,
            UIScreen.mainScreen().bounds.height
        )
    }

    private func setCircleLayer() {
        circleLayer.removeFromSuperlayer()
        circleLayer.backgroundColor = buttonColor.CGColor
        layer.addSublayer(circleLayer)
    }

    private func setPlusLayer() {
        plusLayer.removeFromSuperlayer()
        plusLayer.lineCap = kCALineCapRound
        plusLayer.strokeColor = plusColor.CGColor
        plusLayer.lineWidth = 2.0
        layer.addSublayer(plusLayer)
    }

    private func plusBezierPath(size: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(size/2, size/3))
        path.addLineToPoint(CGPointMake(size/2, size-size/3))
        path.moveToPoint(CGPointMake(size/3, size/2))
        path.addLineToPoint(CGPointMake(size-size/3, size/2))
        return path
    }


    private func setTintLayer() {
        tintLayer.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2).CGColor
        layer.addSublayer(tintLayer)
    }

    private func setOverlayLayer() {
        overlayLayer.removeFromSuperlayer()
        overlayLayer.backgroundColor = overlayColor.CGColor
        overlayLayer.opacity = 0
        overlayLayer.zPosition = -1
        layer.addSublayer(overlayLayer)
    }

    private func setShadow() {
        layer.shadowOffset = CGSizeMake(1, 1)
        layer.shadowRadius = 2
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.4
    }

    private func itemDefaultSet(item: KCFloatingActionButtonItem) {
        item.buttonColor = itemButtonColor
        item.circleShadowColor = itemShadowColor
        item.titleShadowColor = itemShadowColor
        item.size = itemSize
    }

    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        if touches.count == 1 {
            let touch = touches.first
            if touch?.tapCount == 1 {
                if touch?.locationInView(self) == nil { return }
                setTintLayer()
            }
        }
    }

    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        if touches.count == 1 {
            let touch = touches.first
            if touch?.tapCount == 1 {
                if touch?.locationInView(self) == nil { return }
                setTintLayer()
            }
        }
    }

    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)

        tintLayer.removeFromSuperlayer()
        if touches.count == 1 {
            let touch = touches.first
            if touch?.tapCount == 1 {
                if touch?.locationInView(self) == nil { return }
                toggle()
            }
        }
    }
}

extension KCFloatingActionButton {
    private func degreesToRadians(degrees: CGFloat) -> CGFloat {
        return degrees / 180.0 * CGFloat(M_PI)
    }
}
