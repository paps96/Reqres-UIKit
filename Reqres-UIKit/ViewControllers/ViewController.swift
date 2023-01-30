//
//  ViewController.swift
//  Reqres-UIKit
//
//  Created by Pedro Alberto Parra Solis on 23/08/22.
//

import UIKit
import SideMenu

class ViewController: UITableViewController {
    
    var menu: SideMenuNavigationController?
    var list: [user] = []
    let webManager = webUtils.shared
    
    //MARK: Init View
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController!.navigationBar.prefersLargeTitles = true
        navigationItem.hidesBackButton = true
        navigationController!.navigationBar.isHidden = false
        self.getUsers(completion: {
            availableUser in
            do {
                self.list = try availableUser.get()
                self.tableView.reloadData()
                print("Number of items \(self.list.count) data")
            } catch {
                print("cannot fetch data: \(error)")
            }
        })
    }
    
    func getUsers(completion: @escaping (Result<[user], Error>) -> Void) {
        Task {
            do {
                let result = try await webManager.fetchDataUsers()
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootVC = storyboard.instantiateViewController(identifier: "Hamburguer")
        
        menu = SideMenuNavigationController(rootViewController: rootVC)
        menu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: menu!.view)
        
        let nib = UINib(nibName: "ProtoTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ProtoTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        navigationController!.navigationBar.prefersLargeTitles = true
        navigationItem.hidesBackButton = true
        navigationController!.navigationBar.isHidden = false
        
    }
    
    //MARK: Button Properties
    
    @IBAction func logOut() {
        let loginScreen = storyboard!.instantiateViewController(withIdentifier: "LoginPage") as! LoginViewController
        navigationController?.pushViewController(loginScreen, animated: true)
    }
    
    @IBAction func didTapMenu() {
        present(menu!, animated: true)
    }

    //MARK: Table Properties
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ProtoTableViewCell", for: indexPath) as! ProtoTableViewCell
        let checklist = list[indexPath.row]
        cell.NameCell.text = checklist.first_name
        cell.LastNameCell.text = checklist.last_name
        cell.EmailCell.text = checklist.email
        cell.ImageCell.imageFromServerURL(checklist.avatar ?? "", placeHolder: UIImage(systemName: "person"))
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "UserInfoViewController") as! UserInfoViewController
        let checklist = list[indexPath.row].id
        controller.userAboutID = checklist
        navigationController?.pushViewController(controller, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

struct listUsers {
    let name: String
    let last_name: String
    let email: String
    let id: Int
    let avatar: String?
}
