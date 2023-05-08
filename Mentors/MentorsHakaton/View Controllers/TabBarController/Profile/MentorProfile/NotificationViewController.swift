//
//  NotificationViewController.swift
//  MentorsHakaton
//
//  Created by tamzimun on 14.07.2022.
//

import UIKit
import SwiftKeychainWrapper
import Cosmos
import TinyConstraints

    
protocol PassId: AnyObject {
    func passId(index: Int)
}
   
class NotificationViewController: UIViewController {

    var networkManager = NetworkManagerAF.shared
    
    @IBOutlet var tableView: UITableView!
   
    weak var delegate: PassId?
    
    var menteesList: [FollowMwnteeProfile] = []
    {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func loadView() {
        super.loadView()
        loadMenteeList()
        
    }
    var id: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMenteeList()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMenteeList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadMenteeList()
    }
}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menteesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotifcationTableViewCell") as! NotifcationTableViewCell

        networkManager.loadMenteeFollowList() { [weak self] menteesList in
            self?.menteesList = menteesList
            cell.id = menteesList[indexPath.row].id
        }
        cell.configure(with: menteesList[indexPath.row])
        cell.userNameLabel.isHidden = false
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
}

extension NotificationViewController {
    private func loadMenteeList() {
         //network request
        networkManager.loadMenteeFollowList() { [weak self] menteesList in
            self?.menteesList = menteesList
            self?.tableView.reloadData()
        }
    }
}
