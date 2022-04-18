//
//  NewGroupsController.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 03.02.2022.
//

import UIKit

class NewGroupsController: UITableViewController {
    
    let networkService = NetworkService()
    let token = Session.instance.accessToken
    
    let groups = [
        Group(name: "Российская Премьер-Лига", avatar: UIImage(named: "rpl")),
        Group(name: "Лига Европы", avatar: UIImage(named: "uel")),
        Group(name: "FIFA", avatar: UIImage(named: "fifa")),
        Group(name: "UEFA", avatar: UIImage(named: "uefa")),
        Group(name: "Лига Чемпионов", avatar: UIImage(named: "ucl")),
        Group(name: "Adidas", avatar: UIImage(named: "adidas")),
        Group(name: "Joma", avatar: UIImage(named: "joma")),
        Group(name: "Select", avatar: UIImage(named: "select")),
        Group(name: "Umbro", avatar: UIImage(named: "umbro"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkService.loadSearchGroups(token: token)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupCell.reuseId, for: indexPath) as! GroupCell
        let group = groups[indexPath.row]
        
        cell.groupNameLabel.text = group.name
        if group.avatar == nil {
            cell.groupAvatarView.image = UIImage(named: "horse")
        } else {
            cell.groupAvatarView.image = group.avatar
        }

        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
