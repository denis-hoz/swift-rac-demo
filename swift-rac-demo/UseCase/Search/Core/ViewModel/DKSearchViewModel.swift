//
// Created by Denis Kapusta on 12/25/16.
// Copyright (c) 2016 Denis Kapusta Demo. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

class DKSearchViewModel {

    // MARK: - Input
    let searchText = MutableProperty<String>("")
//    lazy var cancelSearch: Action<Void, Bool, NSError> = { [unowned self] in
//        return Action(enabledIf: self.isSearching) { _ in
//            self.searchSignalProducer.dispose()
//        }
//    }()

    // MARK: - OUT
    let isSearching = MutableProperty<Bool>(false)
    let searchFailed = MutableProperty<Bool>(false)
    let hasResult = MutableProperty<Bool>(false)
    let resultText = MutableProperty<String>("")


    fileprivate let searchService: DKSearchService
    fileprivate let throttleTimeInterval: TimeInterval
    fileprivate var searchSignalProducer: Disposable!
    
    init(searchService: DKSearchService, throttleTimeInterval: TimeInterval) {
        self.searchService = searchService
        self.throttleTimeInterval = throttleTimeInterval
        
        self.setupBindings()
    }

    // MARK: RAC Bindings -
    func setupBindings() {
        searchSignalProducer = searchText.producer
            .throttle(throttleTimeInterval, on: QueueScheduler.main)
            .on(value: {[unowned self] text in
                self.isSearching.value = true
                self.hasResult.value = false
                self.searchFailed.value = false
                print("foo \(text)")

            })
            .flatMap(.latest) {[unowned self] text in
                self.searchService.request(input: text)
            }
            .observe(on: UIScheduler())
            .startWithResult {[unowned self] result in
                self.isSearching.value = false
                
                switch result {
                case .success(let text):
                    self.hasResult.value = true
                    self.resultText.value = text
                case .failure(let error):
                    self.hasResult.value = false
                    self.searchFailed.value = false
                    self.resultText.value = "🚫" + error.localizedDescription
                }
            }
    }
}
