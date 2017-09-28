//
//  ErrorView.swift
//  WhosInCustomerApp
//
//  Created by Jonathan Stone on 6/10/15.
//  Copyright (c) 2015 Jonathan Stone. All rights reserved.
//

import UIKit

open class ErrorView: NSObject
{
    // Controls:
    var view: UIView!
    var parentView: UIView!
    var errorMessageLabel: UILabel!
    var errorMessageDismissButton: UIButton!
    var imageView: UIImageView!
    var positionBelowControl: UIView?
    var font: UIFont?

    // Constraints:
    var mainViewTopSpaceConstraint: NSLayoutConstraint!

    // Variables:
    var hideErrorViewAfterDelayTimer: Timer?
    fileprivate var timeIntervalBeforeAutoHidingErrorView:TimeInterval = 10
    var minimumHeight:CGFloat = 100

    public init(parentView: UIView, autoHideDelaySeconds: Double,
        backgroundColor: UIColor,
        foregroundColor: UIColor,
        minimumHeight: CGFloat,
        positionBelowControl: UIView?,
        font: UIFont?)
    {
        super.init()
        self.parentView = parentView
        timeIntervalBeforeAutoHidingErrorView = autoHideDelaySeconds

        self.minimumHeight = minimumHeight
        self.positionBelowControl = positionBelowControl
        self.font = font

        initSubviews()

        self.view.backgroundColor = backgroundColor
        self.errorMessageLabel.textColor = foregroundColor
        self.view.isHidden = true
    }

    open func showErrorView(_ message: String)
    {
        DispatchQueue.main.async(execute: { () -> Void in
            self.stopErrorViewAutohideTimer()    // If it was already running, reset the autohide timer
            self.view.isHidden = false

            // Set text to the error message.
            self.errorMessageLabel.text = message

            // Begin with message out of view, above the top edge of the parent view:
            self.parentView.layoutIfNeeded()
            self.mainViewTopSpaceConstraint.constant = -self.view.frame.size.height
            self.parentView.layoutIfNeeded()

            // Animate moving down from the top of the view:
            UIView.animate(
                withDuration: 0.8,
                delay: 0,
                options: [.curveEaseIn, .curveEaseOut, .allowUserInteraction],
                animations: self.animateSlidingDown,
                completion: { (done) -> Void in
                    self.startErrorViewAutohideTimer()
            })
        })
    }

    open class func getStandardVerticalSpacing(_ topControl: UIView, bottomControl: UIView)->CGFloat
    {
        let views = ["topview": topControl, "bottomview" : bottomControl]
        let constraints = NSLayoutConstraint.constraints(
            withVisualFormat: "[topview]-[bottomview]",
            options: NSLayoutFormatOptions(),
            metrics: nil,
            views: views)
        return constraints[0].constant
    }

    fileprivate func animateSlidingDown()
    {
        var topOfErrorView: CGFloat = 0
        if let controlAbove = self.positionBelowControl
        {
            let origin = self.parentView.convert(controlAbove.bounds.origin, from: controlAbove)
            let vspacing = ErrorView.getStandardVerticalSpacing(controlAbove, bottomControl: self.view)
            topOfErrorView = origin.y + controlAbove.frame.size.height + vspacing
        }
        else
        {
            topOfErrorView = self.parentView.frame.height - self.view.frame.height
        }

        self.mainViewTopSpaceConstraint.constant = topOfErrorView
        self.parentView.layoutIfNeeded()
    }

    fileprivate func initSubviews()
    {
        self.view = UIView()
        parentView.addSubview(self.view)

        addMessageLabel()
        addCloseButtonVisualHint()

        // Button must be added last. Covers entire view.
        addCloseButton()

        // Add constraints
        setConstraints()
        parentView.layoutIfNeeded()
    }

    fileprivate func addMessageLabel()
    {
        self.errorMessageLabel = LabelWithAutoWrap(font: self.font)
        self.view.addSubview(errorMessageLabel)
    }

    fileprivate func addCloseButtonVisualHint()
    {
        if let image = loadCloseButtonImage()
        {
            self.imageView = UIImageView(image: image)
            self.view.addSubview(imageView)
        }
    }

