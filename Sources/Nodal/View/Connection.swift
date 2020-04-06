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
        distrubuteConnection()
    }
    
    var connectionShape: CAShapeLayer
    var anchorOne: ConnectionAnchor
    var anchorTwo: ConnectionAnchor
    
    func cancel(){
        
        switch anchorOne.connector.location {
        case .INPUT:
            
            anchorOne
                .node
                .cancelInputConnection(to: anchorOne.connector)
            
            anchorTwo
                .node
                .cancelOuptutConnection(from: anchorTwo.connector)
            
            anchorOne.connector.associatedConnectionID = nil
            anchorTwo.connector.associatedConnectionID = nil
            
        case .OUTPUT:
            
            anchorOne
                .node
                .cancelOuptutConnection(from: anchorOne.connector)
            
            anchorTwo
                .node
                .cancelInputConnection(to: anchorTwo.connector)

            anchorOne.connector.associatedConnectionID = nil
            anchorTwo.connector.associatedConnectionID = nil
            
        case .none:
            break
        }
    }
    
    internal func distrubuteConnection(){
        
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
            
            anchorOne.connector.associatedConnectionID = connectionID
            anchorTwo.connector.associatedConnectionID = connectionID
            
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

            anchorOne.connector.associatedConnectionID = connectionID
            anchorTwo.connector.associatedConnectionID = connectionID
            
        case .none:
            break
        }
    }
}



