//
//  CustomTabBar.swift
//  prototype
//
//  Created by hiroki sato on 2021/09/01.
//

import UIKit

class CustomTabBar: UITabBar {

    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
            frost.frame = bounds
            frost.autoresizingMask = .flexibleWidth
            insertSubview(frost, at: 0)
        }

}
