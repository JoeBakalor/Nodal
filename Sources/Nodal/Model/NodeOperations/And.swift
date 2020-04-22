//
//  File.swift
//  
//
//  Created by Joe Bakalor on 4/22/20.
//

import Foundation



class And: NodeOperation {

    static var operation: Operation = .and
    typealias InputType             = Bool
    typealias OutputType            = Bool
    static var numberInputs: Int    = 2
    static var numberOutputs: Int   = 1
    
    func process(state: NodeState) {
        setDefaults(state: state)
        guard
            let inputOne = state.inputs[0].value as? InputType,
            let inputTwo =  state.inputs[1].value as? InputType
            else { return }
        
        state.outputs[0].value = (inputOne && inputTwo)
        print("Output updated: \(String(describing: state.outputs[0].value))")
    }
    
    //If no connection, set default value
    func setDefaults(state: NodeState) {
        
        state.inputs.forEach{
            switch $0.index{
            case 0: if !$0.hasConnection { $0.value = false }
            case 1: if !$0.hasConnection { $0.value = false }
            default: break
            }
        }
    }
    
    required init(){
        
    }
}

