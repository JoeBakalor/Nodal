//
//  NodePicker.swift
//  
//
//  Created by Joe Bakalor on 3/6/20.
//

import Foundation
import UIKit

open class NodePicker: UIView {

    public convenience init() {
        self.init(frame: CGRect.zero)
        self.initView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initView()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }

    open func initView() {
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
    }

}
