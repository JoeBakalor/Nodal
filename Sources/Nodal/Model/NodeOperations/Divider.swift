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
    
    func process(state: NodeState) {
        guard
            let inputOne = state.inputs[0].value as? InputType,
            let inputTwo =  state.inputs[1].value as? InputType
            else { return }
        print(inputOne)
        print(inputTwo)
        state.outputs[0].value = inputOne/inputTwo
    }
    
    func setDefaults(state: NodeState){
        state.inputs[0].value = Double(0)
        state.inputs[1].value = Double(0)
        state.outputs[0].value = Double(0)
    }
    
    required init(){
        
    }
}
