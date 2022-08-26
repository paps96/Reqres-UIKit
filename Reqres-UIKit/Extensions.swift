//
//  Extensions.swift
//  Reqres-UIKit
//
//  Created by Pedro Alberto Parra Solis on 23/08/22.
//

import Foundation
import UIKit

extension UITextField {
    func setPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}


extension Array where Iterator.Element == user {
    func convertIntoOnlineUser() -> [onlineUsers] {
        let mapOnlineUsers = self.map { onlineUsers.init(first_name: $0.first_name, last_name: $0.last_name, email: $0.email, id: $0.id, avatarImage: nil) }
        return mapOnlineUsers
    }
}

extension onlineUsers {
    func convertToUser() -> user {
        let a = user(id: self.id, email: self.email, first_name: self.first_name, last_name: self.last_name, avatar: nil)
        return a
    }
}
    

