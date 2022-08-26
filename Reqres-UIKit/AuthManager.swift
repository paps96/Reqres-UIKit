//
//  AuthManager.swift
//  Reqres-UIKit
//
//  Created by Pedro Alberto Parra Solis on 23/08/22.
//

import Foundation
import Combine

final class AuthManager {
    
    static let shared = AuthManager()
    
    private init() {}
    
    var isSignedIn: Bool {
        var sign: Bool {
            guard accesToken != nil &&  accesToken != "" else { return false }
            return true
        }
        
        return sign
    }
    
    var succesfulRegistry: Bool {
        var sign: Bool {
            guard temporalToken != nil || temporalToken != "" else { return false }
            return true
        }
        return sign
    }
    
    private var temporalToken: String? {
        return UserDefaults.standard.string(forKey: "temporal_token")
    }
    
    public func setTemporalToken(_ token: String) {
        UserDefaults.standard.setValue(token, forKey: "temporal_token")
    }
    
    
    private var accesToken: String? {
        return UserDefaults.standard.string(forKey: "acces_token")
    }
    
    private func cacheToken(result: String) {
        UserDefaults.standard.setValue(result, forKey: "acces_token")
    }
    
    public func setAccesToken(_ token: String) {
        cacheToken(result: token)
    }
    
    public func deleteToken() {
        UserDefaults.standard.setValue(nil, forKey: "acces_token")
    }
    
    
    
}
