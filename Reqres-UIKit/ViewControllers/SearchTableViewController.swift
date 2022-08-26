//
//  SearchTableViewController.swift
//  Reqres-UIKit
//
//  Created by Pedro Alberto Parra Solis on 25/08/22.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    //MARK: Variables and References
    
    @IBOutlet weak var searchNavigationBar: UINavigationItem!
    
    var allUsers = webUtils.users
    var userBackup = [user]()
    var copyUsers = [onlineUsers]()
    var recents = CoreDataManager.shared.searchedFinal.convertIntoOnlineUser()
    var tableTitle = "Recientes"
    
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 250, height: 20))
    
    //MARK: Init View
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.becomeFirstResponder()
        copyUsers = CoreDataManager.shared.searchedFinal.convertIntoOnlineUser()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Buscar"
        let leftNavBarButton = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = leftNavBarButton
        self.searchBar.enablesReturnKeyAutomatically = false
        self.searchBar.returnKeyType = .search
        self.searchBar.searchTextField.clearButtonMode = .whileEditing

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?  {
        return tableTitle
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recents.count
    }
    
    func configureText(for cell: UITableViewCell, with item: onlineUsers) {
        let nameLabel = cell.viewWithTag(1000) as! UILabel
        let emailLabel = cell.viewWithTag(1001) as! UILabel
        
        nameLabel.text = "\(item.first_name), \(item.last_name)"
        emailLabel.text = item.email
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
                    withIdentifier: "searchCell",
                    for: indexPath)
        
        let item = recents[indexPath.row]
        configureText(for: cell, with: item)
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "UserInfoViewController") as! UserInfoViewController
        
        let checklist = recents[indexPath.row]
        controller.userAboutID = checklist.id
        navigationController?.pushViewController(
            controller, animated: true)
        
        CoreDataManager.shared.saveSearch(user: checklist.convertToUser())
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    //MARK: Search Bar properties
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let filterUsers = allUsers.filter { person in
            return (person.first_name.contains(searchText) || person.last_name.contains(searchText) || person.email.contains(searchText))
        }
        
        recents = searchText.isEmpty ? copyUsers : filterUsers
        tableTitle = searchText.isEmpty ? "Recientes" : "Coincidencias"
        self.tableView.reloadData()
    }
    
//    func updateSearchResults(for searchController: UISearchController) {
//        let searchText = searchController.searchBar.text ?? ""
//        let filterUsers = persons.filter { person in
////            return (person.first_name.contains(searchText) || person.last_name.contains(searchText) || person.email.contains(searchText))
//        }
//
//        persons = searchText.isEmpty ? copyPersons : filterUsers
//        self.tableView.reloadData()
//    }

    

}
