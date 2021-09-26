//
//  CustomTabBar.swift
//  prototype
//
//  Created by hiroki sato on 2021/09/17.
//

import UIKit

class CustomTabBar: UITabBar {

    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
            frost.frame = bounds
            frost.autoresizingMask = .flexibleWidth
            insertSubview(frost, at: 0)
        }

}
