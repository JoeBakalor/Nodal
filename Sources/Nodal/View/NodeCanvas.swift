//
//  NodeCanvas.swift
//  
//
//  Created by Joe Bakalor on 3/5/20.
//

import Foundation
import UIKit
import Combine

open class NodeCanvas: UIView {

    private let nodePicker                       = NodePicker()
    private var subs: [AnyCancellable]           = []
    private var nodes: [NodeView]                = []
    private var connections: [UUID:Connection]   = [:]
    
    // Connection building
    private let pendingConnectionShape           = CAShapeLayer()
    private var touchDownLocation                : CGPoint?
    private var travelingTouchLocation           : CGPoint?
    
    // On first connector selected this is initialized
    private var pendingConnectionAnchor          : ConnectionAnchor?
    
    private var nodePickerExpanded = false
    
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
        self.backgroundColor = UIColor.lightGray
        addTestGesture()
        pendingConnectionShape.fillColor = UIColor.clear.cgColor
        pendingConnectionShape.strokeColor = NodalConfiguration.connectionColor.cgColor
        pendingConnectionShape.lineWidth = NodalConfiguration.connectionThickness
        self.layer.addSublayer(pendingConnectionShape)
        self.addSubview(nodePicker)
        nodePicker.delegate = self
        nodePicker.onClick {
            self.toggleNodePicker()
        }
    }
    
    func toggleNodePicker(){

        nodePickerExpanded.toggle()
        UIView.animate(withDuration: 0.75){
            self.layoutSubviews()
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        nodePicker.frame.size = CGSize(width: 500,height: 500)
        nodePicker.center = self.center
        if nodePickerExpanded == false {
            nodePicker.frame.origin.y = self.bounds.maxY - 500*0.1
        }
    }
}

extension NodeCanvas: NodePickerDelegate{
    
    public func selectedOperation(operation: Operation) {

        let newNode = operation.nodeView()
        self.addSubview(newNode)
             
            newNode.frame =
                CGRect(
                x: self.bounds.midX,
                y: self.bounds.midY,
                width: 100,
                height: 80)
             
        subs.append(newNode.$desiredCoordinates
            .sink { (newPoint) in
                let converted = self.convert(newPoint, from: newNode)
                newNode.center = converted
                self.updateConnections(for: newNode)
        })
             
        nodes.append(newNode)
        layoutSubviews()
        toggleNodePicker()
        self.bringSubviewToFront(nodePicker)
    }
    
    
}

//MARK: Connection management
extension NodeCanvas{
    
