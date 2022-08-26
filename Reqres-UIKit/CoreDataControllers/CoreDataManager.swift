//
//  CoreDataManager.swift
//  Reqres-UIKit
//
//  Created by Pedro Alberto Parra Solis on 24/08/22.
//

import Foundation
import CoreData

class CoreDataManager {
    
    let container: NSPersistentContainer
    static var shared: CoreDataManager = CoreDataManager()
    
    private var searchedUsers: [Usuarios] = []
    var searchedFinal: [user] = []
    private var usersID: [Int] = []
    
    init() {
        container = NSPersistentContainer(name: "Usuarios")
        container.loadPersistentStores {(description, error) in
            if error != nil {
                print("Error loading container")
            }
        }
        fetchUsers()
    }
    
    private func fetchUsers() {
        let request = NSFetchRequest<Usuarios>(entityName: "Usuarios")
        do {
            
            searchedUsers.removeAll()
            usersID.removeAll()
            self.searchedFinal.removeAll()
            
            try searchedUsers = container.viewContext.fetch(request)
            usersID = searchedUsers.map { Int($0.id) }
            self.searchedFinal = searchedUsers.map { user.init(id: Int($0.id), email: $0.email!, first_name: $0.first_name!, last_name: $0.last_name!, avatar: "") }
        } catch let error {
            print(error)
        }
    }
    
    /// Función que guarda en la base de datos todas las entidades creadas antes de invocar esta función
    private func saveUsers() {
        do {
            try container.viewContext.save()
            fetchUsers()
        } catch let error {
            print("Error in save Data \(error)")
        }
        return
    }
    
    /// Función que controla si un usuario ya ha sido registrado con aterioridad, en caso de que no crea una entidad que se guardará
    /// - Parameter user: Toda la información necesaria para guardar la nueva entidad
    func saveSearch(user: user) {
        
        guard !usersID.contains(user.id) else {
            return
        }
        
        let newSearch = Usuarios(context: container.viewContext)
        newSearch.id = Int32(user.id)
        newSearch.email = user.email
        newSearch.first_name = user.first_name
        newSearch.last_name = user.last_name
        newSearch.avatar = user.avatar
        saveUsers()
    }
}
