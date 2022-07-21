//
//  Utilities.swift
//  MentorsHakaton
//
//  Created by Aida Moldaly on 09.07.2022.
//

import Foundation
import UIKit

class Utilities {
    
    static func styleFilledButton(_ button: UIButton) {
        
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    
        
    }
    
    static func styleFilledButtenTapped(_ button: UIButton) {

        let customCollor = #colorLiteral(red: 0.09902968258, green: 0.1945458353, blue: 0.3400899768, alpha: 1)
        button.backgroundColor = customCollor
        button.tintColor = .white
        button.layer.cornerRadius = 25.0
    }
    
    static func styleHollowButton(_ button: UIButton) {
        
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    static func styleHollowBorderButton(_ button: UIButton) {
        
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    
    static func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@gmail.com"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func isPasswordValid(_ password: String) -> Bool {
        
        let passwordText = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{3,}$")
        return passwordText.evaluate(with: password)
    }
    
    static func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
}