    func updatePendingConnection() {
        guard let from = touchDownLocation, let to = travelingTouchLocation else { pendingConnectionShape.path = nil; return }
        let path = UIBezierPath()
        path.move(to: from)
        let dX = to.x - from.x
        let controlPoint1 = CGPoint(x: to.x - dX*0.75, y: from.y)
        let controlPoint2 = CGPoint(x: from.x + dX*0.75, y: to.y)
        path.addCurve(to: to, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        pendingConnectionShape.path = path.cgPath
    }
    
    func addConnection(from: CGPoint, to: CGPoint) -> CAShapeLayer {
        let newConnection = CAShapeLayer()
        self.layer.addSublayer(newConnection)
        let path = UIBezierPath()
        path.move(to: from)
        let dX = to.x - from.x
        let controlPoint1 = CGPoint(x: to.x - dX*0.75, y: from.y)
        let controlPoint2 = CGPoint(x: from.x + dX*0.75, y: to.y)
        path.addCurve(to: to, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        newConnection.fillColor = UIColor.clear.cgColor
        newConnection.strokeColor = NodalConfiguration.connectionColor.cgColor
        newConnection.lineWidth = NodalConfiguration.connectionThickness
        newConnection.path = path.cgPath
        return newConnection
    }
}

//MARK: Default touch handlers
extension NodeCanvas{
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("NodeCanvas: Touches began")
        
        self.nodes.forEach { (node) in
            guard let point = touches.first?.location(in: node) else { return }
            if let connector = node.touchDown(point, with: event){
                
                if let id = connector.associatedConnectionID{
                    
                    let existingConnection = self.connections[id]
                    self.connections.removeValue(forKey: id)
                    existingConnection?.connectionShape.removeFromSuperlayer()
                    existingConnection?.cancel()
                    
                    let otherConnector = existingConnection?.anchorOne.connector == connector ? existingConnection?.anchorTwo.connector : connector
                    let otherNode = existingConnection?.anchorOne.connector == connector ? existingConnection?.anchorTwo.node : node

                    if let oc = otherConnector, let on = otherNode{
                        touchDownLocation = convert(oc.center, from: on)
                        pendingConnectionAnchor = ConnectionAnchor(node: on, connector: oc)
                    }
                    
                }
                else{
                    touchDownLocation = convert(connector.center, from: node)
                    pendingConnectionAnchor = ConnectionAnchor(node: node, connector: connector)
                }
            }
        }
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("NodeCanvas: Touches moved")
        guard let pointOnCanvas = touches.first?.location(in: self) else { return }
        self.travelingTouchLocation = pointOnCanvas
        
        self.nodes.forEach { (node) in
            guard let point = touches.first?.location(in: node) else { return }
            _ = node.touchMoved(point, with: event)
        }
        updatePendingConnection()
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("NodeCanvas: Touches ended")
        self.nodes.forEach { (node) in
            guard let point = touches.first?.location(in: node) else { return }
            
            if let connector = node.touchUp(point, with: event){
                
                // Can't connect to self
                guard pendingConnectionAnchor?.node != node else { return }
                
                // Can't connect to connector if it already has a connection
                guard connector.associatedConnectionID == nil else { return }
                
                // Can't make a connection if we don't have a touch down location
                guard let from = touchDownLocation else { return }
                
                // Can't connect input side to input side
                guard pendingConnectionAnchor?.connector.location != connector.location else { return }
                
                let touchEnd = convert(connector.center, from: node)
                let anchorTwo = ConnectionAnchor(node: node, connector: connector)
                let connectionShape = addConnection(from: from, to: touchEnd)
                
                if let anchorOne = pendingConnectionAnchor {
                    let newConnection = Connection(anchorOne: anchorOne, anchorTwo: anchorTwo, connectionShape: connectionShape)
                    self.connections[newConnection.connectionID] = newConnection
                }
            }
        }
        self.travelingTouchLocation = nil
        self.touchDownLocation = nil
        updatePendingConnection()
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}

//MARK: Connection managment
extension NodeCanvas{
    private func updateConnections(for node: NodeView){
        
        node.inputConnections.forEach {
            
            let path = UIBezierPath()
            let from = convert($0.value.2.center, from: $0.value.1)
            path.move(to: from)
            
            let to = convert(node.inputConnectors[$0.key].center, from: node)
            let dX = to.x - from.x
            let controlPoint1 = CGPoint(x: to.x - dX*0.75, y: from.y)
            let controlPoint2 = CGPoint(x: from.x + dX*0.75, y: to.y)

            path.addCurve(to: to, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            $0.value.0.path = path.cgPath
        }

        node.outputConnections.forEach {
            
            let path = UIBezierPath()
            let from = convert($0.value.2.center, from: $0.value.1)
            path.move(to: from)
            
            let to = convert(node.outputConnectors[$0.key].center, from: node)
            let dX = to.x - from.x
            let controlPoint1 = CGPoint(x: to.x - dX*0.75, y: from.y)
            let controlPoint2 = CGPoint(x: from.x + dX*0.75, y: to.y)

            path.addCurve(to: to, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            $0.value.0.path = path.cgPath
        }
        
    }
}

//MARK: Test functions
extension NodeCanvas{
    
    func addTestGesture(){
        /**TESTING ONLY*/
        let gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.numberOfTapsRequired = 2
        gestureRecognizer.addTarget(self, action: #selector(addNode))
        self.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc
    func addNode(){
        
//        do {
//            let newNode = NodeView(nodeOperation: Constant.self)
//            self.addSubview(newNode)
//
//            newNode.frame =
//                CGRect(
//                    x: self.bounds.midX,
//                    y: self.bounds.midY,
//                    width: 100,
//                    height: 80)
//
//            subs.append(newNode.$desiredCoordinates
//                .sink { (newPoint) in
//                    let converted = self.convert(newPoint, from: newNode)
//                    newNode.center = converted
//                    self.updateConnections(for: newNode)
//            })
//
//            nodes.append(newNode)
//            layoutSubviews()
//        }

    }

}
