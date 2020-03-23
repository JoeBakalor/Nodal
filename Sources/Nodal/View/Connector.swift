//
//  File.swift
//  
//
//  Created by Joe Bakalor on 3/9/20.
//

import Foundation
import UIKit

open class Connector: UIControl {
    
    public var hoverMode = false{
        didSet { //TODO: This should be animated
            self.layoutSubviews()
        }
    }
    
    var hoverModeRect: CGRect = .zero
    var normalModeRect: CGRect = .zero
    private let backgroundLayer = CAShapeLayer()
    var index = 0
    var location: ConnectorLocation?
    
    public convenience init(index: Int, location: ConnectorLocation) {
        self.init(frame: CGRect.zero)
        self.location = location
        self.index = index
        self.initView()
    }
    
    public convenience init() {
        self.init(frame: CGRect.zero)
        self.initView()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initView()
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    public convenience init(type buttonType: UIButton.ButtonType) {
        self.init(frame: CGRect.zero)
        self.initView()
    }

    internal func initView() {
        self.layer.addSublayer(backgroundLayer)
    }
    

    open func checkHover(_ point: CGPoint, with event: UIEvent?) -> UIView?{
        guard self.frame.contains(point) else { hoverMode = false; return nil }
        hoverMode = true
        return self
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        hoverModeRect =
            CGRect(
                x: -7.5,
                y: -7.5,
                width: self.bounds.width + 15,
                height: self.bounds.width + 15)
        
        normalModeRect = self.bounds
        
        let rect = hoverMode ? hoverModeRect : normalModeRect
        
        let backgroundPath =
            UIBezierPath(
                roundedRect: rect,
                cornerRadius: rect.width/2)
        
        backgroundLayer.path = backgroundPath.cgPath
        backgroundLayer.fillColor = NodalConfiguration.unconnectedConnectorColor.cgColor
    }
    
}
