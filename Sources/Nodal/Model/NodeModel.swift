//
//  NodeModel.swift
//  
//
//  Created by Joe Bakalor on 3/4/20.
//

import Foundation
import Combine


open class NodeModel<T: NodeOperation> {

    private var _nodeOperation: (NodeState<T.InputType, T.OutputType>) -> Void
    public var state: NodeState<T.InputType, T.OutputType>
    
    public init(nodeOperation: T.Type) throws {
        
        state           = NodeState(numInputs: nodeOperation.numberInputs, numOutputs: nodeOperation.numberOutputs)
        let no          = nodeOperation.init()
        _nodeOperation  = { nodeState in no.process(state: nodeState) }
    }
    
    public func process() {
        _nodeOperation(state)
    }
    
    public func type() -> NodeModel.Type {
        return NodeModel<T>.self
    }
}

//MARK: Connect methods
extension NodeModel{
    
    public func connect(inputIndex: Int, toOutputIndex: Int, ofNodeModel: NodeModel) throws {
        
         let sub = ofNodeModel.state.outputs[toOutputIndex].$value
            .sink { (value) in
                if let val = value as? T.InputType {
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
                if let val = value as? T.InputType {
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
