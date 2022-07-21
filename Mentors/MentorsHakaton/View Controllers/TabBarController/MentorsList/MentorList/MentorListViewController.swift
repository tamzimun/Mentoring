//
//  MentiListViewController.swift
//  MentorsHakaton
//
//  Created by Aida Moldaly on 10.07.2022.
//

import UIKit

class MentorListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    private let networkManager: NetworkManagerAF = .shared
    
    var mentorsList: [Mentor] = []
    {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func loadView() {
        super.loadView()
        loadMentorList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMentorList()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMentorList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadMentorList()
    }
    
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "FilterViewController")
        
        if let presentationController = viewController.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }
        self.present(viewController, animated: true)
    }
}

extension MentorListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentorsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MentorListTableViewCell") as! MentorListTableViewCell
        cell.configure(with: mentorsList[indexPath.row])
        cell.userNameLabel.isHidden = false
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "MentorFollowViewController") as! MentorFollowViewController
        
        networkManager.loadMentorsList() { [weak self] mentorsList in
            self?.mentorsList = mentorsList
            
            vc.mentorId = mentorsList[indexPath.row].user.id

            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}

extension MentorListViewController {
    private func loadMentorList() {
         //network request
        networkManager.loadMentorsList() { [weak self] mentorsList in
            self?.mentorsList = mentorsList
            self?.tableView.reloadData()
        }
    }
}


