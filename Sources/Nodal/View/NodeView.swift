//
//  NodeView.swift
//  
//
//  Created by Joe Bakalor on 3/5/20.
//
import UIKit
import Foundation
import Combine

open class NodeView: UIView {
    
    @Published var desiredCoordinates: CGPoint = .zero
    
    //Shape layers
    private let backgroundShape                    = CAShapeLayer()
    private var inputConnectors: [Connector]       = []
    private var outputConnectors: [Connector]      = []

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initView()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    public convenience init(numInputs: Int, numOutputs: Int){
        self.init(frame: CGRect.zero)
        
        for i in 0...numInputs - 1 {
            let connector = Connector(index: i)
            inputConnectors.append(connector)
        }
        
        if numOutputs > 0{
            for i in 0...numOutputs - 1 {
                let connector = Connector(index: i)
                outputConnectors.append(connector)
            }
        }

        self.initView()
    }

    open func initView() {
        self.layer.addSublayer(backgroundShape)
        
        outputConnectors.forEach{
            self.addSubview($0)
        }
        
        inputConnectors.forEach{
            self.addSubview($0)
        }
    }
}

//MARK: Hit testing
extension NodeView{
    

    
    
}

//MARK: View layout
extension NodeView{
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        let H = self.bounds.height
        let W = self.bounds.width
        
        let inset = NodalConfiguration.connectorSize.width/2
        
        let insetRect =
            CGRect(
                x: inset,
                y: 0,
                width: W - NodalConfiguration.connectorSize.width,
                height: H)
        
        let backgroundPath =
            UIBezierPath(
                roundedRect: insetRect,
                byRoundingCorners: .allCorners,
                cornerRadii: CGSize(width: 10, height: 10))
        
        //Input connector positions
        if inputConnectors.count == 1 {
            inputConnectors[0].frame =
                CGRect(
                    origin: CGPoint(
                        x: 0,
                        y: H/2 - (NodalConfiguration.connectorSize.width/2)),
                    size: NodalConfiguration.connectorSize)
            
            print(inputConnectors[0].frame.origin)
            
        }
        else {
            let inputSpacing =
                (H - NodalConfiguration.connectorSize.width - 15)/CGFloat(inputConnectors.count - 1)
            
            inputConnectors
                .enumerated()
                .forEach{
                $0.element.frame =
                    CGRect(
                        origin: CGPoint(
                            x: 0,
                            y: CGFloat($0.offset)*inputSpacing + (NodalConfiguration.connectorSize.width/2)),
                        size: NodalConfiguration.connectorSize)
            }
        }
        
        //Output connector positions
        if outputConnectors.count == 1{
            outputConnectors[0].frame =
                CGRect(
                    origin: CGPoint(
                        x: W - (NodalConfiguration.connectorSize.width),
                        y: H/2 - (NodalConfiguration.connectorSize.width/2)),
                    size: NodalConfiguration.connectorSize)
        }
        else {
            let outputSpacing =
                (H - 15 - 15)/CGFloat(outputConnectors.count - 1)
            
            outputConnectors
                .enumerated()
                .forEach{
                $0.element.frame =
                    CGRect(
                        origin: CGPoint(
                            x: W - (NodalConfiguration.connectorSize.width),
                            y: CGFloat($0.offset)*outputSpacing + (NodalConfiguration.connectorSize.width/2)),
                        size: NodalConfiguration.connectorSize)
            }
        }
        
        backgroundShape.path = backgroundPath.cgPath
        backgroundShape.fillColor = NodalConfiguration.nodeColor.cgColor

    }
}


//MARK: Touch handlers
extension NodeView{
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        self.inputConnectors.forEach{
            _ = $0.hitTest(point, with: event)
        }
        
        self.outputConnectors.forEach{
            _ = $0.hitTest(point, with: event)
        }
        
//        print(self.frame)
//        print("Point: \(convert(point, to: self.superview))")
//        print("Node frame in canvas: \(convert(self.frame, to: self.superview))")
        
        if self.frame.contains(convert(point, to: self.superview)){
            return self
        }
        
        return nil
    }
    
    open func hitTestDrag(_ point: CGPoint, with event: UIEvent?) -> UIView?{
        //print(self.frame)
        //print("Drag Point: \(convert(point, to: self.superview))")
        //print("Node frame in canvas: \(convert(self.frame, to: self.superview))")
        
        self.inputConnectors.forEach{
            _ = $0.hitTestDrag(point, with: event)
        }
        
        self.outputConnectors.forEach{
            _ = $0.hitTestDrag(point, with: event)
        }
        
        return nil
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let newPosition = touches.first?.location(in: self) else { return }
        self.desiredCoordinates = newPosition
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let newPosition = touches.first?.location(in: self) else { return }
        self.desiredCoordinates = newPosition
    }
}

