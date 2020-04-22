//
//  File.swift
//  
//
//  Created by Joe Bakalor on 4/19/20.
//

import Foundation


class Constant: NodeOperation{
    
    static var operation: Operation = .constant
    typealias InputType             = Double
    typealias OutputType            = Double
    static var numberInputs: Int    = 0
    static var numberOutputs: Int   = 1
    
    func process(state: NodeState) {
        //setDefaults(state: state)
        state.outputs[0].value = Double(10)
    }
    
    
    //If no connection, set default value
    func setDefaults(state: NodeState) {
        //state.outputs[0].value = Double(10)
    }
    
    required init(){
        
    }
}
