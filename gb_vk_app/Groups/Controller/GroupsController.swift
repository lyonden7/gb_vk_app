//
//  GroupsController.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 03.02.2022.
//

import UIKit

class GroupsController: UITableViewController {
    
    let networkService = NetworkService()
    let token = Session.instance.accessToken
    
    fileprivate var groups = [
        Group(name: "Российская Премьер-Лига", avatar: UIImage(named: "rpl")),
        Group(name: "Лига Европы", avatar: UIImage(named: "uel"))
    ]
    
    fileprivate lazy var filteredGroups = self.groups
    
    // MARK: - System function

    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkService.loadGroups(token: token)
    }
    
    // MARK: - Add groups
    
    
    @IBOutlet weak var searchBar: UISearchBar! { didSet { searchBar.delegate = self } }
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == "addGroup" {
            guard let newGroupsVC = segue.source as? NewGroupsController,
                  let indexPath = newGroupsVC.tableView.indexPathForSelectedRow else { return }
            
            let newGroup = newGroupsVC.groups[indexPath.row]
            
            guard !groups.contains(where: { group -> Bool in
                group.name == newGroup.name
            }) else { return }
            
            groups.append(newGroup)
            filterGroups(with: searchBar.text ?? "")
            tableView.reloadData()
        }
    }
    
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
        
        cell.groupNameLabel.text = group.name
        if group.avatar == nil {
            cell.groupAvatarView.image = UIImage(named: "horse")
        } else {
            cell.groupAvatarView.image = group.avatar
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            groups.remove(at: indexPath.row)
            let groupToDelete = filteredGroups[indexPath.row]
            filteredGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            groups.removeAll { group -> Bool in
                return group.name == groupToDelete.name
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
        
        filteredGroups = groups.filter { $0.name.lowercased().contains(text.lowercased()) }
        tableView.reloadData()
    }
    
}
