//
//  FriendsController.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 03.02.2022.
//

import UIKit
import RealmSwift

/// Контроллер для отображения списка друзей
class FriendsController: UITableViewController {
    
    // MARK: - Properties
    
    var friends: Results<Friend>?
    var token: NotificationToken?
    let networkService = NetworkService(token: Session.instance.accessToken)

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // как только загружается экран - загружаем данные из Realm
        loadFriendsDataFromRealm()
        
        // далее делаем запрос на бэк и загружаем новые актуальные данные из Realm
        networkService.loadFriends { [weak self] in
            self?.loadFriendsDataFromRealm()
            self?.pairFriendsTableAndRealm()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.reuseId, for: indexPath) as! FriendCell
        
        cell.configureFriendCell(with: friends![indexPath.row])
        return cell
    }
    
    // MARK: - Functions
    
    /// Получение списка друзей из базы Realm
    func loadFriendsDataFromRealm() {
        do {
            let realm = try Realm()
            let friends = realm.objects(Friend.self)
            self.friends = friends
            self.tableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    /// Получить из базы список друзей и подписаться на уведомления о ее изменении
    func pairFriendsTableAndRealm() {
        guard let realm = try? Realm() else { return }
        
        friends = realm.objects(Friend.self)
        
        token = friends?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case let .update(_, deletions, insertions, modifications):
                tableView.beginUpdates()
                
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "friendsPhotoSegue",
           let indexPath = tableView.indexPathForSelectedRow,
           let photoVC = segue.destination as? FriendsPhotoController {
            let friend = friends![indexPath.row]
            photoVC.friend = friend
            photoVC.ownerId = friend.id
        }
    }
    
}
