//
//  NodeOutput.swift
//  
//
//  Created by Joe Bakalor on 3/6/20.
//

import Foundation
import Combine

class NodeOutput<OutputType>: NodeTerminal<OutputType> {
    var subscription: AnyCancellable?
}
