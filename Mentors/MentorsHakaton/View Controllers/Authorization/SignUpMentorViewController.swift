//
//  SignUpMentorViewController.swift
//  MentorsHakaton
//
//  Created by tamzimun on 09.07.2022.
//

import UIKit
import AnyFormatKit

class SignUpMentorViewController: UIViewController {
    
    private let networkManager: NetworkManagerAF = .shared
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var numberTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var iinTextField: UITextField!
    @IBOutlet var schoolTextField: UITextField!
    @IBOutlet var majorTextField: UITextField!
    @IBOutlet var universityField: UITextField!
    @IBOutlet var countryOfStudyTextField: UITextField!
    @IBOutlet var workplaceTextField: UITextField!
    @IBOutlet var userInfoTextView: UITextView!
    
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var checkPasswordTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    private var majorPickerView = UIPickerView()
    private var majors = ["IT", "Business", "Journalism", "Engineering", "Logistics", "Marketing", "The medicine", "Management", "Teachers", "Project management", "Finance", "Economy", "Jurisprudence"]
    private var majorPicked: String = ""
    
    private var schoolPickerView = UIPickerView()
    private var schools = ["School of Physics and Mathematics in Nur-Sultan",
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
    
    private var schoolsShorten = ["SPM in Nur-Sultan",
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
    private var pickedSchoolIndex: Int?
    
    private var countryOfStudyPickerView = UIPickerView()
    private var countriesOfStudy: [String] = []
    private var countryPicked: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegates()
        setUpElements()
    }
    
    func delegates() {
        ageTextField.delegate = self
        numberTextField.delegate = self
        iinTextField.delegate = self
        
        majorPickerView.delegate = self
        majorPickerView.dataSource = self
        majorTextField.inputView = majorPickerView
        majorPickerView.tag = 1
        
        schoolPickerView.delegate = self
        schoolPickerView.dataSource = self
        schoolTextField.inputView = schoolPickerView
        schoolPickerView.tag = 2
        
        countryOfStudyPickerView.delegate = self
        countryOfStudyPickerView.dataSource = self
        countryOfStudyTextField.inputView = countryOfStudyPickerView
        countryOfStudyPickerView.tag = 3

    }
    
    func setUpElements() {
        
        for code in NSLocale.isoCountryCodes  {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            countriesOfStudy.append(name)
        }
        
        errorLabel.alpha = 0
        Utilities.styleFilledButton(signUpButton)
        
        userInfoTextView.font = UIFont(name: "verdana", size: 16.5)
        userInfoTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        userInfoTextView.layer.borderWidth = 0.5
        userInfoTextView.clipsToBounds = true
        userInfoTextView.textColor = UIColor.systemGray3
        userInfoTextView.becomeFirstResponder()
        userInfoTextView.selectedTextRange = userInfoTextView.textRange(from: userInfoTextView.beginningOfDocument, to: userInfoTextView.beginningOfDocument)
        userInfoTextView.delegate = self
    }
    
    func validateField() -> String? {
        
        if  firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            ageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            numberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            iinTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            majorTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            schoolTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            universityField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            countryOfStudyTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            userInfoTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            checkPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
    
        let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isValidEmail(email: cleanedEmail) == false {
            return "Please make sure your email is right, you are not an alumni!"
        }
            
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            return "Please make sure your passsword is at least 4 characters and contains a number."
        }
        
        if passwordTextField.text != checkPasswordTextField.text {
            return "Passwords are not the same."
        }
        return nil
    }
    
    @IBAction func signButtonTapped(_ sender: UIButton) {
        
        let error = validateField()
        
        if error != nil {
            showError(error!)
        } else {
            
            guard let firstname = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let lastname = lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let age = ageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let number = numberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let iin = iinTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let major = majorTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let university = universityField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let studyCountry = countryOfStudyTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let workplace = workplaceTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let userInfo = userInfoTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }

            guard let index = pickedSchoolIndex else { return }
            
            let pickedSchool = schools[index]
            
            let register = SignUpMentor(firstname: firstname, lastname: lastname, age: Int(age)!, number: number, iin: iin, major: major, university: university, country: studyCountry, work: workplace, userInfo: userInfo, school: pickedSchool, email: email, password: password)
            
            print("my major is \(major),  my country is \(studyCountry) , \(Int(age)!), \(pickedSchool), \(email), \(password), \(firstname), \(lastname), \(number), \(userInfo), \(iin), ")
            
            networkManager.postMentorRegister(credentials: register) { [weak self] result in
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

extension SignUpMentorViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            textView.text = "Additional information about yourself"
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

extension SignUpMentorViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == ageTextField || textField == iinTextField  {
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

extension SignUpMentorViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return majors.count
        case 2:
            return schoolsShorten.count
        case 3:
            return countriesOfStudy.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return majors[row]
        case 2:
            return schoolsShorten[row]
        case 3:
            return countriesOfStudy[row]
        default:
            return "Data not found"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            majorTextField.text = majors[row]
            majorPicked = majors[row]
            majorTextField.resignFirstResponder()
        case 2:
            schoolTextField.text = schoolsShorten[row]
            pickedSchoolIndex = row
            schoolTextField.resignFirstResponder()
        case 3:
            countryOfStudyTextField.text = countriesOfStudy[row]
            countryPicked = countriesOfStudy[row]
        default:
            return
        }
        
    }
}
