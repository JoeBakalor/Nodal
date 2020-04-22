//
//  NodeModel.swift
//  
//
//  Created by Joe Bakalor on 3/4/20.
//

import Foundation
import Combine

open class NodeModel {

    private var _nodeOperation                   : (NodeState) -> Void
    public var state                             : NodeState
    public var inputTypeCompatibilityCheck       : ((Any) -> Bool)
    
    public init<T: NodeOperation>(nodeOperation: T.Type) throws {
        
        // Init state
        state           = NodeState(numInputs: nodeOperation.numberInputs, numOutputs: nodeOperation.numberOutputs)
        let no          = nodeOperation.init()
        _nodeOperation  = { nodeState in no.process(state: nodeState) }
        
        no.process(state: state)
        
        // Add type checking
        inputTypeCompatibilityCheck = { (valueToAccept) in
            if valueToAccept is T.InputType{
                return true
            }
            else {
                return false
            }
        }
    }
    
    public func process() {
        _nodeOperation(state)
    }
    
}

//MARK: Connect methods
extension NodeModel{
    
    public func connect(inputIndex: Int, toOutputIndex: Int, ofNodeModel: NodeModel) throws {
    
        guard self.inputTypeCompatibilityCheck(ofNodeModel.state.outputs[toOutputIndex].value as Any) else {
            throw NodalError.TYPE_MISMATCH
        }
        
        let sub = ofNodeModel.state.outputs[toOutputIndex].$value
            .sink { (value) in
                if let val = value {
                    self.state.inputs[inputIndex].value = val
                    self.process()
            }
        }
        
        ofNodeModel.state.outputs[toOutputIndex].subscription   = sub
        self.state.inputs[inputIndex].subscription              = sub
    }

    public func connect(outputIndex: Int, toInputIndex: Int, ofNodeModel: NodeModel) throws {
        
        guard ofNodeModel.inputTypeCompatibilityCheck(self.state.outputs[outputIndex].value as Any) else {
            throw NodalError.TYPE_MISMATCH
        }
        
        let sub = state.outputs[outputIndex].$value
            .sink { (value) in
                if let val = value {
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
        state.inputs[inputIndex].subscription = nil
        process()
    }
    
    public func disconnect(outputIndex: Int) {
        state.outputs[outputIndex].subscription?.cancel()
        state.outputs[outputIndex].subscription = nil
        process()
    }
    
    public func disconnectAll() {
        
        state.inputs.forEach {
            $0.subscription?.cancel()
            $0.subscription = nil
        }
        
        state.outputs.forEach {
            $0.subscription?.cancel()
            $0.subscription = nil
        }
        
        process()
    }
}
