//
// Created by Denis Kapusta on 12/22/16.
// Copyright (c) 2016 Denis Kapusta Demo. All rights reserved.
//

import Foundation
import ReactiveSwift

fileprivate enum DKSearchServiceResult {
    case value(String)
    case error(RequestError)
}

final class DKSearchServiceMock {
    fileprivate let delayRange: ClosedRange<TimeInterval>

    fileprivate let tooLongNumberErrorText = NSLocalizedString("Too long number.", comment: "")
    fileprivate let shouldBeLettersOrNumbersOnlyErrorText = NSLocalizedString("Please enter number or letters only text.", comment: "")
    fileprivate let emptyStringErrorText = NSLocalizedString("Please enter text.", comment: "")

    init(delayRange: ClosedRange<TimeInterval>) {
        self.delayRange = delayRange
    }
}

extension DKSearchServiceMock : DKSearchService {
    func request(input: String) -> DKSearchServiceSignalProducer {
        return DKSearchServiceSignalProducer { observer, disposable in
            let searchResult = self.searchResult(input: input)

            switch searchResult {
            case .value(let value) :
                observer.send(value: value)
                observer.sendCompleted()
            case .error(let error):
                observer.send(error: error)
            }

        }.delayedByTimeInterval(fromRange: delayRange)
    }
}

// MARK: - Results
fileprivate extension DKSearchServiceMock {

    func searchResult(input: String) -> DKSearchServiceResult {
        guard !input.isEmpty else {
            return requestErrorResult(message: emptyStringErrorText)
        }

        if input.isNumber() {
            return searchResult(withNumericString: input)
        }

        if input.isLetter() {
            return searchResult(withLettersString: input)
        }

        return requestErrorResult(message: shouldBeLettersOrNumbersOnlyErrorText)
    }

    func searchResult(withNumericString numericString: String) -> DKSearchServiceResult {
        guard let number = Int(numericString) else {
            return requestErrorResult(message: tooLongNumberErrorText)
        }
        
        guard number <= Int.max / 2 else {
            return requestErrorResult(message: tooLongNumberErrorText)
        }

        let doubledNumber = number * 2
        let result = String(doubledNumber)

        return DKSearchServiceResult.value(result)
    }

    func searchResult(withLettersString lettersString: String) -> DKSearchServiceResult {
        let palindrome = lettersString + lettersString.reversed()

        return DKSearchServiceResult.value(palindrome)
    }
}

// MARK: - Helper
fileprivate extension DKSearchServiceMock {
    func requestErrorResult(message: String) -> DKSearchServiceResult {
        let requestError = RequestError.inputValueError(message)

        return DKSearchServiceResult.error(requestError)
    }
}
