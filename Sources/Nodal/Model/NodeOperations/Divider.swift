//
//  File.swift
//  
//
//  Created by Joe Bakalor on 3/6/20.
//

import Foundation

class Divider: NodeOperation{
    
    static var operation: Operation = .divider
    
    typealias InputType = Double
    typealias OutputType = Double

    static var numberInputs: Int = 2
    static var numberOutputs: Int = 1
    
    func process(state: NodeState<InputType, OutputType>) {
        
        guard
            let inputOne = state.inputs[0].value,
            let inputTwo =  state.inputs[1].value
            else { return }
        print(inputOne)
        print(inputTwo)
        state.outputs[0].value = inputOne/inputTwo
    }
    
    required init(){
        
    }
}
