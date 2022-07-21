//
//  ShowPostViewController.swift
//  MentorsHakaton
//
//  Created by Aida Moldaly on 10.07.2022.
//

import UIKit
import SwiftKeychainWrapper

class MentorShowPostViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var addButton: UIButton!
    private let networkManager: NetworkManagerAF = .shared
    
    var posts: [ShowPost] = [
        ShowPost.init(userImage: UIImage(named: "0.jpeg")!, userName: "Marlen Diana", postImage: UIImage(named: "11.jpeg")!, postText: "Choosing a university is a crucial element in the study choices made by millions of students across the globe.", postTitle: "University", postTime: "20:00"),
        ShowPost.init(userImage: UIImage(named: "33.jpeg")!, userName: "Marlen Dosymhan", postImage: UIImage(named: "22.jpeg")!, postText: "Find your perfect university program with our course guides – covering entry requirements, specializations, career prospects and more.", postTitle: "Your dream university", postTime: "21:35"),
        ShowPost.init(userImage: UIImage(named: "images.jpeg")!, userName: "Zhandoskyzy Asyl", postImage: UIImage(named: "55.jpeg")!, postText: "Working at Google is hard. In the first few weeks I went home every day with the beginnings of a monster headache.", postTitle: "Google", postTime: "14:35"),
        ShowPost.init(userImage: UIImage(named: "3.jpeg")!, userName: "Margulan Aidos", postImage: UIImage(named: "666.jpeg")!, postText: "I started at Google on the 12th of May this year, so my answer here is based on what you might think of as the Noogler experience.", postTitle: "Work", postTime: "22:35"),
    ]
    {
        didSet {
            tableView.reloadData()
        }
    }
    
    let retrievedRole: String? = KeychainWrapper.standard.string(forKey: "role")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if retrievedRole == "\"ROLE_MENTOR\"" {
            addButton.isHidden = false
        } else {
            addButton.isHidden = true
        }
//        loadTournaments()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
    }

    @IBAction func addPostButtonTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPostViewController")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension MentorShowPostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowPostTableViewCell") as! ShowPostTableViewCell
        
        cell.configure(with: posts[indexPath.row])
        cell.userNameLabel.isHidden = false
        cell.postTextView.isHidden = false
        cell.postTitle.isHidden = false
        cell.timePostPublished.isHidden = false
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
}

//extension MentorShowPostViewController {
//    private func loadTournaments() {
//         //network request
//        let retrievedToken: String? = KeychainWrapper.standard.string(forKey: "token")
//
//        networkManager.loadTournaments(token: retrievedToken ?? "") { [weak self] tournaments in
//            self?.tournaments = tournaments
//            self?.tableView.reloadData()
//        }
//    }
//}
