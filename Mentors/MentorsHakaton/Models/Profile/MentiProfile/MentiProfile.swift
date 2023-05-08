//
//  MentiProfile.swift
//  MentorsHakaton
//
//  Created by tamzimun on 09.07.2022.
//

import Foundation

struct MenteeProfile: Codable {
    struct User: Codable {
        var firstname: String
        var lastname: String
        var email: String
        var image: UserImage?
    }
    
    struct UserImage: Codable {
        var data: String?
    }
    var id: Int
    var user: User
    var number: String
    var iin: String
    var grade: Int
    var school: String
    var achievements: String
}



struct EditMenteeProfile: Codable {
    var firstname: String
    var lastname: String
    var email: String
    var age: Int
    var number: String
    var iin: String
    var major: String
    var university: String
    var country: String
    var work: String
    var userInfo: String
    var school: String
}
