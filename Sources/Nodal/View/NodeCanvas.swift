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

    private let nodePicker              = NodePicker()
    private var subs: [AnyCancellable]  = []
    private var nodes: [NodeView]       = []
    
    // Connection building
    private let pendingConnection = CAShapeLayer()
    private var touchDownLocation: CGPoint?
    private var travelingTouchLocation: CGPoint?
    
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
        pendingConnection.fillColor = UIColor.clear.cgColor
        pendingConnection.strokeColor = NodalConfiguration.connectionColor.cgColor
        pendingConnection.lineWidth = NodalConfiguration.connectionThickness
        self.layer.addSublayer(pendingConnection)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
}

//MARK: Connection management
extension NodeCanvas{
    
    func updatePendingConnection() {
        guard let from = touchDownLocation, let to = travelingTouchLocation else { pendingConnection.path = nil; return }
        let path = UIBezierPath()
        path.move(to: from)
        let dX = to.x - from.x
        let controlPoint1 = CGPoint(x: to.x - dX*0.75, y: from.y)
        let controlPoint2 = CGPoint(x: from.x + dX*0.75, y: to.y)
        path.addCurve(to: to, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        pendingConnection.path = path.cgPath
    }
    
    func addConnection(from: CGPoint, to: CGPoint) {
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
    }
}

//MARK: Default touch handlers
extension NodeCanvas{
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("NodeCanvas: Touches began")
        self.nodes.forEach { (node) in
            guard let point = touches.first?.location(in: node) else { return }
            if let connector = node.touchDown(point, with: event){
                touchDownLocation = convert(connector.center, from: node)
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
                let touchEnd = convert(connector.center, from: node)
                guard let from = touchDownLocation else { return }
                addConnection(from: from, to: touchEnd)
            }
        }
        self.travelingTouchLocation = nil
        self.touchDownLocation = nil
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
        
        let newNode = NodeView(numInputs: 4, numOutputs: 4)
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
        })
        
        nodes.append(newNode)
        layoutSubviews()
    }
}
