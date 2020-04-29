//
//  File.swift
//  
//
//  Created by Joe Bakalor on 4/29/20.
//

import Foundation


protocol cType {
    func cType() -> String
}

extension Double: cType {
    func cType() -> String{
        return "float"
    }
}

extension Bool: cType {
    func cType() -> String {
        return "bool"
    }
}
