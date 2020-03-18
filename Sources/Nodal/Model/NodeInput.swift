//
//  NodeInput.swift
//  
//
//  Created by Joe Bakalor on 3/6/20.
//

import Foundation
import Combine

class NodeInput<InputType>: NodeTerminal<InputType> {
    var subscription: AnyCancellable?
}
