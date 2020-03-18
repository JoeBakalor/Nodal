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
        
        for _ in 0...numInputs - 1 {
            let connector = Connector()
            inputConnectors.append(connector)
        }
        
        if numOutputs > 0{
            for _ in 0...numOutputs - 1 {
                let connector = Connector()
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

