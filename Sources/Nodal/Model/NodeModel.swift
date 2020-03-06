//
//  NodeModel.swift
//  
//
//  Created by Joe Bakalor on 3/4/20.
//

import Foundation
import Combine

fileprivate typealias _nodeOperation = Any

class NodeModel<InputType, OutputType> {
    
    var _nodeOperation: (NodeState<InputType, OutputType>) -> Void
    var state: NodeState<InputType, OutputType>
    
    
    init<T: NodeOperation>(nodeOperation: T) throws {
        
        state = NodeState(numInputs: nodeOperation.numberInputs, numOutputs: nodeOperation.numberOutputs)

        guard let op = { (nodeState) in
            nodeOperation.self.process(state: nodeState)
            } as? (NodeState<InputType, OutputType>) -> Void else { throw NSError.init() }
        
        _nodeOperation = op
    }
    
    func process(){
        _nodeOperation(state)
    }
    
    func connect(inputIndex: Int, toOutputIndex: Int, ofNodeModel: NodeModel){
        
        let newSub = ofNodeModel.state.outputs[toOutputIndex].$value.sink { (value) in
            print(value)
        }
        //let newSub = NotificationCenter.default.publisher(for: ./ofNodeModel.state.outputs[toOutputIndex].value)
    }
    
    func disconnect(inputIndex: Int){

    }
    
    func disconnect(outputIndex: Int){
        
    }
    
    func disconnectAll(){
        
    }
}
