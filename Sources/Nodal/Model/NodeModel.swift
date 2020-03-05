//
//  NodeModel.swift
//  
//
//  Created by Joe Bakalor on 3/4/20.
//

import Foundation

protocol NodeOperation {
    func run()
}

class NodeModel{
    
    init(inputs: Int, outputs: Int, nodeOperation: NodeOperation ) {
        
    }
    
    func connect(outputIndex: Int, to: NodeModel, inputIndex: Int){
    
    }
    
    func disconnectInput(index: Int){
        
    }
    
    func disconnectOutput(index: Int){
        
    }
    
    func disconnectAll(){
        
    }
}
