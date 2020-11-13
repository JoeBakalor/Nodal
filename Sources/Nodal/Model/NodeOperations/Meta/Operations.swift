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
    case multiplication = "Multiplication"
    case division       = "Division"
    case constant       = "Constant"
    case and            = "And"
    case or             = "Or"
    case not            = "Not"
    case xor            = "Xor"
    case greaterThan    = "Greater Than"
    case lessThan       = "Less Than"
    
    
    func nodeView() -> NodeView{
        switch self{
        case .addition:         return NodeView(nodeOperation: Addition.self)
        case .division:         return NodeView(nodeOperation: Division.self)
        case .constant:         return NodeView(nodeOperation: Constant.self)
        case .and:              return NodeView(nodeOperation: And.self)
        case .or:               return NodeView(nodeOperation: Or.self)
        case .not:              return NodeView(nodeOperation: Not.self)
        case .subtraction:      return NodeView(nodeOperation: Subtraction.self)
        case .multiplication:   return NodeView(nodeOperation: Multiplication.self)
        case .xor:              return NodeView(nodeOperation: Xor.self)
        case .greaterThan:      return NodeView(nodeOperation: GreaterThan.self)
        case .lessThan:         return NodeView(nodeOperation: LessThan.self)
            
        }
    }
}
