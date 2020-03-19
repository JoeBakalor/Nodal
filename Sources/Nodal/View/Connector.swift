//
//  File.swift
//  
//
//  Created by Joe Bakalor on 3/9/20.
//

import Foundation
import UIKit

open class Connector: UIControl {
    
    private let backgroundLayer = CAShapeLayer()
    private var index = 0
    
    public convenience init(index: Int) {
        self.init(frame: CGRect.zero)
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
        self.addTarget(self, action: #selector(touchDown), for: .touchDown)
        self.addTarget(self, action: #selector(touchDragEnter), for: .touchDragEnter)
        self.addTarget(self, action: #selector(touchDragOutside), for: .touchDragOutside)
        self.addTarget(self, action: #selector(touchDragOutside), for: .touchDragExit)
        self.addTarget(self, action: #selector(touchUp), for: .touchUpInside)
    }
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if self.frame.contains(point){
            print("Connector with index \(index)")
        }
        return nil
    }
    
    open func hitTestDrag(_ point: CGPoint, with event: UIEvent?) -> UIView?{
        print(self.frame)
        print(point)
        if self.frame.contains(point){
            print("Connector with index \(index)")
        }
        return nil
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        
        let backgroundPath =
            UIBezierPath(
                roundedRect: self.bounds,
                cornerRadius: self.bounds.width/2)
        
        backgroundLayer.path = backgroundPath.cgPath
        backgroundLayer.fillColor = NodalConfiguration.unconnectedConnectorColor.cgColor

    }
    

    @objc
    func touchUp(){
        print("Touch up inside")
    }
    
    @objc
    func touchDown(){
        print("Touch down")
    }
    
    @objc
    func touchDragExit(){
        print("Touch drag exit")
    }
    
    @objc
    func touchDragEnter(){
        print("Touch drag enter")
    }
    
    @objc
    func touchDragOutside(){
        print("Touch drag outside")
    }
    
}
