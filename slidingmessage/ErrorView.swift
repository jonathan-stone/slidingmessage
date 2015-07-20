//
//  ErrorView.swift
//  WhosInCustomerApp
//
//  Created by Jonathan Stone on 6/10/15.
//  Copyright (c) 2015 Jonathan Stone. All rights reserved.
//

import UIKit

public class ErrorView: NSObject
{
    // Controls:
    var view: UIView!
    var parentView: UIView!
    var errorMessageLabel: UILabel!
    var errorMessageDismissButton: UIButton!
    var imageView: UIImageView!
    var positionBelowControl: UIView?

    // Constraints:
    var mainViewTopSpaceConstraint: NSLayoutConstraint!

    // Variables:
    var hideErrorViewAfterDelayTimer: NSTimer?
    private var timeIntervalBeforeAutoHidingErrorView:NSTimeInterval = 10
    var desiredHeight:CGFloat = 100

    public init(parentView: UIView, autoHideDelaySeconds: Double,
        backgroundColor: UIColor,
        foregroundColor: UIColor,
        desiredHeight: CGFloat,
        positionBelowControl: UIView?)
    {
        super.init()
        self.parentView = parentView
        timeIntervalBeforeAutoHidingErrorView = autoHideDelaySeconds
        self.desiredHeight = desiredHeight
        self.positionBelowControl = positionBelowControl

        initSubviews()
        self.view.backgroundColor = backgroundColor
        self.errorMessageLabel.textColor = foregroundColor
        self.view.hidden = true

    }

    public func showErrorView(message: String)
    {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.stopErrorViewAutohideTimer()    // If it was already running, reset the autohide timer
            var errView = self.view
            errView.hidden = false

            // Set text to the error message.
            var errLabel = self.errorMessageLabel
            errLabel.text = message

            // Begin with message out of view, above the top edge of the parent view:
            self.parentView.layoutIfNeeded()
            self.mainViewTopSpaceConstraint.constant = -self.view.frame.size.height
            self.parentView.layoutIfNeeded()

            // Animate moving down from the top of the view:
            UIView.animateWithDuration(0.8,
                delay: 0,
                options: UIViewAnimationOptions.CurveEaseInOut |
                    UIViewAnimationOptions.AllowUserInteraction,
                animations: { () -> Void in
                    var topOfErrorView: CGFloat = 0
                    if let controlAbove = self.positionBelowControl
                    {
                        let origin = self.parentView.convertPoint(controlAbove.bounds.origin, fromView: controlAbove)
                        let vspacing = ErrorView.getStandardVerticalSpacing(controlAbove, bottomControl: self.view)
                        topOfErrorView = origin.y + controlAbove.frame.size.height + vspacing
                    }
                    else
                    {
                        topOfErrorView = self.parentView.frame.height - self.view.frame.height
                    }

                    self.mainViewTopSpaceConstraint.constant = topOfErrorView
                    self.parentView.layoutIfNeeded()

                }, completion: { (done) -> Void in
                    self.startErrorViewAutohideTimer()
            })
        })
    }

    public class func getStandardVerticalSpacing(topControl: UIView, bottomControl: UIView)->CGFloat
    {
        let views = ["topview": topControl, "bottomview" : bottomControl]
        let constraints = NSLayoutConstraint.constraintsWithVisualFormat("[topview]-[bottomview]", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views)
        return constraints[0].constant
    }

    private func initSubviews()
    {
        self.view = UIView()
        parentView.addSubview(self.view)

        self.errorMessageLabel = LabelWithAutoWrap(font: UIFont.systemFontOfSize(20))
        self.view.addSubview(errorMessageLabel)

        if let image = loadCloseButtonImage()
        {
            self.imageView = UIImageView(image: image)
            self.view.addSubview(imageView)
        }

        // Button must be added last. Covers entire view.
        self.errorMessageDismissButton = makeDismissButton()
        self.view.addSubview(errorMessageDismissButton)

        // Add constraints
        setConstraints()
        parentView.layoutIfNeeded()
    }

    private func loadCloseButtonImage()->UIImage?
    {
        let frameworkBundle = NSBundle(forClass: self.dynamicType)
        return UIImage(named: "XButton", inBundle: frameworkBundle, compatibleWithTraitCollection: nil)
    }

    private func makeDismissButton()->UIButton
    {
        var button = UIButton()
        button.addTarget(self, action: "errorMessageDismissButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }

    private func setConstraints()
    {
        var views = [
            "view": view,
            "label": errorMessageLabel,
            "image": imageView,
            "button": errorMessageDismissButton
        ]

        for control in views.values
        {
            control.setTranslatesAutoresizingMaskIntoConstraints(false)
        }

        var mainViewHConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: NSLayoutFormatOptions.allZeros,
            metrics: nil, views: views)
        parentView.addConstraints(mainViewHConstraint)


        var mainViewTopConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: parentView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0 /*32*/)
        parentView.addConstraint(mainViewTopConstraint)
        self.mainViewTopSpaceConstraint = mainViewTopConstraint

        let mainViewVConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.desiredHeight)

        parentView.addConstraint(mainViewVConstraint)

        let imageAspectRatioConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: imageView, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 1)
        imageView.addConstraint(imageAspectRatioConstraint)

        let imageTopConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        view.addConstraint(imageTopConstraint)

        let labelVertConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[label]-|",
            options: NSLayoutFormatOptions.allZeros,
            metrics: nil, views: views)
        view.addConstraints(labelVertConstraints)

        let subviewsHorzConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[image]-32.0-[label]-|",
            options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views)
        view.addConstraints(subviewsHorzConstraints)

        // An invisible button overlays the entire control. Users will be drawn to tap the X button, but tapping anywhere will dismiss. The X button is just a cue to tell them it can be dismissed.
        let buttonHorzConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[button]|",
            options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views)
        view.addConstraints(buttonHorzConstraints)

        let buttonVertConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[button]|",
            options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views)
        view.addConstraints(buttonVertConstraints)
    }

    func errorMessageDismissButtonPressed(sender: UIButton!)
    {
        hideErrorView()
    }

    func startErrorViewAutohideTimer()
    {
        if (timeIntervalBeforeAutoHidingErrorView > 0)
        {
            self.hideErrorViewAfterDelayTimer =
                NSTimer.scheduledTimerWithTimeInterval(timeIntervalBeforeAutoHidingErrorView,
                    target: self,
                    selector: "hideErrorViewTimerFired:",
                    userInfo: nil,
                    repeats: false)
        }
    }

    @objc func hideErrorViewTimerFired(timer: NSTimer)
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
        UIView.animateWithDuration(0.3,
            delay: 0,
            options: UIViewAnimationOptions.CurveEaseInOut,
//            options: UIViewAnimationOptions.TransitionCrossDissolve,
            animations: { () -> Void in
                //                self.mainViewTopSpaceConstraint.constant = -self.view.frame.size.height // Use this to slide up and away instead of fading out
                self.view.alpha = 0
//                self.view.layoutIfNeeded()
            }, completion: {(done)->Void in
                self.view.hidden = true
                self.view.alpha = 1.0
        })
    }

}