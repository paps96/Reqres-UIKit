//
//  LoginViewController.swift
//  Reqres-UIKit
//
//  Created by Pedro Alberto Parra Solis on 23/08/22.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, UIApplicationDelegate {

    
    @IBOutlet weak var imageHeader: UIImageView!
    @IBOutlet weak var welcomeText: UILabel!
    @IBOutlet weak var introduceData: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    var isPresented: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.setPadding()
        emailTextField.layer.cornerRadius = 10
        emailTextField.autocorrectionType = .no
        emailTextField.keyboardType = .emailAddress
        emailTextField.clearButtonRect(forBounds: CGRect(x: 0, y: 0, width: 20, height: 50))
        
        PasswordTextField.setPadding()
        PasswordTextField.layer.cornerRadius = 10
        PasswordTextField.keyboardType = .default
        emailTextField.enablesReturnKeyAutomatically = false
        PasswordTextField.enablesReturnKeyAutomatically = false
        loginButton.isEnabled = false
        
        if isPresented != nil {
            navigationController?.navigationBar.isHidden = true
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.bounds.origin.y = 100
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.view.bounds.origin.y = 0
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        loginButton.isEnabled = !newText.isEmpty
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        loginButton.isEnabled = false
        return true
    }
    
    func executeLogin() {
        webUtils.shared.logSignIn(usernameOrEmail: emailTextField.text ?? "", userPassword: PasswordTextField.text ?? "", login: true, completion: { data in
            guard data.token != nil else {
                self.showMessage(message: "error")
                print(data.error!); return}
            AuthManager.shared.setAccesToken(data.token!)
            DispatchQueue.main.sync {
                self.showNextScreen()
            }
            print(data.token!)
        })
        
    }
    
    func showNextScreen() {
        if AuthManager.shared.isSignedIn && self.isPresented == nil {
            let controller = storyboard!.instantiateViewController(withIdentifier: "tableView") as! ViewController
            controller.navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.pushViewController(
                controller, animated: true)
        } else if AuthManager.shared.isSignedIn && self.isPresented != nil {
            self.navigationController?.popViewController(animated: true)
            print("I can do that")
        }
    }
    
    
    
    @IBAction func loginTouch() {
        self.executeLogin()
    }
    
    func showMessage(message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
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
