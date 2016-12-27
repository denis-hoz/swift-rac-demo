//
// Created by Denis Kapusta on 12/22/16.
// Copyright (c) 2016 Denis Kapusta Demo. All rights reserved.
//

import Foundation
import ReactiveSwift

enum RequestError: Error {
    case inputValueError(String)
    case resultError
}

extension RequestError {
    var text: String {
        switch self {
        case .inputValueError(let text) :
            return text
        case .resultError :
            return self.localizedDescription
        }
    }
}

typealias DKSearchServiceSignalProducer = SignalProducer<String, RequestError>

protocol DKSearchService {
    func request(input: String) -> DKSearchServiceSignalProducer
}
