//
//  File.swift
//  
//
//  Created by Joe Bakalor on 3/6/20.
//

import Foundation

class Divider: NodeOperation{

    typealias InputType = Double
    typealias OutputType = Double

    var numberInputs: Int = 2
    var numberOutputs: Int = 1
    
    func process(state: NodeState<InputType, OutputType>) {
        
        guard
            let inputOne = state.inputs[0].value,
            let inputTwo =  state.inputs[1].value
            else { return }
        print(inputOne)
        print(inputTwo)
        state.outputs[0].value = inputOne/inputTwo
    }
}