//
//  LabelWithAutoWrap.swift
//  whosinretail
//
//  Created by Jonathan Stone on 3/8/15.
//  Copyright (c) 2015 Jonathan Stone. All rights reserved.
//

import UIKit

class LabelWithAutoWrap: UILabel
{
    var userFont: UIFont?

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder:aDecoder)
        self.applyPropertySettings()
    }

    override init(frame:CGRect)
    {
        super.init(frame:frame)
        self.applyPropertySettings()
    }

    convenience init(font: UIFont?)
    {
        let placeholderRect = CGRect(x:0, y:0, width: 20, height:14)
        self.init(frame: placeholderRect)    // Caller is expected to use autolayout or resize the control.
        self.userFont = font
        applyFont()
    }

    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.applyPropertySettings()
    }

    override func layoutSubviews()
    {
        super.layoutSubviews()
        self.preferredMaxLayoutWidth = self.bounds.size.width;
    }

    fileprivate func applyPropertySettings()
    {
        self.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.numberOfLines = 0

        applyFont()
    }

    fileprivate func applyFont()
    {
        if let fontToUse = self.userFont
        {
            self.font = fontToUse
        }
        else
        {
            self.font = UIFont.systemFont(ofSize: 15)
        }
    }


}
