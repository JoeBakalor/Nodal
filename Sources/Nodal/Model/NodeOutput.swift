//
//  NodeOutput.swift
//  
//
//  Created by Joe Bakalor on 3/6/20.
//

import Foundation
import Combine

open class NodeOutput<OutputType>: NodeTerminal<OutputType> {
    public var subscription: AnyCancellable?
    var hasConnection: Bool {
        return subscription != nil
    }
}
