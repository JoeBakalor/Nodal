//
//  NodeState.swift
//  
//
//  Created by Joe Bakalor on 3/6/20.
//

import Foundation


open class NodeState<InputType, OutputType> {
    
    public var inputs  : [NodeInput<InputType>] = []
    public var outputs : [NodeOutput<OutputType>] = []
    
    public init(numInputs: Int, numOutputs: Int) {
        
        for i in 0...numInputs - 1{
            let newInput = NodeInput<InputType>(index: i)
            inputs.append(newInput)
        }
        
        for i in 0...numOutputs - 1{
            let newOutput = NodeOutput<OutputType>(index: i)
            outputs.append(newOutput)
        }
    }
}
