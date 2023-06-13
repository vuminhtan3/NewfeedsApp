//
//  CustomStyleTabBarController.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 13/06/2023.
//

import Foundation
import ESTabBarController_swift

class CustomStyleTabBarContentView: ESTabBarItemContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        /// Normal
        textColor = UIColor.black
        iconColor = UIColor.black
        
        /// Selected
        highlightTextColor = UIColor.systemCyan
        highlightIconColor = UIColor.systemCyan
    }
    
//    override var selected: Bool {
//        didSet {
//            super.selected = selected
//            self.updateLayout()
//        }
//    }
//
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
