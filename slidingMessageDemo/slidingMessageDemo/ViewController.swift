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
    private var errorView: slidingmessage.ErrorView?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.errorView = ErrorView(parentView: self.view, autoHideDelaySeconds: 5, backgroundColor: UIColor.redColor(), foregroundColor: UIColor.whiteColor(), desiredHeight: 100, positionBelowControl: nil)
    }

    override func viewDidAppear(animated: Bool)
    {
        self.errorView?.showErrorView("Wow! A message!")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

