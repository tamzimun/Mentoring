//
//  MentorProfileTableViewCell.swift
//  MentorsHakaton
//
//  Created by tamzimun on 12.07.2022.
//

import UIKit

class MentorProfileTableViewCell: UITableViewCell {

    lazy var backView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 50))
            return view
    }()
    
    lazy var settingImage: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 15, y: 10, width: 30, height: 30))
            return imageView
    }()
    
    lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 60, y: 10, width: self.frame.width - 80, height: 30))
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addSubview(backView)
        backView.addSubview(settingImage)
        backView.addSubview(label)
        // Configure the view for the selected state
    }

}
