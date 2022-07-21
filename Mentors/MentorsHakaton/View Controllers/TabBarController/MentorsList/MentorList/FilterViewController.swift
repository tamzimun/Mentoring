//
//  FilterViewController.swift
//  MentorsHakaton
//
//  Created by Aida Moldaly on 14.07.2022.
//

import UIKit

class FilterViewController: UIViewController {

    private let networkManager: NetworkManagerAF = .shared
    
    @IBOutlet var countryPickerView: UIPickerView!
    @IBOutlet var majorPickerView: UIPickerView!
    
    var data: String!
    
    var majors = ["IT", "Business", "Journalism", "Engineering", "Logistics", "Marketing", "The medicine", "Management", "Teachers", "Project management", "Finance", "Economy", "Jurisprudence"]
    private var majorPicked: String = ""
    
    private var countriesOfStudy: [String] = []
    private var countryPicked: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegates()
        setUpElements()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            // TODO: Do your stuff here.
        }
    }
    
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        
        let filter = MentorFilter(country: countryPicked, major: majorPicked)

        
        networkManager.postFilter(credentials: filter) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success(message):
                
                print("\(String(describing: message)): 123")
            case let .failure(error):
                print("\(error): 456")
            }
        }
    }
    
    func delegates() {

        majorPickerView.delegate = self
        majorPickerView.dataSource = self
        majorPickerView.tag = 1
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        countryPickerView.tag = 2
    }
    
    func setUpElements() {

        for code in NSLocale.isoCountryCodes  {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            countriesOfStudy.append(name)
        }
    }
        
}

extension FilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return majors.count
        case 2:
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
            return countriesOfStudy[row]

        default:
            return "Data not found"
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            majorPicked = majors[row]
        case 2:
            countryPicked = countriesOfStudy[row]
        default:
            return
        }

    }
}
