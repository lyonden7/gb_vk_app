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
    
    // MARK: - Properties
    
    var groups = [Group]()
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
        }
    }
    
    // MARK: - Add groups
    
    @IBOutlet weak var searchBar: UISearchBar! { didSet { searchBar.delegate = self } }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredGroups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupCell.reuseId, for: indexPath) as! GroupCell
        let group = filteredGroups[indexPath.row]
        
        cell.configureGroupCell(with: group)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let groupToDelete = filteredGroups[indexPath.row]
            filteredGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            groups.removeAll { group -> Bool in
                return group.name == groupToDelete.name
            }
        }
    }
    
    // MARK: - Functions
    
    /// Получение групп текущего пользователя из базы Realm
    func loadGroupsDataFromRealm() {
        do {
            let realm = try Realm()
            let groups = realm.objects(Group.self)
            self.groups = Array(groups)
            self.filteredGroups = Array(groups)
            self.tableView.reloadData()
        } catch {
            print(error)
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
        
        filteredGroups = groups.filter { $0.name.lowercased().contains(text.lowercased()) }
        tableView.reloadData()
    }
    
}
