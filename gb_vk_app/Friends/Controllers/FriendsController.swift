//
//  FriendsController.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 03.02.2022.
//

import UIKit

class FriendsController: UITableViewController {
    
    let friends = User.getFriends()
    let networkService = NetworkService()
    let token = Session.instance.accessToken
    
    // MARK: - Sort
    
    var firstCharacters = [Character]()
    var sortedFriends: [Character: [User]] = [:]
    
    private func sort(_ friends: [User]) -> (characters: [Character], sortedFriends: [Character: [User]]) {
        var characters = [Character]()
        var sortedFriends = [Character: [User]]()
        
        friends.forEach { friend in
            guard let character = friend.firstName.first else { return }
            if var thisCharFriends = sortedFriends[character] {
                thisCharFriends.append(friend)
                sortedFriends[character] = thisCharFriends
            } else {
                sortedFriends[character] = [friend]
                characters.append(character)
            }
        }
        
        characters.sort()
        
        return (characters, sortedFriends)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        (firstCharacters, sortedFriends) = sort(friends)
        
        networkService.loadFriends(token: token)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return firstCharacters.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let character = firstCharacters[section]
        let friendsCount = sortedFriends[character]?.count
        return friendsCount ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.reuseId, for: indexPath) as! FriendCell
        
        let character = firstCharacters[indexPath.section]
        
        if let friends = sortedFriends[character] {
            
            let friend = friends[indexPath.row]
            cell.userNameLabel.text = "\(friend.firstName) \(friend.lastName)"
            if friend.avatar == nil {
                cell.avatarView.imageAvatarView.image = UIImage(named: "horse")
            } else {
                cell.avatarView.imageAvatarView.image = friend.avatar
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let character = firstCharacters[section]
        return String(character)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "friendsPhotoSegue",
           let indexPath = tableView.indexPathForSelectedRow,
           let photoVC = segue.destination as? FriendsPhotoController {
            
            let character = firstCharacters[indexPath.section]
            
            if let friends = sortedFriends[character] {
                let friend = friends[indexPath.row]
                let photos = friend.photos
                photoVC.photos = photos
                photoVC.friend = friend
            }
        }
    }
    
}
