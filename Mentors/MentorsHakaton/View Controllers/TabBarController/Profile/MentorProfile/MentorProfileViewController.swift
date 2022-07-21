//
//  MentorProfileViewController.swift
//  MentorsHakaton
//
//  Created by Aida Moldaly on 10.07.2022.
//

import UIKit
import SwiftKeychainWrapper
import Cosmos
import TinyConstraints

class MentorProfileViewController: UIViewController {

    var networkManager = NetworkManagerAF.shared
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var rate: UILabel!
    @IBOutlet var namelabel: UILabel!
    @IBOutlet var ageTextField: UILabel!
    @IBOutlet var schoolTextField: UILabel!
    @IBOutlet var majorLabel: UILabel!
    @IBOutlet var universityField: UILabel!
    @IBOutlet var countryOfStudyTextField: UILabel!
    @IBOutlet var userInfoTextView: UILabel!
    
    @IBOutlet var postNumberLabel: UILabel!
    @IBOutlet var followersNumberLabel: UILabel!
    @IBOutlet var votesLabel: UILabel!
    @IBOutlet var numberTextField: UILabel!
    @IBOutlet var emailTextField: UILabel!
    @IBOutlet var logOutButton: UIButton!
    @IBOutlet var settingsButton: UIButton!
    @IBOutlet var starsRating: CosmosView!
    
    
    private var userInfo: MentorProfile?
    private var transparentView = UIView()
    private var tableView = UITableView()
    private var height: CGFloat = 150
    private var settingArray = ["Edit", "Logout"]
    override func loadView() {
        super.loadView()
        loadMentorProfile()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMentorProfile()
        starsRating.settings.updateOnTouch = false
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MentorProfileTableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMentorProfile()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadMentorProfile()
    }
    
    @IBAction func notification(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NotificationViewController")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    @IBAction func onClickSettings(_ sender: Any) {
        let window = UIApplication.shared.keyWindow
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        transparentView.frame = self.view.frame
        window?.addSubview(transparentView)
        
        let screenSize = UIScreen.main.bounds.size
        tableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: height)
        window?.addSubview(tableView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickTransparentView))
        transparentView.addGestureRecognizer(tapGesture)
        
        transparentView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut) {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: 0, y: screenSize.height - self.height, width: screenSize.width, height: self.height)
        } completion: { _ in
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: 0, y: screenSize.height - self.height, width: screenSize.width, height: self.height)
        }

        
    }
    
    @objc
    func onClickTransparentView() {
        let screenSize = UIScreen.main.bounds.size
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut) {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.height)
        } completion: { _ in
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.height)
        }
        
    }
    
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        
    }
    
}

extension MentorProfileViewController {
    
    func getFlag(from countryCode: String) -> String {
        countryCode
            .unicodeScalars
            .map({ 127397 + $0.value })
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
    
    private func loadMentorProfile() {
         //network request
        networkManager.loadMentorProfile() { [weak self] userInfo in
            self?.userInfo = userInfo

            let locale = Locale(identifier: "en_US_POSIX")
            let countryCode = locale.isoCode(for: userInfo.country)

            if let countryCode = countryCode {
                let flag = self!.getFlag(from: countryCode)
                self!.countryOfStudyTextField.text = flag
            } else {
                self!.countryOfStudyTextField.text = "in " + userInfo.country
            }
            if userInfo.rating != nil {
                self!.starsRating.rating = userInfo.rating!
                self!.rate.text = "★ \(userInfo.rating!)"
            } else {
                self!.starsRating.rating = 0.0
                self!.rate.text = "★ 0"
            }
            
            self!.namelabel.text = "\(userInfo.user.lastname) \(userInfo.user.firstname)"
            self!.ageTextField.text = "\(userInfo.age)"
            self!.schoolTextField.text = userInfo.school
            self!.majorLabel.text = userInfo.major
            self!.universityField.text = userInfo.university
            self!.userInfoTextView.text = userInfo.userInfo
            
            if userInfo.user.image?.data != nil {
                if let encodedImage = userInfo.user.image?.data,
                    let imageData = Data(base64Encoded: encodedImage, options: .ignoreUnknownCharacters) {
                    self!.userImageView.image = UIImage(data: imageData)
                }
            } else {
                self!.userImageView.image = UIImage(named: "default.jpeg")
            }
            
        }
    }
}

extension Locale {
    func isoCode(for countryName: String) -> String? {
        return Locale.isoRegionCodes.first(where: { (code) -> Bool in
            localizedString(forRegionCode: code)?.compare(countryName, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
        })
    }
}


extension MentorProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MentorProfileTableViewCell
        cell.label.text = settingArray[indexPath.row]
        cell.settingImage.image = UIImage(named: settingArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        onClickTransparentView()
        switch indexPath.row {
        case 0:
            let vc = storyboard?.instantiateViewController(withIdentifier: "EditMentorProfileViewController") 
            self.navigationController?.pushViewController(vc!, animated: true)
        case 1:
            
            let alert = UIAlertController(title: "Logout", message: "Confirm logout?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] (action:UIAlertAction) in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let authorizationNavController = storyboard.instantiateViewController(identifier: "AuthorizationNavController")
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(authorizationNavController)
            }))
            self.present(alert, animated: true, completion: nil)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        default:
            print("Unabled to create viewController")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
