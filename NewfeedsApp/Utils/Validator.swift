//
//  Validator.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 09/06/2023.
//

import Foundation
protocol Validator {
    func isValid() -> Bool
}

class UsernameValidator: Validator {
    var username: String!

    init(username: String) {
        self.username = username
    }

    func isValid() -> Bool {
        return username.count >= 4 || username.count <= 40
    }
}

class PasswordValidator: Validator {
    var password: String!
    

    init(password: String) {
        self.password = password
    }

    func isValid() -> Bool {
        return password.count >= 6 || password.count <= 40
    }
}
