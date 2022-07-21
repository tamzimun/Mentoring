//
//  EditMentorProfileViewController.swift
//  MentorsHakaton
//
//  Created by Aida Moldaly on 10.07.2022.
//

import UIKit
import SwiftKeychainWrapper

class EditMentorProfileViewController: UIViewController {

    var networkManager = NetworkManagerAF.shared
    
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
    
    var myImage: String?
    
    private var userInfo: MentorProfile?
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
        
        loadMentorProfile()
        delegates()
        setUpElements()
        setUpNaviagtion()
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
        
        userInfoTextView.font = UIFont(name: "verdana", size: 16.5)
        userInfoTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        userInfoTextView.layer.borderWidth = 0.5
        userInfoTextView.clipsToBounds = true
        userInfoTextView.textColor = UIColor.black
        userInfoTextView.becomeFirstResponder()
        userInfoTextView.selectedTextRange = userInfoTextView.textRange(from: userInfoTextView.beginningOfDocument, to: userInfoTextView.beginningOfDocument)
    }
    
    func setUpNaviagtion() {
        navigationItem.title = "Profile"
        self.navigationController?.view.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleEdit))
    }
    
    @objc
    func handleEdit () {
        
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

        guard let index = pickedSchoolIndex else { return }
        
        let pickedSchool = schools[index]
        
        let edit = EditMentorProfile(firstname: firstname, lastname: lastname, email: email, age: Int(age)!, number: number, iin: iin, major: major, university: university, country: studyCountry, work: workplace, userInfo: userInfo, school: pickedSchool)
        
        networkManager.putEditMentorProfile(credentials: edit) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success(message):
                // some toastview to show that user is registered
                print("\(String(describing: message)): 123")
            case let .failure(error):
                print("\(error): 456")
            }
        }
        
        guard let image = userImageView.image  else { return }
        
        let uploader = ImageUploader(uploadImage: image, number: 1)
        uploader.uploadImage { result in
            switch result {
            case .success(let response):
//                    NotificationCenter.default.post(name: "ProfileEdited", object: nil)
                print("SUCCESS!")
            case .failure(let failure):
                print(failure)
            }
        }

        self.navigationController?.popToRootViewController(animated: true)
    
    }
    
    @IBAction func userImageTapped(_ sender: UIButton) {
        
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
}

extension EditMentorProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            userImageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension EditMentorProfileViewController: UITextFieldDelegate {
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

extension EditMentorProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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

extension EditMentorProfileViewController {
        
    private func loadMentorProfile() {
         //network request
        networkManager.loadMentorProfile() { [weak self] userInfo in
            self?.userInfo = userInfo

            self!.firstNameTextField.text = userInfo.user.firstname
            self!.lastNameTextField.text = userInfo.user.lastname
            self!.ageTextField.text = "\(userInfo.age)"
            self!.numberTextField.text = userInfo.number
            self!.iinTextField.text = userInfo.iin
            self!.majorTextField.text = userInfo.major
            self!.universityField.text = userInfo.university
            self!.countryOfStudyTextField.text = userInfo.country
            self!.workplaceTextField.text = userInfo.work
            self!.emailTextField.text = userInfo.user.email
            self!.userInfoTextView.text = userInfo.userInfo
            self!.schoolTextField.text = userInfo.school
            
            if let encodedImage = userInfo.user.image?.data,
                let imageData = Data(base64Encoded: encodedImage, options: .ignoreUnknownCharacters) {
                self!.userImageView.image = UIImage(data: imageData)
            }
        }
    }
}


