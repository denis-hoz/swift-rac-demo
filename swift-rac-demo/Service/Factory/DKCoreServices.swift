//
// Created by Denis Kapusta on 12/25/16.
// Copyright (c) 2016 Denis Kapusta Demo. All rights reserved.
//

import Foundation

class DKCoreServices {
    static let sharedInstance = DKCoreServices()

    var searchService: DKSearchService {
        return DKSearchServiceMock(delayRange: DKSearchConstants.mockSearchRequestDelayImitationRange)
    }
}
