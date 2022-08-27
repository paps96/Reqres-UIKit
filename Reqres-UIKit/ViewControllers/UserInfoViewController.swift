//
//  UserInfoViewController.swift
//  Reqres-UIKit
//
//  Created by Pedro Alberto Parra Solis on 24/08/22.
//

import UIKit

class UserInfoViewController: UIViewController {
    
    weak var delegate: UserInfoViewController?
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var FirstNameLabel: UILabel!
    @IBOutlet weak var LastNameLabel: UILabel!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var IDLabel: UILabel!
    
    var userAboutID: Int!
    var actualUser: user!
    
    override func viewWillAppear(_ animated: Bool) {
    
        actualUser = webUtils.shared.fetchUser(userAboutID)
        ProfileImage.imageFromServerURL(actualUser.avatar ?? "", placeHolder: UIImage(systemName: "person"))
        FirstNameLabel.text = actualUser.first_name
        LastNameLabel.text = actualUser.last_name
        EmailLabel.text = actualUser.email
        IDLabel.text = "ID : \(userAboutID!)"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
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
