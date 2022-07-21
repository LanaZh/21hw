//
//  ViewController.swift
//  21
//
//  Created by Надежда Жукова on 21.07.2022.
//

import UIKit

class ViewController: UIViewController {

    var newPassword = ""
    var bruteForce = BruteForce(passwordToUnlock: "")
    let queue = OperationQueue()
    let allowedCharacters = AllowedCharacters.array
    var isEyeOpen = false

    // MARK: - Set UI elements

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emojiButton: UIButton!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var eyeButton: UIButton!
    @IBAction func securePasswordEyeButton() {
        toggleTextFieldPasswordSecurity()
    }

    @IBAction func startButton(_ sender: Any) {
        startHacking()
    }

    @IBAction func emojiButton(_ sender: Any) {
        emojiButton.setTitle(generateEmoji(), for: .normal)
    }

    // MARK: - Functions

    func startHacking() {
        guard !bruteForce.isExecuting else { bruteForce.cancel()
            return }
        //      newPassword = generatePassword()
        //      passwordTextField.text = newPassword
        newPassword = passwordTextField.text ?? ""
        guard checkPassword(newPassword) else {
            alert(with: newPassword)
            return
        }
        bruteForce = BruteForce(passwordToUnlock: newPassword)
        bruteForce.delegate = self
        queue.addOperation(bruteForce)
        activityIndicator.startAnimating()
    }

    func showTextFieldPassword() {
        isEyeOpen = false
        toggleTextFieldPasswordSecurity()
    }

    func generateEmoji() -> String {
        return String(UnicodeScalar(Array(0x1F300...0x1F3F0).randomElement()!)!)
    }

    func toggleTextFieldPasswordSecurity() {
        if !isEyeOpen {
            eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
            passwordTextField.isSecureTextEntry = false
        } else {
            eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            passwordTextField.isSecureTextEntry = true
        }
        isEyeOpen.toggle()
    }

    //    generate password -- not used --
    //    created fot 1st version, not implemented here
    func generatePassword() -> String {
        var password = String()
        for _ in 1...Constants.characterLimit {
            let character = allowedCharacters[Int.random(in: 0...allowedCharacters.count - 1)]
            password += character
        }
        return password
    }

    // check and alert for not allowed character --not used--
    // use textField delegate that not allowing to input unallowed characters instead
    func checkPassword(_ text: String) -> Bool {
        return text.containsValidCharacter
    }

    func alert(with newPassword: String) {
        let alert = UIAlertController(title: "\(newPassword) - incorrect",
                                      message: "INPUT ONLY: \(String().printable)",
                                      preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: { self.passwordTextField.text = "" })
    }
}

// MARK: - Brut force delegate functions

protocol ShowPasswordProtocol {
    func showPasswordLabel(_ password: String)
    func successHacking()
    func cancelHacking()
}

extension ViewController: ShowPasswordProtocol {

    func showPasswordLabel(_ password: String) {
        passwordLabel.text = password
    }

    func successHacking() {
        activityIndicator.stopAnimating()
        showTextFieldPassword()
        emojiButton.setTitle(Constants.successEmoji, for: .normal)
    }

    func cancelHacking() {
        activityIndicator.stopAnimating()
        passwordLabel.text = Constants.cancelLabel
        emojiButton.setTitle(Constants.cancelEmoji, for: .normal)
    }
}

// MARK: - TextField Delegate - limitation of text characters, guard allowed symbols, keyboard action
extension ViewController: UITextFieldDelegate {
    private func textLimit(existingText: String?,
                           newText: String,
                           limit: Int) -> Bool {
        let text = existingText ?? ""
        let isAtLimit = (text.count + newText.count <= limit) && (text + newText).containsValidCharacter
        //        check for character limit and input allowed symbols
        return isAtLimit
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        return self.textLimit(existingText: textField.text,
                              newText: string,
                              limit: Constants.characterLimit)
    }

    //action by keyboard Return pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        startHacking()
        return true
    }
}
