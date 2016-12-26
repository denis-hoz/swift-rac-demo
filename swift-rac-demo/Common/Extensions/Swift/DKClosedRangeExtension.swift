//
// Created by Denis Kapusta on 12/25/16.
// Copyright (c) 2016 Denis Kapusta Demo. All rights reserved.
//

import Foundation

extension ClosedRange where Bound: FloatingPoint {
    var length: Bound {
        return upperBound - lowerBound
    }
    
    func random() -> Bound {
        return lowerBound + (drand48() as! Bound) * length
    }
}


