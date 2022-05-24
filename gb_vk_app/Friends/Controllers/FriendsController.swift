//
//  FriendsController.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 03.02.2022.
//

import UIKit

/// Контроллер для отображения списка друзей
class FriendsController: UITableViewController {
    
    var friends = [Friend]()
    let networkService = NetworkService(token: Session.instance.accessToken)

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkService.loadFriends { [weak self] friend in
            self?.friends = friend
            self?.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.reuseId, for: indexPath) as! FriendCell
        
        cell.configureFriendCell(with: friends[indexPath.row])
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "friendsPhotoSegue",
           let indexPath = tableView.indexPathForSelectedRow,
           let photoVC = segue.destination as? FriendsPhotoController {
            let friend = friends[indexPath.row]
            photoVC.friend = friend
            photoVC.ownerId = friend.id
        }
    }
    
}
