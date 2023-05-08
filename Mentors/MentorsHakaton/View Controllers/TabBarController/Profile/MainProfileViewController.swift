//
//  MainProfileViewController.swift
//  MentorsHakaton
//
//  Created by tamzimun on 11.07.2022.
//

import UIKit
import SwiftKeychainWrapper

class MainProfileViewController: UIViewController {
    
    let retrievedRole: String? = KeychainWrapper.standard.string(forKey: "role")
    
    private let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private lazy var isMentor: Bool = true
    
    private lazy var mentor = mainStoryboard.instantiateViewController(withIdentifier: "MentorProfileViewController") as! MentorProfileViewController
    
    private lazy var mentee = mainStoryboard.instantiateViewController(withIdentifier: "MenteeProfileViewController") as! MenteeProfileViewController
    

    override func loadView() {
        super.loadView()
        
        if retrievedRole == "\"ROLE_MENTOR\"" {
            add(mentor)
        } else {
            add(mentee)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
