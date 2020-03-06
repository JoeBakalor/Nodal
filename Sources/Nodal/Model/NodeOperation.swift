//
//  NodeOperation.swift
//  
//
//  Created by Joe Bakalor on 3/6/20.
//

import Foundation


protocol NodeOperation {
    func process(state: NodeState)
    var numberInputs: Int
    var numberOutputs: Int
}
