//
//  File.swift
//  
//
//  Created by Joe Bakalor on 3/20/20.
//

import Foundation
import UIKit

struct Connection {
    
    var connectionID = UUID.init()
    
    init(anchorOne: ConnectionAnchor, anchorTwo: ConnectionAnchor, connectionShape: CAShapeLayer) {
        self.anchorOne = anchorOne
        self.anchorTwo = anchorTwo
        self.connectionShape = connectionShape
        distrubuteConnections()
    }
    
    var connectionShape: CAShapeLayer
    var anchorOne: ConnectionAnchor
    var anchorTwo: ConnectionAnchor
    
    func distrubuteConnections(){
        
        switch anchorOne.connector.location {
        case .INPUT:
            
            anchorOne
                .node
                .newInputConnection(
                    from: anchorTwo.connector,
                    on: anchorTwo.node,
                    to: anchorOne.connector,
                    with: connectionShape)
            
            anchorTwo
                .node
                .newOutputConnection(
                    to: anchorOne.connector,
                    on: anchorOne.node,
                    from: anchorTwo.connector,
                    with: connectionShape)
            
        case .OUTPUT:
            
            anchorOne
                .node
                .newOutputConnection(
                    to: anchorTwo.connector,
                    on: anchorTwo.node,
                    from: anchorOne.connector,
                    with: connectionShape)
            
            anchorTwo
                .node
                .newInputConnection(
                    from: anchorOne.connector,
                    on: anchorOne.node,
                    to: anchorTwo.connector,
                    with: connectionShape)
            
        case .none:
            break
        }
    }
}



