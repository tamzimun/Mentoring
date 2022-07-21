//
//  ShowPostTableViewCell.swift
//  MentorsHakaton
//
//  Created by Aida Moldaly on 10.07.2022.
//

import UIKit

class ShowPostTableViewCell: UITableViewCell {

    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var postTextView: UILabel!
    @IBOutlet var timePostPublished: UILabel!
    @IBOutlet var postTitle: UILabel!
    
    func configure(with post: ShowPost) {
        userImageView.image = post.userImage
        userNameLabel.text = post.userName
        postImageView.image = post.postImage
        postTextView.text = post.postText
        postTitle.text = post.postTitle
        timePostPublished.text = post.postTime
    }

}
