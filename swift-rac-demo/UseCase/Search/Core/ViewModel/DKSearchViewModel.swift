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
    var cancelSearch = Action<Void, Void, NSError> { _ in
        return SignalProducer.empty
    }
    var retrySearch = Action<Void, Void, NSError> { _ in
        return SignalProducer.empty
    }

    // MARK: - Out
    let isSearching = MutableProperty<Bool>(false)
    let searchFailed = MutableProperty<Bool>(false)
    let resultText = MutableProperty<String>("")

    fileprivate var searchProducer :Disposable?
    fileprivate let searchService: DKSearchService
    fileprivate let throttleTimeInterval: TimeInterval
    
    init(searchService: DKSearchService, throttleTimeInterval: TimeInterval) {
        self.searchService = searchService
        self.throttleTimeInterval = throttleTimeInterval
        
        self.setupBindings()
    }

    // MARK: RAC Bindings -
    func setupBindings() {
        retrySearch.events
            .observeValues({[unowned self] _ in
                // TODO: merge signal or send signal directly
                self.searchText.value = self.searchText.value
            })

        cancelSearch.events
            // TODO: Button not disabling without delay
            .delay(0, on: QueueScheduler.main)
            .observeValues({[unowned self] _ in
                self.searchFailed.value = true
                self.completed(withText: "⚠️ was canceled")
                self.resetSearchProducer()
            })
        
        setupSearchProducer()
    }
    
    func resetSearchProducer() {
        searchProducer?.dispose()
        setupSearchProducer()
    }
    
    func setupSearchProducer() {
        searchProducer = searchText.producer
            .skip(first: 1)
            .throttle(throttleTimeInterval, on: QueueScheduler.main)
            .on(value: {[unowned self] _ in
                self.isSearching.value = true
                self.searchFailed.value = false
            })
            .observe(on: QueueScheduler(qos: .userInitiated, name: ""))
            .flatMap(.latest) { text in
                self.searchService.request(input: text)
                    .take(until: self.cancelSearch.completed)
                    .flatMapError { error in
                        self.searchFailed.value = true
                        
                        return SignalProducer(value: "🚫" + error.text)
                }
            }
            .startWithValues({[unowned self] foo in
                self.completed(withText: foo)
            })

    }
    
    func completed(withText text: String) {
        self.isSearching.value = false
        self.resultText.value = text
    }
}
