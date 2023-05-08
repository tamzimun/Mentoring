//
//  MentorFollowViewController.swift
//  MentorsHakaton
//
//  Created by tamzimun on 14.07.2022.
//

import UIKit
import SwiftKeychainWrapper
import Cosmos
import TinyConstraints

class MentorFollowViewController: UIViewController {

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
    
    private var userInfo: MentorSelected?
    @IBOutlet var followView: UIView!
    @IBOutlet var followButton: UIButton!
    private var transparentView = UIView()
    private var tableView = UITableView()
    private var height: CGFloat = 150
    private var settingArray = ["Edit", "Logout"]
     
    private var timer: Timer!
    var mentorId: Int?
    let retrievedRole: String? = KeychainWrapper.standard.string(forKey: "role")
    
    override func loadView() {
        super.loadView()
        loadMentorProfile(id: mentorId!)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if retrievedRole == "\"ROLE_MENTOR\"" {
            followButton.isHidden = true
            followView.layer.borderWidth = 0
            followView.layer.borderColor = UIColor.clear.cgColor
        } else {
            followButton.isHidden = false
            followView.layer.borderWidth = 2
            followView.layer.borderColor = #colorLiteral(red: 0.07952011377, green: 0.1588661373, blue: 0.2753580511, alpha: 1)
        }
        
        loadMentorProfile(id: mentorId!)
        
        starsRating.settings.updateOnTouch = false
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MentorProfileTableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMentorProfile(id: mentorId!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadMentorProfile(id: mentorId!)
    }
    
    @IBAction func followButtonTapped(_ sender: UIButton) {
        guard let mentorId = mentorId else {
            return
        }
        
        networkManager.postFollow(id: mentorId) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success(message):
                print("\(String(describing: message)): 123")
                
                self!.followButton.titleLabel?.text = "UNFOLLOW"
                
            case let .failure(error):

                print("\(error): 456")
            }
        }
        
        
    }
    
    @objc
    func setBackgroundColor() {
        followButton.backgroundColor = .white
        followView.tintColor = #colorLiteral(red: 0.09902968258, green: 0.1945458353, blue: 0.3400899768, alpha: 1)
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

extension MentorFollowViewController {
    
    func getFlag(from countryCode: String) -> String {
        countryCode
            .unicodeScalars
            .map({ 127397 + $0.value })
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
    
    private func loadMentorProfile(id: Int) {
         //network request
        networkManager.loadMentorsSelected(id: id) { [weak self] userInfo in
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

            self!.namelabel.text = "\(userInfo.lastname) \(userInfo.firstname)"
            self!.ageTextField.text = "\(userInfo.age)"
            self!.schoolTextField.text = userInfo.school
            self!.majorLabel.text = userInfo.major
            self!.universityField.text = userInfo.university
            self!.userInfoTextView.text = userInfo.userInfo

            if userInfo.image?.data != nil {
                if let encodedImage = userInfo.image?.data,
                    let imageData = Data(base64Encoded: encodedImage, options: .ignoreUnknownCharacters) {
                    self!.userImageView.image = UIImage(data: imageData)
                }
            } else {
                self!.userImageView.image = UIImage(named: "default.jpeg")
            }

        }
    }
}


extension MentorFollowViewController: UITableViewDelegate, UITableViewDataSource {
    
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

