//
// Created by Denis Kapusta on 12/25/16.
// Copyright (c) 2016 Denis Kapusta Demo. All rights reserved.
//

import Foundation

class DKSearchModuleBuilder {
    static let sharedInstance = DKSearchModuleBuilder()

    fileprivate lazy var coreServices = DKCoreServices.sharedInstance

    var viewModel: DKSearchViewModel {
        return DKSearchViewModel(searchService: coreServices.searchService, throttleTimeInterval: DKSearchConstants.throttleTimeInterval)
    }
}
