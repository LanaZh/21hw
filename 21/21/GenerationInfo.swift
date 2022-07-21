//
//  GenerationInfo.swift
//  21
//
//

import Foundation

struct AllowedCharacters {
    static let array: [String] = String().printable.map { String($0) }
}

extension String {
    var digits:      String { return "0123456789" }
    var lowercase:   String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase:   String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters:     String { return lowercase + uppercase }
    var printable:   String { return digits + letters + punctuation }

    var containsValidCharacter: Bool {
        guard self != "" else { return true }
        let printableSet = CharacterSet(charactersIn: printable)
        let newSet = CharacterSet(charactersIn: self)
        return printableSet.isSuperset(of: newSet)
    }

    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }
}
