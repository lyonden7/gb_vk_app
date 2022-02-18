//
//  GroupsController.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 03.02.2022.
//

import UIKit

class GroupsController: UITableViewController {
    
    fileprivate var groups = [
        Group(name: "Российская Премьер-Лига", avatar: UIImage(named: "rpl")),
        Group(name: "Лига Европы", avatar: UIImage(named: "uel"))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == "addGroup" {
            guard let newGroupsVC = segue.source as? NewGroupsController,
                  let indexPath = newGroupsVC.tableView.indexPathForSelectedRow else { return }
            
            let newGroup = newGroupsVC.groups[indexPath.row]
            
            guard !groups.contains(where: { group -> Bool in
                group.name == newGroup.name
            }) else { return }
            
            groups.append(newGroup)
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! GroupCell
        let group = groups[indexPath.row]
        
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
            groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
