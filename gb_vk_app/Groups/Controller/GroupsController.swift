//
//  GroupsController.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 03.02.2022.
//

import UIKit
import RealmSwift

/// Контроллер для отображения списка групп текущего пользователя
class GroupsController: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar! { didSet { searchBar.delegate = self } }
    
    // MARK: - Properties
    
    var groups: Results<Group>?
    var token: NotificationToken?
    let networkService = NetworkService(token: Session.instance.accessToken)
    
    fileprivate lazy var filteredGroups = self.groups
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // как только загружается экран - загружаем данные из Realm
        loadGroupsDataFromRealm()
        
        // далее делаем запрос на бэк и загружаем новые актуальные данные из Realm
        networkService.loadGroups { [weak self] in
            self?.loadGroupsDataFromRealm()
            self?.pairGroupTableAndRealm()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredGroups!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupCell.reuseId, for: indexPath) as! GroupCell
        let group = filteredGroups![indexPath.row]
        
        cell.configureGroupCell(with: group)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let groupToDelete = filteredGroups?[indexPath.row] else { return }
            
            do {
                let realm = try Realm()
                realm.beginWrite()
                realm.delete(groupToDelete)
                try realm.commitWrite()
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - Functions
    
    /// Получение групп текущего пользователя из базы Realm
    func loadGroupsDataFromRealm() {
        do {
            let realm = try Realm()
            let groups = realm.objects(Group.self)
            self.groups = groups
            self.filteredGroups = groups
            self.tableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    /// Получить из базы список друзей и подписаться на уведомления о ее изменении
    func pairGroupTableAndRealm() {
        guard let realm = try? Realm() else { return }
        
        groups = realm.objects(Group.self)
        
        token = groups?.observe { [weak self] (changes: RealmCollectionChange) in
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
    
}

// MARK: - UISearchBarDelegate

extension GroupsController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterGroups(with: searchText)
    }
    
    fileprivate func filterGroups(with text: String) {
        if text.isEmpty {
            filteredGroups = groups
            tableView.reloadData()
            return
        }
        
//        filteredGroups = groups.filter { $0.name.lowercased().contains(text.lowercased()) }
        tableView.reloadData()
    }
    
}
