//
//  NotifcationTableViewCell.swift
//  MentorsHakaton
//
//  Created by Aida Moldaly on 14.07.2022.
//

import UIKit

class NotifcationTableViewCell: UITableViewCell {
    
    var networkManager = NetworkManagerAF.shared
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var schoolLabel: UILabel!
    @IBOutlet var confirmView: UIView!
    @IBOutlet var rejectView: UIView!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var rejectButton: UIButton!
    
    var id: Int?

    func configure(with menteesList: FollowMwnteeProfile) {

        confirmView.layer.borderWidth = 2
        confirmView.layer.borderColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
        rejectView.layer.borderWidth = 2
        rejectView.layer.borderColor = #colorLiteral(red: 1, green: 0.2332399487, blue: 0.1861645281, alpha: 1)
        print("MY ID IS \(id)")
        if menteesList.user.image != nil {
            if let encodedImage = menteesList.user.image?.data,
                let imageData = Data(base64Encoded: encodedImage, options: .ignoreUnknownCharacters) {
                userImageView.image = UIImage(data: imageData)
            }
        } else {
            userImageView.image = UIImage(named: "default.jpeg")
        }
        
        userNameLabel.text = "\(menteesList.user.lastname) \(menteesList.user.firstname)"
           
        schoolLabel.text = menteesList.school
    }
    
    
    
    
//    @IBAction func confirmButtonTapped(_ sender: UIButton) {
//
//        networkManager.postConfirm(id: id!) { [weak self] result in
//            guard self != nil else { return }
//            switch result {
//            case let .success(message):
//                print("\(String(describing: message)): 123")
//
//                self!.confirmButton.backgroundColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
//                self!.confirmButton.tintColor = .white
//
//            case let .failure(error):
//
//                print("\(error): 456")
//            }
//        }
//    }
    
//    @IBAction func rejectButtonTapped(_ sender: Any) {
//
//        networkManager.postReject(id: id!) { [weak self] result in
//            guard self != nil else { return }
//            switch result {
//            case let .success(message):
//                print("\(String(describing: message)): 123")
//
//                self!.rejectButton.backgroundColor = #colorLiteral(red: 1, green: 0.2332399487, blue: 0.1861645281, alpha: 1)
//                self!.rejectButton.tintColor = .white
//
//            case let .failure(error):
//
//                print("\(error): 456")
//            }
//        }
//    }
}
