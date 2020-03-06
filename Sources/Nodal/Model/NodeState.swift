//
//  NodeState.swift
//  
//
//  Created by Joe Bakalor on 3/6/20.
//

import Foundation


class NodeState {
    
    var inputs  : [NodeInput] = []
    var outputs : [NodeOutput] = []
    
    init(numInputs: Int, numOutputs: Int) {
        
        for i in 0...numInputs - 1{
            let newInput = NodeInput(index: i)
            inputs.append(newInput)
        }
        
        for i in 0...numOutputs - 1{
            let newOutput = NodeInput(index: i)
            outputs.append(newOutput)
        }
    }
}
