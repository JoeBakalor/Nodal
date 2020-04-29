//
//  File.swift
//  
//
//  Created by Joe Bakalor on 4/29/20.
//

import Foundation


struct Nodal {
    
    static func generate(nodes: [NodeView], connections: [UUID: Connection]) -> String{
        
        /// 1. Build file with all functions in Nodal namespace
        var functions: String = ""
        
        nodes.forEach {
            functions.append($0.nodeModel.codeRepresentation)
        }
        
        return functions
    }
    
}
