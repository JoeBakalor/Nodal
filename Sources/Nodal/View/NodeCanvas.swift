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

    let nodePicker = NodePicker()
    var subs: [AnyCancellable] = []
    var nodes: [NodeView] = []
    
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
