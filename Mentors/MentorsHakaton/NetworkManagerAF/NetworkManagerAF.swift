//
//  NetworkManagerAF.swift
//  MentorsHakaton
//
//  Created by Aida Moldaly on 09.07.2022.
//

import Foundation
import SwiftKeychainWrapper
import Alamofire

final class NetworkManagerAF {

    static var shared = NetworkManagerAF()
    
    
    var urlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "aidateam.herokuapp.com"
        return components
    }()

    private let session: URLSession

    private init() {
        session = URLSession(configuration: .default)
    }
    
    func postMentorRegister(credentials: SignUpMentor, completion: @escaping (Result<String?, Error>) -> Void) {
        
        var components = urlComponents
        components.path = "/api/auth/mentor/signup"
        
        guard let url = components.url else {
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("*/*", forHTTPHeaderField: "Accept")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try? JSONEncoder().encode(credentials)
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APINetworkError.dataNotFound))
                }
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Response is \(String(describing: response))")
                DispatchQueue.main.async {
                    completion(.failure(APINetworkError.httpRequestFailed))
                }
                return
            }
            
            let message = String(data: data, encoding: .utf8)
            DispatchQueue.main.async {
                completion(.success(message))
            }
        }
        task.resume()
    }
    
    func postMentiRegister(credentials: SignUpMenti, completion: @escaping (Result<String?, Error>) -> Void) {
        
        var components = urlComponents
        components.path = "/api/auth/mentee/signup"
        
        guard let url = components.url else {
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("*/*", forHTTPHeaderField: "Accept")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try? JSONEncoder().encode(credentials)
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APINetworkError.dataNotFound))
                }
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Response is \(String(describing: response))")
                DispatchQueue.main.async {
                    completion(.failure(APINetworkError.httpRequestFailed))
                }
                return
            }
            
            let message = String(data: data, encoding: .utf8)
            DispatchQueue.main.async {
                completion(.success(message))
            }
        }
        task.resume()
    }
    
    func postLogin(credentials: Login, completion: @escaping (Result<String?, Error>) -> Void) {
        
        var components = urlComponents
        components.path = "/api/auth/signin"
        guard let url = components.url else {
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("*/*", forHTTPHeaderField: "Accept")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try? JSONEncoder().encode(credentials)

        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APINetworkError.dataNotFound))
                }
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                DispatchQueue.main.async {
                    completion(.failure(APINetworkError.httpRequestFailed))
                }
                return
            }
            let message = String(data: data, encoding: .utf8)
            DispatchQueue.main.async {
                completion(.success(message))
            }
        }
        task.resume()
    }
    
    
    func loadMentorProfile(completion: @escaping (MentorProfile) -> Void) {
        
        var components = urlComponents
        components.path = "/api/user/profile"

        guard let url = components.url else {
            return
        }
        var retrievedToken: String? {
            get{
                KeychainWrapper.standard.string(forKey: "token")
            }
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("Bearer \(retrievedToken ?? "")", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpMethod = "GET"
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET")
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("\(String(describing: response))")
                print("Error: HTTP request failed")
                return
            }
            do {
                let mentorProfile = try JSONDecoder().decode(MentorProfile.self, from: data)
                DispatchQueue.main.async {
                    completion(mentorProfile)
                }

            } catch {
                print("no json")
            }
        }
        task.resume()
    }
    
    
    func putEditMentorProfile(credentials: EditMentorProfile, completion: @escaping (Result<String?, Error>) -> Void) {
        
        var components = urlComponents
        components.path = "/api/mentor/profile/edit"
        guard let url = components.url else {
            return
        }

        var retrievedToken: String? {
            get{
                KeychainWrapper.standard.string(forKey: "token")
            }
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("Bearer \(retrievedToken ?? "")", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("*/*", forHTTPHeaderField: "Accept")
        urlRequest.httpMethod = "PUT"
        urlRequest.httpBody = try? JSONEncoder().encode(credentials)

        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APINetworkError.dataNotFound))
                }
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                DispatchQueue.main.async {
                    print("my response is \(response)")
                    completion(.failure(APINetworkError.httpRequestFailed))
                }
                return
            }
            let message = String(data: data, encoding: .utf8)
            DispatchQueue.main.async {
                completion(.success(message))
            }
        }
        task.resume()
    }
    
    func loadMentorsList(completion: @escaping ([Mentor]) -> Void) {
        
        var components = urlComponents
        components.path = "/api/mentors"

        guard let url = components.url else {
            return
        }
        var retrievedToken: String? {
            get{
                KeychainWrapper.standard.string(forKey: "token")
            }
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("Bearer \(retrievedToken ?? "")", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpMethod = "GET"
//        print("my token is \(retrievedToken ?? "")")
//        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET")
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("\(String(describing: response))")
                print("Error: HTTP request failed")
                return
            }
            do {
                let mentorList = try JSONDecoder().decode([Mentor].self, from: data)
                
                DispatchQueue.main.async {
                    completion(mentorList)
                }

            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
    func postFilter(credentials: MentorFilter, completion: @escaping (Result<String?, Error>) -> Void) {
        
        var components = urlComponents
        components.path = "/api/mentors/filter"
        guard let url = components.url else {
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("*/*", forHTTPHeaderField: "Accept")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try? JSONEncoder().encode(credentials)

        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APINetworkError.dataNotFound))
                }
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                DispatchQueue.main.async {
                    completion(.failure(APINetworkError.httpRequestFailed))
                }
                return
            }
            let message = String(data: data, encoding: .utf8)
            DispatchQueue.main.async {
                completion(.success(message))
            }
        }
        task.resume()
    }
    
    func loadMenteesList(completion: @escaping ([MenteeProfile]) -> Void) {
        
        var components = urlComponents
        components.path = "/api/mentors"

        guard let url = components.url else {
            return
        }
        var retrievedToken: String? {
            get{
                KeychainWrapper.standard.string(forKey: "token")
            }
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("Bearer \(retrievedToken ?? "")", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpMethod = "GET"

        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET")
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("\(String(describing: response))")
                print("Error: HTTP request failed")
                return
            }
            do {
                let menteeProfile = try JSONDecoder().decode([MenteeProfile].self, from: data)
                
                DispatchQueue.main.async {
                    completion(menteeProfile)
                }

            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
    
    func loadMentorsSelected(id: Int, completion: @escaping (MentorSelected) -> Void) {
        
        var components = urlComponents
        components.path = "/api/mentors/\(id)"

        guard let url = components.url else {
            return
        }
        var retrievedToken: String? {
            get{
                KeychainWrapper.standard.string(forKey: "token")
            }
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("Bearer \(retrievedToken ?? "")", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpMethod = "GET"
//        print("my token is \(retrievedToken ?? "")")
//
        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET")
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("\(String(describing: response))")
                print("Error: HTTP request failed")
                return
            }
            do {
                let mentorList = try JSONDecoder().decode(MentorSelected.self, from: data)
                
                DispatchQueue.main.async {
                    completion(mentorList)
                }

            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
    func postFollow(id: Int, completion: @escaping (Result<String?, Error>) -> Void) {
        var components = urlComponents
        components.path = "/api/mentor/\(id)/subscribe"
        guard let url = components.url else {
            return
        }

        var retrievedToken: String? {
            get{
                KeychainWrapper.standard.string(forKey: "token")
            }
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("*/*", forHTTPHeaderField: "Accept")
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("Bearer \(retrievedToken ?? "")", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = try? JSONEncoder().encode(id)
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                    print(error!)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APINetworkError.dataNotFound))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                DispatchQueue.main.async {
                    completion(.failure(APINetworkError.httpRequestFailed))
                    print(response!)
                }
                return
            }
            
            let message = String(data: data, encoding: .utf8)
            DispatchQueue.main.async {
                completion(.success(message))
            }
        }
        task.resume()
    }
    
    
    func loadMenteeFollowList(completion: @escaping ([FollowMwnteeProfile]) -> Void) {
        
        var components = urlComponents
        components.path = "/api/mentor/subscribers"

        guard let url = components.url else {
            return
        }
        var retrievedToken: String? {
            get{
                KeychainWrapper.standard.string(forKey: "token")
            }
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("Bearer \(retrievedToken ?? "")", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpMethod = "GET"

        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET")
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("\(String(describing: response))")
                print("Error: HTTP request failed")
                return
            }
            do {
                let menteeProfile = try JSONDecoder().decode([FollowMwnteeProfile].self, from: data)
                
                DispatchQueue.main.async {
                    completion(menteeProfile)
                }

            } catch let error {
                print(error)
            }
        }
        task.resume()
    }

    func postConfirm(id: Int, completion: @escaping (Result<String?, Error>) -> Void) {
        var components = urlComponents
        components.path = "/api/mentor/mentee/\(id)/confirm"
        guard let url = components.url else {
            return
        }

        var retrievedToken: String? {
            get{
                KeychainWrapper.standard.string(forKey: "token")
            }
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("*/*", forHTTPHeaderField: "Accept")
        urlRequest.httpMethod = "PUT"
        urlRequest.addValue("Bearer \(retrievedToken ?? "")", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = try? JSONEncoder().encode(id)
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                    print(error!)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APINetworkError.dataNotFound))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                DispatchQueue.main.async {
                    completion(.failure(APINetworkError.httpRequestFailed))
                    print(response!)
                }
                return
            }
            
            let message = String(data: data, encoding: .utf8)
            DispatchQueue.main.async {
                completion(.success(message))
            }
        }
        task.resume()
    }
    
    func postReject(id: Int, completion: @escaping (Result<String?, Error>) -> Void) {
        var components = urlComponents
        components.path = "/api/mentor/mentee/\(id)/reject"
        guard let url = components.url else {
            return
        }

        var retrievedToken: String? {
            get{
                KeychainWrapper.standard.string(forKey: "token")
            }
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("*/*", forHTTPHeaderField: "Accept")
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("Bearer \(retrievedToken ?? "")", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = try? JSONEncoder().encode(id)
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                    print(error!)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APINetworkError.dataNotFound))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                DispatchQueue.main.async {
                    completion(.failure(APINetworkError.httpRequestFailed))
                    print(response!)
                }
                return
            }
            
            let message = String(data: data, encoding: .utf8)
            DispatchQueue.main.async {
                completion(.success(message))
            }
        }
        task.resume()
    }
    
}


