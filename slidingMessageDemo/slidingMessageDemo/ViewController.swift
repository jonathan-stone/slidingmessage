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

    fileprivate var errorView: slidingmessage.SlidingMessage?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.errorView = SlidingMessage(parentView: self.view,
            autoHideDelaySeconds: 5,
            backgroundColor: UIColor.red,
            foregroundColor: UIColor.white,
            minimumHeight: 100,
            positionBelowControl: button,
            font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body))
    }

    @IBAction func buttonPressed(_ sender: AnyObject)
    {
        self.errorView?.show(self.textField.text!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

