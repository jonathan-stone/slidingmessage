//
//  ViewController.swift
//  slidingMessageDemo
//
//  Created by Jonathan Stone on 7/18/15.
//  Copyright (c) 2015 CompassionApps. All rights reserved.
//

import UIKit
import slidingmessage


class ViewController: UIViewController
{
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!

    private var errorView: slidingmessage.ErrorView?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.errorView = ErrorView(parentView: self.view,
            autoHideDelaySeconds: 5,
            backgroundColor: UIColor.redColor(),
            foregroundColor: UIColor.whiteColor(),
            minimumHeight: 100,
            positionBelowControl: button,
            font: UIFont.preferredFontForTextStyle(UIFontTextStyleBody))
    }

    @IBAction func buttonPressed(sender: AnyObject)
    {
        self.errorView?.showErrorView(self.textField.text)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

