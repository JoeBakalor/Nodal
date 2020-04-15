//
//  File.swift
//  
//
//  Created by Joe Bakalor on 3/6/20.
//

import Foundation


class Adder: NodeOperation {
    
    static var operation: Operation = .adder
    
    typealias InputType = Double
    typealias OutputType = Double

    static var numberInputs: Int = 2
    static var numberOutputs: Int = 1
    
    func process(state: NodeState<InputType, OutputType>) {
        
        guard
            let inputOne = state.inputs[0].value,
            let inputTwo =  state.inputs[1].value
            else { return }
    
        state.outputs[0].value = inputOne + inputTwo
        print("Output updated: \(String(describing: state.outputs[0].value))")
    }
    
    required init(){
        
    }
}

