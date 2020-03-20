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
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
}

//MARK: Default touch handlers
extension NodeCanvas{
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("NodeCanvas: Touches began")
        self.nodes.forEach { (node) in
            guard let point = touches.first?.location(in: node) else { return }
            _ = node.touchDown(point, with: event)
        }
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("NodeCanvas: Touches moved")
        self.nodes.forEach { (node) in
            guard let point = touches.first?.location(in: node) else { return }
            _ = node.touchMoved(point, with: event)
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("NodeCanvas: Touches ended")
        self.nodes.forEach { (node) in
            guard let point = touches.first?.location(in: node) else { return }
            _ = node.touchUp(point, with: event)
        }
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
        
        let newNode = NodeView(numInputs: 1, numOutputs: 2)
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
