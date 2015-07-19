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

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder:aDecoder)
        self.applyPropertySettings()
    }

    override init(frame:CGRect)
    {
        super.init(frame:frame)
        self.applyPropertySettings()
    }

    override  func awakeFromNib() {
        super.awakeFromNib()
        self.applyPropertySettings()
        
    }

    override func layoutSubviews()
    {
        super.layoutSubviews()
        self.preferredMaxLayoutWidth = self.bounds.size.width;
    }

    private func applyPropertySettings()
    {
        self.lineBreakMode = NSLineBreakMode.ByWordWrapping // TODO: How to do this only once?
        self.numberOfLines = 0
        self.font = UIFont.systemFontOfSize(15)
    }
}
