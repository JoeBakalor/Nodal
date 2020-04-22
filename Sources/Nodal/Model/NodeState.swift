//
//  NodeState.swift
//  
//
//  Created by Joe Bakalor on 3/6/20.
//

import Foundation

// Hold input and outpu values, and is operated on by
open class NodeState {
    
    public var inputs  : [NodeInput<Any>] = []
    public var outputs : [NodeOutput<Any>] = []
    
    public init(numInputs: Int, numOutputs: Int) {
        
        if numInputs != 0 {
            for i in 0...numInputs - 1{
                let newInput = NodeInput<Any>(index: i)
                inputs.append(newInput)
            }
        }

        for i in 0...numOutputs - 1{
            let newOutput = NodeOutput<Any>(index: i)
            outputs.append(newOutput)
        }
    }
}
