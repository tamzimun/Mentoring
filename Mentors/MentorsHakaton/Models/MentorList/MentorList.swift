//
//  MentorList.swift
//  MentorsHakaton
//
//  Created by Aida Moldaly on 09.07.2022.
//

import Foundation

struct Mentor: Codable {
    struct User: Codable {
        var id: Int
        var firstname: String
        var lastname: String
        var email: String
        var image: UserImage?
    }
    struct UserImage: Codable {
        var data: String?
    }
    
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

struct MentorFilter: Codable {
    var country: String
    var major: String
}

struct MentorSelected: Codable {
    struct UserImage: Codable {
        var data: String?
    }
    
    var firstname: String
    var lastname: String
    var email: String
    var image: UserImage?
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
    var menteesCount: Int
}
