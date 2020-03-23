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
    
    public var nodeID = UUID.init()
    
    @Published var desiredCoordinates: CGPoint = .zero
    
    //Shape layers
    private let backgroundShape                    = CAShapeLayer()
    private var inputConnectors: [Connector]       = []
    private var outputConnectors: [Connector]      = []
    
    private var inputConnections: [Int: (CAShapeLayer, NodeView)] = [:]
    private var outputConnections: [Int: (CAShapeLayer, NodeView)] = [:]

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
        
        if numInputs > 0{
            for i in 0...numInputs - 1 {
                let connector = Connector(index: i, location: .INPUT)
                inputConnectors.append(connector)
            }
        }
        
        if numOutputs > 0{
            for i in 0...numOutputs - 1 {
                let connector = Connector(index: i, location: .OUTPUT)
                outputConnectors.append(connector)
            }
        }

        self.initView()
    }

    open func initView() {
        self.layer.addSublayer(backgroundShape)
        [inputConnectors, outputConnectors].forEach{
            $0.forEach{
                self.addSubview($0)
            }
        }
    }
    
    func newInputConnection(index: Int, connectionLayer: CAShapeLayer, nodeView: NodeView){
        inputConnections[index] = (connectionLayer, nodeView)
    }
    
    func newOutputConnection(index: Int, connectionLayer: CAShapeLayer, nodeView: NodeView){
        outputConnections[index] = (connectionLayer, nodeView)
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
                (H - NodalConfiguration.connectorSize.width - 15)/CGFloat(outputConnectors.count - 1)
            
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


//MARK: Default touch handlers
extension NodeView{
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        var connector: Connector? = nil
        [inputConnectors, outputConnectors].forEach{
            $0.forEach{
                if $0.frame.contains(point){
                    connector = $0
                }
            }
        }
        if let c = connector{
            print("Selected connector \(c.index)")
            return nil//c
        }
        
        if self.frame.contains(convert(point, to: self.superview)){
            return self
        }
        
        return nil
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let newPosition = touches.first?.location(in: self) else { return }
        guard !isConnector(point: newPosition) else { return }
        self.desiredCoordinates = newPosition
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let newPosition = touches.first?.location(in: self) else { return }
        guard !isConnector(point: newPosition) else { return }
        self.desiredCoordinates = newPosition
    }
}

//MARK: Custom touch handlers
extension NodeView{
    
    //
    open func touchMoved(_ point: CGPoint, with event: UIEvent?) -> UIView?{
        var connector: UIView? = nil
        [inputConnectors, outputConnectors].forEach{
            $0.forEach{
                _ = $0.checkHover(point, with: event)
                if $0.frame.contains(point){
                    print("Hovering over connector with index: \($0.index)")
                    connector = $0
                }
            }
        }
        return connector
    }
    
    open func touchDown(_ point: CGPoint, with event: UIEvent?) -> Connector?{
        var connector: Connector? = nil
        [inputConnectors, outputConnectors].forEach{
            $0.forEach{
                if $0.frame.contains(point){
                    print("Touch down on connector with index: \($0.index)")
                    connector = $0
                }
            }
        }
        return connector
    }
    
    open func touchUp(_ point: CGPoint, with event: UIEvent?) -> Connector?{
        var connector: Connector? = nil
        [inputConnectors, outputConnectors].forEach{
            $0.forEach{
                if $0.frame.contains(point){
                    print("Touch up on connector with index: \($0.index)")
                    connector = $0
                    $0.hoverMode = false
                }
            }
        }
        return connector
    }
    
    private func isConnector(point: CGPoint) -> Bool {
        var c: UIView? = nil
        [inputConnectors, outputConnectors].forEach{
            $0.forEach{
                if $0.frame.contains(point){
                    c = $0
                }
            }
        }
        guard c == nil else { return true }
        return false
    }
}

