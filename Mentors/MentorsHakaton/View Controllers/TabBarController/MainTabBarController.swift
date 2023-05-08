//
//  TabBarViewController.swift
//  MentorsHakaton
//
//  Created by tamzimun on 11.07.2022.
//

import UIKit
import SwiftKeychainWrapper

class MainTabBarController: UITabBarController {

    let retrievedRole: String? = KeychainWrapper.standard.string(forKey: "role")
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)

    var v1 = MentorShowPostViewController()
    var v2 = MentorProfileViewController()
    var v3 = MainProfileViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        setTabBar()
        self.modalPresentationStyle = .fullScreen
        present(self, animated: true)
    }

    func setTabBar() {
        v1 = mainStoryboard.instantiateViewController(withIdentifier: "MentorShowPostViewController") as! MentorShowPostViewController
        v2 = mainStoryboard.instantiateViewController(withIdentifier: "MentorProfileViewController") as! MentorProfileViewController
        v3 = mainStoryboard.instantiateViewController(withIdentifier: "MainProfileViewController") as! MainProfileViewController

        self.setViewControllers([v1, v2, v3], animated: true)
    }
}
