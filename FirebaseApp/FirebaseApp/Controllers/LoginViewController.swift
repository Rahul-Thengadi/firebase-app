//
//  ViewController.swift
//  FirebaseApp
//
//  Created by Rahul Thengadi on 08/02/22.
//

import UIKit

enum AccountState {
    case existingUser
    case newUser
}

class LoginViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var accountStateMessageLabel: UILabel!
    @IBOutlet weak var accountStateButton: UIButton!
    
    private var accountState: AccountState = .existingUser
    
    private var authSession = AuthenticationSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearErrorLabel()
    }
    
    private func clearErrorLabel() {
        errorLabel.text = ""
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print("missing fields")
            return
        }
        print("login button pressed")
        continueLoginFlow(email: email, password: password)
    }
    
    private func continueLoginFlow(email: String, password: String) {
        if accountState == .existingUser {
            authSession.signExistingUser(email: email, password: password) { result in
                switch result {
                case .success(let receivedAuthData):
                    DispatchQueue.main.async {
                        self.errorLabel.textColor = .systemGreen
                        self.errorLabel.text = "Welcome back user with email: \(receivedAuthData.user.email ?? "")"
                    }
                case .failure(let receivedError):
                    print("received error: \(receivedError)")
                    DispatchQueue.main.async {
                        self.errorLabel.text = "\(receivedError.localizedDescription)"
                        self.errorLabel.textColor = .systemRed
                    }
                }
            }
        } else {
            authSession.createNewUser(email: email, password: password) { result in
                switch result {
                case .success(let receivedAuthData):
                    DispatchQueue.main.async {
                        self.errorLabel.textColor = .systemGreen
                        self.errorLabel.text = "Hope you enjoy our app experience. Email used  \(receivedAuthData.user.email ?? "")"
                    }
                case .failure(let receivedError):
                    print("received error: \(receivedError)")
                    DispatchQueue.main.async {
                        self.errorLabel.text = "\(receivedError.localizedDescription)"
                        self.errorLabel.textColor = .systemRed
                    }
                }
            }
        }
    }
    
    @IBAction func toggleAccountState(_ sender: UIButton) {
        // change the account login state
        accountState = accountState == .existingUser ? .newUser : .existingUser
        
        if accountState == .existingUser {
            loginButton.setTitle("Login", for: .normal)
            accountStateMessageLabel.text = "Don't have an account ? Click"
            accountStateButton.setTitle("SIGNUP", for: .normal)
        } else {
            loginButton.setTitle("Sign Up", for: .normal)
            accountStateMessageLabel.text = "Already have an account ?"
            accountStateButton.setTitle("LOGIN", for: .normal)
        }
    }
}

