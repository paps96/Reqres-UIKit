//
//  WebUtils.swift
//  Reqres-UIKit
//
//  Created by Pedro Alberto Parra Solis on 23/08/22.
//

import Foundation
import Combine
import UIKit

struct requestData: Decodable {
    var id: Int?
    var token: String?
    var error: String?
}

struct user: Hashable, Decodable {
    let id: Int
    let email: String
    let first_name: String
    let last_name: String
    let avatar: String?
}

struct page: Decodable {
    let page: Int?
    let per_page: Int?
    let total: Int?
    let total_pages: Int?
    let data: [user]
}

struct singleUser: Decodable {
    let data: user?
}

struct onlineUsers {
    let first_name: String
    let last_name: String
    let email: String
    let id: Int
    let avatarImage: UIImage?
}


/// Clase que maneja todo lo referente a las peticiones get y post
class webUtils {
    
    static var users: [onlineUsers] = []
    
    var isLoadedUsers: Bool {
        return !webUtils.users.isEmpty
    }
    
    private var allUsers: [user] = []
    var single: user?
    
    static let shared = webUtils()
    
    /// Función que consume la Api de reqres para el inicio de sesión y registro de usuarios, estas dos operaciones corresponde a una solicitud del tipo "POST"
    /// - Parameters:
    ///   - usernameOrEmail: Nombre de usuario o email
    ///   - userPassword: Contraseña de la cuenta asociada
    ///   - login: Si es verdadero corresponde a una solicitud para iniciar sesión, falso para el registro de un nuevo usuario
    ///   - completion: Función para sincronizar los datos recibidos con la respuesta en pantalla
    func logSignIn(usernameOrEmail: String, userPassword: String, login: Bool, completion: @escaping (requestData) -> ()) {
        
        let parameters: [String: String] = ["email": usernameOrEmail, "password": userPassword]
        let url = login ? URL(string: "https://reqres.in/api/login")! : URL(string: "https://reqres.in/api/register")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                return
            }
        request.httpBody = httpBody
        request.timeoutInterval = 0
        let session = URLSession.shared
        
        let semaphore = DispatchSemaphore(value: 0)
        
        session.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode == 200 {
                
                guard let data = data else { return }
                    
//                DispatchQueue.main.async {
                    do {
                        let dataResponse = try JSONDecoder().decode(requestData.self, from: data)
                        completion(dataResponse)
                        
                        print(dataResponse)
//                        semaphore.signal()
                        
                    } catch {
                        let dataResponse = requestData()
                        completion(dataResponse)
                        print("Error decoding: \(error)")
//                        semaphore.signal()
                        
                    }
                semaphore.signal()
                    
//                }
       
            }
            else {
                //_ = requestData()
                print("Status different 200: \(response)")
                semaphore.signal()
                
            }
        }.resume()
        
        
        semaphore.wait()
        
    }
    
    
    /// Función correspondiente a una solicitud "GET" funciona para obtener la lista de usuarios de la página 1
    func fetchData() {
        guard let url = URL(string: "https://reqres.in/api/users") else { return }
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
          
            guard let data = data, error == nil else { return }
            
            do {
                let information = try JSONDecoder().decode(page.self, from: data)
                let users = information.data
                self.allUsers = users
                
                for i in self.allUsers {
                    guard let url = URL(string: i.avatar!) else {
                        let us = onlineUsers(first_name: i.first_name, last_name: i.last_name, email: i.email, id: i.id, avatarImage: UIImage(systemName: "person")!)
                        webUtils.users.append(us)
                        continue }
                    
                    let data = try? Data(contentsOf: url)
                    let image = UIImage(data: data!)
                    let us = onlineUsers(first_name: i.first_name, last_name: i.last_name, email: i.email, id: i.id, avatarImage: image!)
                    webUtils.users.append(us)
                }
                
            }
            catch {
                print(error)
            }
            
            semaphore.signal()
        })
        
        task.resume()
        semaphore.wait()
        
    }
    
    
    /// Función para obtener la información de un usuario seleccionado, corresponde a una solicitud del tipo "GET"
    /// - Parameter userID: userID del usuario con el cual se hará la solicitud
    func fetchUser(_ userID: Int) -> user? {
        
        var finalUser: user!
        let semaphore = DispatchSemaphore(value: 0)
        guard let url = URL(string: "https://reqres.in/api/users/\(userID)") else { return nil }
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
          
            guard let data = data, error == nil else { return }
            
            do {
                let information = try JSONDecoder().decode(singleUser.self, from: data)
                
                self.single = information.data
                finalUser = information.data
                
            }
            catch {
                print(error)
            }
            
            semaphore.signal()
        })
        
        task.resume()
        semaphore.wait()
        
        return finalUser
        
    }
    
    
    
    
}
