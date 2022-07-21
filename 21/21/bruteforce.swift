//
//  bruteforce.swift
//  21
////


import Foundation

class BruteForce: Operation {
    var delegate: ShowPasswordProtocol?
    var passwordToUnlock: String = ""

    init (passwordToUnlock: String) {
        self.passwordToUnlock = passwordToUnlock
    }

    override func main() {
        if self.isCancelled {
            return
        }
        bruteForce()
    }

    func bruteForce() {
        var password: String = ""

        while password != passwordToUnlock { // Increase MAXIMUM_PASSWORD_SIZE value for more
            password = generateBruteForce(password, fromArray: AllowedCharacters.array)
            print("\(password)")
            DispatchQueue.main.async {
                self.delegate?.showPasswordLabel(password)
            }
            if self.isCancelled {
                DispatchQueue.main.sync {
                    self.delegate?.cancelHacking()
                }
                return
            }
        }
        DispatchQueue.main.sync {
            self.delegate?.successHacking()
//            self.delegate?.showTextFieldPassword()
//            self.delegate?.stopActivityIndicator()
        }
    }

    private func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character))!
    }

    private func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index])
        : Character("")
    }

    private func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var str: String = string

        if str.count <= 0 {
            str.append(characterAt(index: 0, array))
        }
        else {
            str.replace(at: str.count - 1,
                        with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))

            if indexOf(character: str.last!, array) == 0 {
                str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
            }
        }
        return str
    }
}

