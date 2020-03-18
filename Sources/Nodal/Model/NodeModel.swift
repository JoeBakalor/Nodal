//
//  NodeModel.swift
//  
//
//  Created by Joe Bakalor on 3/4/20.
//

import Foundation
import Combine

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
}

//MARK: Connect methods
extension NodeModel{
    
    func connect(inputIndex: Int, toOutputIndex: Int, ofNodeModel: NodeModel) throws {
        
        state.inputs[inputIndex].subscription = ofNodeModel.state.outputs[toOutputIndex].$value
            .sink { (value) in
                if let val = value as? InputType{
                    self.state.inputs[inputIndex].value = val
                    self.process()
            }
        }
    }

    func connect(outputIndex: Int, toInputIndex: Int, ofNodeModel: NodeModel) throws {
        
        let sub = state.outputs[outputIndex].$value
            .sink { (value) in
                if let val = value as? InputType{
                    ofNodeModel.state.inputs[toInputIndex].value = val
                    ofNodeModel.process()
            }
        }
        
        ofNodeModel.state.inputs[toInputIndex].subscription = sub
        self.state.outputs[outputIndex].subscription        = sub
    }
}

//MARK: Disconnect methods
extension NodeModel{
    
    func disconnect(inputIndex: Int){
        state.inputs[inputIndex].subscription?.cancel()
    }
    
    func disconnect(outputIndex: Int){
        state.outputs[outputIndex].subscription?.cancel()
    }
    
    func disconnectAll(){
        state.inputs.forEach{
            $0.subscription?.cancel()
        }
        
        state.outputs.forEach{
            $0.subscription?.cancel()
        }
    }
}
