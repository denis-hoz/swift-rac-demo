//
// Created by Denis Kapusta on 12/25/16.
// Copyright (c) 2016 Denis Kapusta Demo. All rights reserved.
//

import Foundation
import ReactiveSwift

extension SignalProducer {
    func delayedByTimeInterval(fromRange range: ClosedRange<TimeInterval>) -> SignalProducer {
        return delay(range.random(), on: QueueScheduler.main)
    }
}