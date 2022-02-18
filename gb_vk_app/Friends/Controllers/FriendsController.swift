//
//  FriendsController.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 03.02.2022.
//

import UIKit

class FriendsController: UITableViewController {
    
    let friends = User.getFriends()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendCell
        let friend = friends[indexPath.row]

        cell.userNameLabel.text = "\(friend.firstName) \(friend.lastName)"
        if friend.avatar == nil {
            cell.userAvatarView.image = UIImage(named: "horse")
        } else {
            cell.userAvatarView.image = friend.avatar
        }

        return cell
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "friendsPhotoSegue",
           let indexPath = tableView.indexPathForSelectedRow,
           let photoVC = segue.destination as? FriendsPhotoController {
            let photos = friends[indexPath.row].photos
            photoVC.photos = photos
        }
    }
    
}
