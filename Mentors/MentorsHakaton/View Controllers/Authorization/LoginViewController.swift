//
//  LoginViewController.swift
//  MentorsHakaton
//
//  Created by Aida Moldaly on 09.07.2022.
//

import UIKit
import SwiftKeychainWrapper

class LoginViewController: UIViewController {

    private let networkManager: NetworkManagerAF = .shared
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    var data: String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.becomeFirstResponder()
    }

    func setUpElements() {
        errorLabel.alpha = 0
        Utilities.styleFilledButton(loginButton)
    }
    
    func validateField() -> String? {
        
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        if Utilities.isValidEmail(email: emailTextField.text!) == false {
            return "Please make sure your email is right, you are not an alumni!"
        }
        
        return nil
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let error = validateField()
        
        if error != nil {
            showError(error!)
        } else {
            
            guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            
            let login = Login(email: email, password: password)

            networkManager.postLogin(credentials: login) { [weak self] result in
                guard self != nil else { return }
                switch result {
                case let .success(message):
                    
                    self!.data = message
                    let temp = message?.dropFirst().dropLast()

                    let array = temp?.components(separatedBy: ",")
                    
                    let separatedRoles = array![0].components(separatedBy: ":")
                    let role = separatedRoles[1].dropFirst().dropLast()

                    let separatedTokens = array![2].components(separatedBy: ":")
                    let token = separatedTokens[1].dropFirst().dropLast()
                    
                    print("my token is \(token), my role is \(role)")
                    
                    let saveToken: Bool = KeychainWrapper.standard.set(String(token), forKey: "token")
                    let saveRole: Bool = KeychainWrapper.standard.set(String(role), forKey: "role")
                    
                    print("\(String(describing: message)): 123")
                    
                    self!.goToTabController()
                    
                case let .failure(error):
                    self!.showError("Unvalid email or password")
                    print("\(error): 456")
                }
                
            }
            
        }
        
    }
    
    func goToTabController() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        // This is to get the SceneDelegate object from your view controller, root view controller function to change to main tab bar
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
}