    fileprivate func addCloseButton()
    {
        self.errorMessageDismissButton = makeDismissButton()
        self.view.addSubview(errorMessageDismissButton)
    }

    fileprivate func loadCloseButtonImage()->UIImage?
    {
        let frameworkBundle = Bundle(for: type(of: self))
        return UIImage(named: "XButton", in: frameworkBundle, compatibleWith: nil)
    }

    fileprivate func makeDismissButton()->UIButton
    {
        let button = UIButton()
        button.addTarget(self, action: #selector(ErrorView.errorMessageDismissButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        return button
    }

    fileprivate func setConstraints()
    {
        let views: [String: UIView] = [
            "view": view,
            "label": errorMessageLabel,
            "image": imageView,
            "button": errorMessageDismissButton
        ]

        for control in views.values
        {
            control.translatesAutoresizingMaskIntoConstraints = false
        }

        let mainViewHConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: NSLayoutFormatOptions(),
            metrics: nil, views: views)
        parentView.addConstraints(mainViewHConstraint)


        let mainViewTopConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: parentView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0 /*32*/)
        parentView.addConstraint(mainViewTopConstraint)
        self.mainViewTopSpaceConstraint = mainViewTopConstraint

        let mainViewVConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.minimumHeight)

        parentView.addConstraint(mainViewVConstraint)

        let imageAspectRatioConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: imageView, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 1)
        imageView.addConstraint(imageAspectRatioConstraint)

        let imageTopConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        view.addConstraint(imageTopConstraint)

        let labelVertConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[label]-|",
            options: NSLayoutFormatOptions(),
            metrics: nil, views: views)
        view.addConstraints(labelVertConstraints)

        let subviewsHorzConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[image]-32.0-[label]-|",
            options: NSLayoutFormatOptions(), metrics: nil, views: views)
        view.addConstraints(subviewsHorzConstraints)

        // An invisible button overlays the entire control. Users will be drawn to tap the X button, but tapping anywhere will dismiss. The X button is just a cue to tell them it can be dismissed.
        let buttonHorzConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[button]|",
            options: NSLayoutFormatOptions(), metrics: nil, views: views)
        view.addConstraints(buttonHorzConstraints)

        let buttonVertConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[button]|",
            options: NSLayoutFormatOptions(), metrics: nil, views: views)
        view.addConstraints(buttonVertConstraints)
    }

    @objc func errorMessageDismissButtonPressed(_ sender: UIButton!)
    {
        hideErrorView()
    }

    func startErrorViewAutohideTimer()
    {
        if (timeIntervalBeforeAutoHidingErrorView > 0)
        {
            if #available(iOS 10.0, *) {
                self.hideErrorViewAfterDelayTimer = Timer.scheduledTimer(
                    withTimeInterval: timeIntervalBeforeAutoHidingErrorView,
                    repeats: false,
                    block: { (theTimer) in
                        self.hideErrorViewTimerFired(theTimer)
                    }
                )
            } else {
                // Fallback on earlier versions
                            self.hideErrorViewAfterDelayTimer = Timer.scheduledTimer(
                                timeInterval: timeIntervalBeforeAutoHidingErrorView,
                                target: self,
                                selector: #selector(self.hideErrorViewTimerFired),
                                userInfo: nil,
                                repeats: false)

            }
        }
    }

    @objc func hideErrorViewTimerFired(_ timer: Timer)
    {
        stopErrorViewAutohideTimer()
        self.hideErrorView()
    }

    func stopErrorViewAutohideTimer()
    {
        self.hideErrorViewAfterDelayTimer?.invalidate()
        self.hideErrorViewAfterDelayTimer = nil
    }

    func hideErrorView()
    {
        stopErrorViewAutohideTimer()
        UIView.animate(withDuration: 0.3,
            delay: 0,
            options: UIViewAnimationOptions.curveEaseInOut,
//            options: UIViewAnimationOptions.TransitionCrossDissolve,
            animations: { () -> Void in
                // Use this to slide up and away instead of fading out:
                //                self.mainViewTopSpaceConstraint.constant = -self.view.frame.size.height
                self.view.alpha = 0
//                self.view.layoutIfNeeded()
            }, completion: {(done)->Void in
                self.view.isHidden = true
                self.view.alpha = 1.0
        })
    }

}
