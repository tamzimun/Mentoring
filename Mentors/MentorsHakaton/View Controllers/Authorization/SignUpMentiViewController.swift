//
//  SignUpMentiViewController.swift
//  MentorsHakaton
//
//  Created by Aida Moldaly on 09.07.2022.
//

import UIKit

class SignUpMentiViewController: UIViewController {

    private let networkManager: NetworkManagerAF = .shared
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var numberTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var iinTextField: UITextField!
    @IBOutlet var schoolTextField: UITextField!
    @IBOutlet var gradeTextField: UITextField!
    @IBOutlet var achivementsTextView: UITextView!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var checkPasswordTextField: UITextField!
    @IBOutlet var signUpMentiButton: UIButton!
    @IBOutlet var errorLabel: UILabel!

    var schoolPickerView = UIPickerView()
    var schools = ["School of Physics and Mathematics in Nur-Sultan",
                   "Nazarbayev Intellectual School of Nur-Sultan",
                   "School of Physics and Mathematics in Kokshetau",
                   "School of Physics and Mathematics in Taldykorgan",
                   "School of Physics and Mathematics in Semey",
                   "School of Physics and Mathematics in Uralsk",
                   "School of Chemistry and Biology in Ust-Kamenogorsk",
                   "School of Physics and Mathematics in Aktobe",
                   "School of Chemistry and Biology in Karaganda",
                   "School of Chemistry and Biology in Shymkent",
                   "School of Physics and Mathematics in Shymkent",
                   "School of Physics and Mathematics in Taraz",
                   "School of Chemistry and Biology in Kyzylorda",
                   "School of Chemistry and Biology in Pavlodar",
                   "School of Chemistry and Biology in Atyrau",
                   "School of Physics and Mathematics in Almaty",
                   "School of Physics and Mathematics in Kostanay",
                   "School of Chemistry and Biology in Petropavlovsk",
                   "School of Chemistry and Biology in Almaty",
                   "chool of Chemistry and Biology in Aktau",
                   "International School of Nur-Sultan",
                   "School of Chemistry and Biology in Turkestan"]
    
    var schoolsShorten = ["SPM in Nur-Sultan",
                          "NIS of Nur-Sultan",
                          "SPM in Kokshetau",
                          "SPM in Taldykorgan",
                          "SPM in Semey",
                          "SPM in Uralsk",
                          "SCB in Ust-Kamenogorsk",
                          "SPM in Aktobe",
                          "SCB in Karaganda",
                          "SCB in Shymkent",
                          "SPM in Shymkent",
                          "SPM in Taraz",
                          "SCB in Kyzylorda",
                          "SCB in Pavlodar",
                          "SCB in Atyrau",
                          "SPM in Almaty",
                          "SPM in Kostanay",
                          "SCB in Petropavlovsk",
                          "SCB in Almaty",
                          "SCB in Aktau",
                          "IS of Nur-Sultan",
                          "SCB in Turkestan",]
    var pickedSchoolIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegates()
        setUpElements()
    }
    
    func delegates() {
        gradeTextField.delegate = self
        numberTextField.delegate = self
        iinTextField.delegate = self
        
        schoolPickerView.delegate = self
        schoolPickerView.dataSource = self
        schoolTextField.inputView = schoolPickerView
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
        Utilities.styleFilledButton(signUpMentiButton)
        
        achivementsTextView.font = UIFont(name: "verdana", size: 16.5)
        achivementsTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        achivementsTextView.layer.borderWidth = 0.5
        achivementsTextView.clipsToBounds = true
        achivementsTextView.textColor = UIColor.systemGray3
        achivementsTextView.becomeFirstResponder()
        achivementsTextView.selectedTextRange = achivementsTextView.textRange(from: achivementsTextView.beginningOfDocument, to: achivementsTextView.beginningOfDocument)
        achivementsTextView.delegate = self
    }
    
    func validateField() -> String? {
        
        if  firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            numberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            iinTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            schoolTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            gradeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            achivementsTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            checkPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        if Utilities.isValidEmail(email: emailTextField.text!) == false {
            return "Please make sure your email is right, you are not an alumni!"
        }
        
        if Utilities.isPasswordValid(passwordTextField.text!) == false {
            return "Please make sure your passsword is at least 4 characters and contains a number."
        }
        
        if passwordTextField.text != checkPasswordTextField.text {
            return "Passwords are not the same."
        }
        return nil
    }
    
    @IBAction func signMentiButtonTapped(_ sender: UIButton) {
        
        let error = validateField()
        
        if error != nil {
            showError(error!)
        } else {
            
            guard let firstname = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let lastname = lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let number = numberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let iin = iinTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let grade = gradeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let achivements = achivementsTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let index = pickedSchoolIndex else { return }
            
            let pickedSchool = schools[index]
            print("my picked shool is \(pickedSchool)")
            
            let register = SignUpMenti(firstname: firstname, lastname: lastname, email: email, password: password, number: number, iin: iin, school: pickedSchool, grade: Int(grade)!, achievements: achivements)
            
            networkManager.postMentiRegister(credentials: register) { [weak self] result in
                guard self != nil else { return }
                switch result {
                case let .success(message):
                    self!.transitionToHome()
                    // some toastview to show that user is registered
                    print("\(String(describing: message)): 123")
                case let .failure(error):
                    self!.showError("This email has already registered!")
                    print("\(error): 456")
                }
            }
        }
        

    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
        self.navigationController?.popViewController(animated: true)
        view.window?.makeKeyAndVisible()
    }
}

extension SignUpMentiViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            textView.text = "Achivements"
            textView.textColor = UIColor.systemGray3
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }

         else if textView.textColor == UIColor.systemGray3 && !text.isEmpty {
            textView.font = UIFont(name: "verdana", size: 16.0)
            textView.textColor = UIColor.black
            textView.text = text
         }
        else {
            return true
        }
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.systemGray3 {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}

extension SignUpMentiViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == gradeTextField || textField == iinTextField  {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        
        else  if textField == numberTextField {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = Utilities.format(with: "X (XXX) XXX-XXXX", phone: newString)
            return false
        }
        
        return true
    }
}

extension SignUpMentiViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return schoolsShorten.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return schoolsShorten[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            schoolTextField.text = schoolsShorten[row]
            pickedSchoolIndex = row
            schoolTextField.resignFirstResponder()

        
    }
}
