//
//  MentorListTableViewCell.swift
//  MentorsHakaton
//
//  Created by Aida Moldaly on 10.07.2022.
//

import UIKit

class MentorListTableViewCell: UITableViewCell {

    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userRateLabel: UILabel!
    @IBOutlet var universityLabel: UILabel!
    @IBOutlet var majorLabel: UILabel!
    
    func configure(with mentorsList: Mentor) {

        if mentorsList.user.image != nil {
            if let encodedImage = mentorsList.user.image?.data,
                let imageData = Data(base64Encoded: encodedImage, options: .ignoreUnknownCharacters) {
                userImageView.image = UIImage(data: imageData)
            }
        } else {
            userImageView.image = UIImage(named: "default.jpeg")
        }
        
        userNameLabel.text = "\(mentorsList.user.lastname) \(mentorsList.user.firstname)"
        if mentorsList.rating != nil {
            userRateLabel.text = "\(mentorsList.rating)"
        } else {
            userRateLabel.text = "★ 0"
        }
           
        universityLabel.text = mentorsList.university
        majorLabel.text = mentorsList.major
    }
    
}
