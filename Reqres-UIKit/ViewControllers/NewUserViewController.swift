//
//  NewUserViewController.swift
//  Reqres-UIKit
//
//  Created by Pedro Alberto Parra Solis on 23/08/22.
//

import UIKit

class NewUserViewController: UIViewController, UITextFieldDelegate, UIApplicationDelegate {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registryButton.isEnabled = false
        
        emailTextField.setPadding()
        passwordTextField.setPadding()
        emailTextField.layer.cornerRadius = 10
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.enablesReturnKeyAutomatically = false
        emailTextField.enablesReturnKeyAutomatically = false
    }
    
    func sendRegistryRequest() {
        webUtils.shared.logSignIn(usernameOrEmail: emailTextField.text ?? "", userPassword: passwordTextField.text ?? "", login: false, completion: {response in
            guard response.token != nil else {
                print(response.error as Any)
                return }
            AuthManager.shared.setTemporalToken(response.token!)
            print(response.token as Any)
        })
    }
    
    @IBAction func registry() {
        sendRegistryRequest()
        guard AuthManager.shared.succesfulRegistry else {
            showMessageNewUser(title: "Ocurrio un error", message: "Registro fallido", succes: false)
            return }
        showMessageNewUser(title: "Correcto", message: "Registro Exitoso", succes: true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        registryButton.isEnabled = false
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(
            in: stringRange,
            with: string)
        registryButton.isEnabled = !newText.isEmpty
        return true
    }
    
    func showMessageNewUser(title: String, message: String, succes: Bool) {
        
        guard succes else {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: {_ in
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true)
        })
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
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
