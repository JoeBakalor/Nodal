//
//  File.swift
//  
//
//  Created by Joe Bakalor on 4/6/20.
//

import Foundation

public enum Operation: String, CaseIterable {
    
    case adder      = "Adder"
    case divider    = "Divider"
    case constant   = "Constant"
    case and        = "And"
    case or         = "Or"
    
    func nodeView() -> NodeView{
        switch self{
        case .adder:        return NodeView(nodeOperation: Adder.self)
        case .divider:      return NodeView(nodeOperation: Divider.self)
        case .constant:     return NodeView(nodeOperation: Constant.self)
        case .and:          return NodeView(nodeOperation: And.self)
        case .or:           return NodeView(nodeOperation: Or.self)
        }
    }
}
