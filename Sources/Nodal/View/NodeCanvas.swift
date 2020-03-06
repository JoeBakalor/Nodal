//
//  NodeCanvas.swift
//  
//
//  Created by Joe Bakalor on 3/5/20.
//

import Foundation
import UIKit

open class NodeCanvas: UIView {

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
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

}
