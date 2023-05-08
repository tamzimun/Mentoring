//
//  MentorProfile.swift
//  MentorsHakaton
//
//  Created by tamzimun on 09.07.2022.
//

import Foundation

struct MentorProfile: Codable {
    var user: User
    var age: Int
    var number: String
    var rating: Double?
    var iin: String
    var major: String
    var university: String
    var country: String
    var work: String
    var userInfo: String
    var school: String
}

struct User: Codable {
    var firstname: String
    var lastname: String
    var email: String
    var image: UserImage?
}

struct UserImage: Codable {
    var data: String?
}

struct EditMentorProfile: Codable {
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



struct FollowMwnteeProfile: Codable {
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

