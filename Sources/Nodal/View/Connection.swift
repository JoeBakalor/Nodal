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
    
    var connectionShape : CAShapeLayer
    var anchorOne       : ConnectionAnchor
    var anchorTwo       : ConnectionAnchor
    
    init(anchorOne: ConnectionAnchor, anchorTwo: ConnectionAnchor, connectionShape: CAShapeLayer) throws {
        self.anchorOne = anchorOne
        self.anchorTwo = anchorTwo
        self.connectionShape = connectionShape
        
        do {
            try
            distrubuteConnection()
        }
        catch let error as NodalError {
            throw error
        }
        catch _ {
            throw NodalError.UNEXPECTED
        }
    }
    
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
    
    
    internal func distrubuteConnection() throws {
        
        switch anchorOne.connector.location {
        case .INPUT:
            
            do {
                try
                anchorOne
                    .node
                    .newInputConnection(
                        from: anchorTwo.connector,
                        on: anchorTwo.node,
                        to: anchorOne.connector,
                        with: connectionShape)
                try
                anchorTwo
                    .node
                    .newOutputConnection(
                        to: anchorOne.connector,
                        on: anchorOne.node,
                        from: anchorTwo.connector,
                        with: connectionShape)
                
                anchorOne.connector.associatedConnectionID = connectionID
                anchorTwo.connector.associatedConnectionID = connectionID
            }
            catch let error as NodalError {
                throw error
            }
            catch _ {
                throw NodalError.UNEXPECTED
            }

            
        case .OUTPUT:
            
            do {
                try
                anchorOne
                    .node
                    .newOutputConnection(
                        to: anchorTwo.connector,
                        on: anchorTwo.node,
                        from: anchorOne.connector,
                        with: connectionShape)
                try
                anchorTwo
                    .node
                    .newInputConnection(
                        from: anchorOne.connector,
                        on: anchorOne.node,
                        to: anchorTwo.connector,
                        with: connectionShape)

                anchorOne.connector.associatedConnectionID = connectionID
                anchorTwo.connector.associatedConnectionID = connectionID
            }
            catch let error as NodalError {
                throw error
            }
            catch _ {
                throw NodalError.UNEXPECTED
            }
            
        case .none:
            break
        }
    }
}



