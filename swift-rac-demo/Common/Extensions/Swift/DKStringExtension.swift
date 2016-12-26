//
// Created by Denis Kapusta on 12/25/16.
// Copyright (c) 2016 Denis Kapusta Demo. All rights reserved.
//

import Foundation

extension String {
    func isNumber() -> Bool {
        let notDigitCharacters = CharacterSet.decimalDigits.inverted

        return !hasCharacters(fromSet: notDigitCharacters)
    }

    func isLetter() -> Bool {
        let notLetterCharacters = CharacterSet.letters.inverted

        return !hasCharacters(fromSet: notLetterCharacters)
    }

    func hasCharacters(fromSet characterSet: CharacterSet) -> Bool {
        return rangeOfCharacter(from: characterSet) != nil
    }

    func reversed() -> String {
        return String(characters.reversed())
    }
}