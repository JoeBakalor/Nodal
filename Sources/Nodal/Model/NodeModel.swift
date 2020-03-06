//
//  NodeModel.swift
//  
//
//  Created by Joe Bakalor on 3/4/20.
//

import Foundation

fileprivate typealias _nodeOperation = Any

class NodeModel<InputType, OutputType> {
    
    var _nodeOperation: (NodeState<InputType, OutputType>) -> Void
    var state: NodeState<InputType, OutputType>
    
    
    init<T: NodeOperation>(nodeOperation: T) {
        
        state = NodeState(numInputs: nodeOperation.numberInputs, numOutputs: nodeOperation.numberOutputs)

        _nodeOperation = { (nodeState) in
            nodeOperation.self.process(state: nodeState)
        } as! (NodeState<InputType, OutputType>) -> Void
    }
    
    func process(){
        _nodeOperation(state)
    }
    
    func connect(outputIndex: Int, toInputIndex: Int, ofNodeModel: NodeModel){
        
    }
    
    func disconnect(inputIndex: Int){

    }
    
    func disconnect(outputIndex: Int){
        
    }
    
    func disconnectAll(){
        
    }
}
