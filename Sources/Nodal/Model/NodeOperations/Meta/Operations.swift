//
//  File.swift
//  
//
//  Created by Joe Bakalor on 4/6/20.
//

import Foundation

public enum Operation: String, CaseIterable {
    
    case addition       = "Addition"
    case subtraction    = "Subtraction"
    case division       = "Division"
    case constant       = "Constant"
    case and            = "And"
    case or             = "Or"
    case not            = "Not"
    
    func nodeView() -> NodeView{
        switch self{
        case .addition:     return NodeView(nodeOperation: Addition.self)
        case .division:     return NodeView(nodeOperation: Division.self)
        case .constant:     return NodeView(nodeOperation: Constant.self)
        case .and:          return NodeView(nodeOperation: And.self)
        case .or:           return NodeView(nodeOperation: Or.self)
        case .not:          return NodeView(nodeOperation: Not.self)
        case .subtraction:  return NodeView(nodeOperation: Subtraction.self)
        }
    }
}
