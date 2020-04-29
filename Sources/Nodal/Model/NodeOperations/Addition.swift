//
//  File.swift
//  
//
//  Created by Joe Bakalor on 3/6/20.
//

import Foundation


class Addition: NodeOperation {

    static var operation: Operation = .addition
    typealias InputType             = Double
    typealias OutputType            = Double
    static var numberInputs: Int    = 2
    static var numberOutputs: Int   = 1
    
    func process(state: NodeState) {
        setDefaults(state: state)
        guard
            let inputOne = state.inputs[0].value as? InputType,
            let inputTwo =  state.inputs[1].value as? InputType
            else { return }
        
        state.outputs[0].value = (inputOne + inputTwo)
        print("Output updated: \(String(describing: state.outputs[0].value))")
    }
    
    //If no connection, set default value
    func setDefaults(state: NodeState) {
        
        state.inputs.forEach{
            switch $0.index{
            case 0: if !$0.hasConnection { $0.value = Double(5) }
            case 1: if !$0.hasConnection { $0.value = Double(5) }
            default: break
            }
        }
    }
    
    func compile(state: NodeState) -> String {
        return
            """
            
                \(OutputType().cType()) add(\(InputType().cType()) arg1, \(InputType().cType()) arg2)
                {
                    return (arg1 + arg2);
                }
            
            """
    }
    
    required init(){
        
    }
}

