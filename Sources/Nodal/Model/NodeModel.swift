//
//  NodeModel.swift
//  
//
//  Created by Joe Bakalor on 3/4/20.
//

import Foundation
import Combine

open class NodeModel<InputType, OutputType> {
    
    private var _nodeOperation: (NodeState<InputType, OutputType>) -> Void
    private var state: NodeState<InputType, OutputType>
    
    public init<T: NodeOperation>(nodeOperation: T) throws {
        
        state = NodeState(numInputs: nodeOperation.numberInputs, numOutputs: nodeOperation.numberOutputs)

        guard let op = { (nodeState) in
            nodeOperation.self.process(state: nodeState)
            } as? (NodeState<InputType, OutputType>) -> Void else { throw NSError.init() }
        
        _nodeOperation = op
    }
    
    private func process() {
        _nodeOperation(state)
    }
}

//MARK: Connect methods
extension NodeModel{
    
    public func connect(inputIndex: Int, toOutputIndex: Int, ofNodeModel: NodeModel) throws {
        
         let sub = ofNodeModel.state.outputs[toOutputIndex].$value
            .sink { (value) in
                if let val = value as? InputType {
                    self.state.inputs[inputIndex].value = val
                    self.process()
            }
        }
        
        ofNodeModel.state.outputs[toOutputIndex].subscription   = sub
        self.state.inputs[inputIndex].subscription              = sub
    }

    public func connect(outputIndex: Int, toInputIndex: Int, ofNodeModel: NodeModel) throws {
        
        let sub = state.outputs[outputIndex].$value
            .sink { (value) in
                if let val = value as? InputType {
                    ofNodeModel.state.inputs[toInputIndex].value = val
                    ofNodeModel.process()
            }
        }
        
        ofNodeModel.state.inputs[toInputIndex].subscription     = sub
        self.state.outputs[outputIndex].subscription            = sub
    }
}

//MARK: Disconnect methods
extension NodeModel{
    
    public func disconnect(inputIndex: Int) {
        state.inputs[inputIndex].subscription?.cancel()
    }
    
    public func disconnect(outputIndex: Int) {
        state.outputs[outputIndex].subscription?.cancel()
    }
    
    public func disconnectAll() {
        
        state.inputs.forEach {
            $0.subscription?.cancel()
        }
        
        state.outputs.forEach {
            $0.subscription?.cancel()
        }
    }
}
