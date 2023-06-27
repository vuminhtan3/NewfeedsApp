//
//  AuthService.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 09/06/2023.
//

import Foundation
import KeychainSwift

class AuthService {
    static var share = AuthService()
    private var keychain: KeychainSwift
    
    private enum Keys: String {
        case kAccessToken
        case kRefreshToken
    }
    
    private init() {
        keychain = KeychainSwift()
    }
    
    var accessToken: String {
        get {
            return keychain.get(Keys.kAccessToken.rawValue) ?? ""
        }
        set {
            if newValue.isEmpty {
                keychain.delete(Keys.kAccessToken.rawValue)
            } else {
                keychain.set(newValue, forKey: Keys.kAccessToken.rawValue)
            }
        }
    }
    
    var refreshToken: String {
        get {
            return keychain.get(Keys.kRefreshToken.rawValue) ?? ""
        }
        set {
            if newValue.isEmpty {
                keychain.delete(Keys.kRefreshToken.rawValue)
            } else {
                keychain.set(newValue, forKey: Keys.kRefreshToken.rawValue)
            }
        }
    }
    
    /**
     Check login state
     */
    var isLoggedIn: Bool {
        return !accessToken.isEmpty
    }
    
    func clearAll() {
//        keychain.delete(Keys.kAccessToken.rawValue)
        
        accessToken = ""
    }
}
