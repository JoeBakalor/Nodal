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
    
    @Published var desiredCoordinates: CGPoint  = .zero
    
    public var nodeID = UUID.init()
    public var panMode = false{
        didSet { //TODO: This should be animated
            self.layoutSubviews()
        }
    }
    
    // Shape layers
    private let backgroundShape                 = CAShapeLayer()
    
    private var panModeRect: CGRect                                     = .zero
    private var normalModeRect: CGRect                                  = .zero
    var inputConnectors: [Connector]                                    = []
    var outputConnectors: [Connector]                                   = []
    var inputConnections: [Int: (CAShapeLayer, NodeView, Connector)]    = [:]
    var outputConnections: [Int: (CAShapeLayer, NodeView, Connector)]   = [:]
    var inputLabels: [UILabel]                                          = []
    var outputLabels: [UILabel]                                         = []
    
    //Need to be cancelled when deleting node
    var subs: [AnyCancellable]                                          = []
    
    // Model
    private var nodeModel: NodeModel!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initView()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    //  Used for full operation
    public convenience init<T: NodeOperation>(nodeOperation: T.Type){
        self.init(frame: CGRect.zero)
        
        do {
            nodeModel = try NodeModel(nodeOperation: nodeOperation)
        }
        catch let error as NodalError {
            print(error)
        }
        catch let error {
            print(error)
        }
        
        if nodeOperation.numberInputs > 0 {
            for i in 0...nodeOperation.numberInputs - 1 {
                let connector = Connector(index: i, location: .INPUT)
                let label = UILabel()
                label.text = "0.0"
                inputConnectors.append(connector)
                inputLabels.append(label)
                
                // Display input values
                let sub = nodeModel.state.inputs[i].$value.sink { (value) in
                    guard let val = value else { return }
                    self.inputLabels[i].text = "\(val)"
                    self.inputLabels[i].sizeToFit()
                }
                subs.append(sub)
            }
        }

        if nodeOperation.numberOutputs > 0 {
            for i in 0...nodeOperation.numberOutputs - 1 {
                let connector = Connector(index: i, location: .OUTPUT)
                let label = UILabel()
                outputConnectors.append(connector)
                outputLabels.append(label)
                
                // Display output values
                let sub = nodeModel.state.outputs[i].$value.sink { (value) in
                    guard let val = value else { return }
                    self.outputLabels[i].text = "\(val)"
                    self.outputLabels[i].sizeToFit()
                }
                subs.append(sub)
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
        
        [inputLabels, outputLabels].forEach{
            $0.forEach {
                self.addSubview($0)
            }
        }
    }
    
    func cancelInputConnection(to ourConnector: Connector){
        inputConnections.removeValue(forKey: ourConnector.index)
        nodeModel?.disconnect(inputIndex: ourConnector.index)
    }
    
    func newInputConnection(from connector: Connector, on nodeView: NodeView, to ourConnector: Connector, with connectionLayer: CAShapeLayer) throws {
        
        inputConnections[ourConnector.index] = (connectionLayer, nodeView, connector)
        
        do {
            try nodeModel?.connect(inputIndex: ourConnector.index, toOutputIndex: connector.index, ofNodeModel: nodeView.nodeModel)
        }
        catch let error as NodalError {
            throw error
        }
        catch _ {
            throw NodalError.UNEXPECTED
        }
    }
    
    func cancelOuptutConnection(from ourConnector: Connector){
        outputConnections.removeValue(forKey: ourConnector.index)
        nodeModel?.disconnect(outputIndex: ourConnector.index)
    }
    
    func newOutputConnection(to connector: Connector, on nodeView: NodeView, from ourConnector: Connector, with connectionLayer: CAShapeLayer) throws {
        outputConnections[ourConnector.index] = (connectionLayer, nodeView, connector)
        
        do {
            try nodeModel?.connect(outputIndex: ourConnector.index, toInputIndex: connector.index, ofNodeModel: nodeView.nodeModel)
        }
        catch let error as NodalError {
            throw error
        }
        catch _ {
            throw NodalError.UNEXPECTED
        }
        
    }
}

//MARK: View layout
extension NodeView{
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        normalModeRect = self.bounds
        panModeRect =
            CGRect(
                x: -7.5,
                y: -7.5,
                width: self.bounds.width + 15,
                height: self.bounds.height + 15)
        
        let H = panMode ? panModeRect.height : self.bounds.height
        let W = panMode ? panModeRect.width : self.bounds.width
        
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
            
            inputLabels[0].sizeToFit()
            inputLabels[0].frame =
                    CGRect(
                        x: inputConnectors[0].frame.maxX,
                        y: inputConnectors[0].frame.minY,
                        width: inputLabels[0].frame.size.width,
                        height: inputLabels[0].frame.size.height)
            
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
                
                inputLabels[$0.offset].sizeToFit()
                inputLabels[$0.offset].frame =
                        CGRect(
                            x: $0.element.frame.maxX,
                            y: $0.element.frame.minY,
                            width: inputLabels[$0.offset].frame.size.width,
                            height: inputLabels[$0.offset].frame.size.height)
            }
        }
        
        //Output connector positions
        if outputConnectors.count == 1 {
            
            outputConnectors[0].frame =
                CGRect(
                    origin: CGPoint(
                        x: W - (NodalConfiguration.connectorSize.width),
                        y: H/2 - (NodalConfiguration.connectorSize.width/2)),
                    size: NodalConfiguration.connectorSize)
            
            outputLabels[0].sizeToFit()
            outputLabels[0].frame =
                    CGRect(
                        x: outputConnectors[0].frame.minX - outputLabels[0].frame.size.width,
                        y: outputConnectors[0].frame.minY,
                        width: outputLabels[0].frame.size.width,
                        height: outputLabels[0].frame.size.height)
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
                    
                outputLabels[$0.offset].sizeToFit()
                outputLabels[$0.offset].frame =
                        CGRect(
                            x: $0.element.frame.minX - outputLabels[$0.offset].frame.size.width,
                            y: $0.element.frame.minY,
                            width: outputLabels[$0.offset].frame.size.width,
                            height: outputLabels[$0.offset].frame.size.height)
            }
        }
        
        backgroundShape.path = backgroundPath.cgPath
        backgroundShape.fillColor = NodalConfiguration.nodeColor.cgColor
        
        if panMode {
            backgroundShape.shadowColor = UIColor.black.cgColor
            backgroundShape.shadowOffset = CGSize(width: 5, height: 5)
            backgroundShape.shadowPath = backgroundShape.path
            backgroundShape.shadowOpacity = 0.85
        }
        else {
            backgroundShape.shadowOpacity = 0.0
        }
        
        let d = desiredCoordinates
        desiredCoordinates = d
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
        self.panMode = true
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let newPosition = touches.first?.location(in: self) else { return }
        guard !isConnector(point: newPosition) else { return }
        self.desiredCoordinates = newPosition
        self.panMode = false
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

