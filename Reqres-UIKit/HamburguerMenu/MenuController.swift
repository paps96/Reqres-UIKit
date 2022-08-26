//
//  MenuController.swift
//  Reqres-UIKit
//
//  Created by Pedro Alberto Parra Solis on 25/08/22.
//

import UIKit

class MenuController: UIViewController, UIApplicationDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueEx" {
            let controller = segue.destination as! LoginViewController
            controller.isPresented = false
            controller.navigationItem.backBarButtonItem = .none
            controller.navigationController?.navigationBar.isHidden = true
            
        }
    }
    
    
    @IBAction func logOut() {
        AuthManager.shared.deleteToken()
    }
    

}
