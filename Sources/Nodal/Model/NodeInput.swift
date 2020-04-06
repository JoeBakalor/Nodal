//
//  NodeInput.swift
//  
//
//  Created by Joe Bakalor on 3/6/20.
//

import Foundation
import Combine

open class NodeInput<InputType>: NodeTerminal<InputType> {
    public var subscription: AnyCancellable?
}
