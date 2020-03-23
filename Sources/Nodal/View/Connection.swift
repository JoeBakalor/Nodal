//
//  File.swift
//  
//
//  Created by Joe Bakalor on 3/20/20.
//

import Foundation
import UIKit

struct Connection {
    
    internal init(anchorOne: ConnectionAnchor?, anchorTwo: ConnectionAnchor?) {
        self.anchorOne = anchorOne
        self.anchorTwo = anchorTwo
    }
    
    var connectionShape: CAShapeLayer?
    var anchorOne: ConnectionAnchor?
    var anchorTwo: ConnectionAnchor?
    
    func distrubuteConnections(){
        switch anchorOne?.connector.location {
        case .INPUT:
        case .OUTPUT:
        }
    }
}



