//
//  Label + Font + Extension.swift
//  Plando
//
//  Created by Nomadic on 1/23/21.
//

import Foundation
import UIKit

extension UIFont {
    
    static func avenir16() -> UIFont? {
        return UIFont.init(name: "Avenir", size: 13)
    }
    
    static func avenir20() -> UIFont? {
        return UIFont.init(name: "Avenir", size: 20)
    }
    
    static func avenir22() -> UIFont? {
        return UIFont.init(name: "Avenir-Black", size: 20)
    }
}


extension UILabel {
    convenience init(text: String, font: UIFont? = .avenir20(), textColor: UIColor) {
        self.init()
        
        self.text = text
        self.font = font
        self.textColor = textColor
    }
}
