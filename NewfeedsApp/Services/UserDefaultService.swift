//
//  UserDefaultService.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 09/06/2023.
//

import Foundation


class UserDefaultsService {
    /**
     Declare an instance of class
     */
    static var shared = UserDefaultsService()
    
    /**
     Dat ten bien
     */
    private var standard = UserDefaults.standard
    
    private enum Keys: String {
        case kCompletedTutorial
    }
    /**
     Prevent declare second instance of class from outside
     */
    private init() {
    }
    
    /**
     completedTutorial check xem user da hoan thanh tutorial hay chua
     
     KVO - Key value observer
     */
    
    var completedTutorial: Bool {
        /**
         get la khi lay ra gia tri cua bien bang UserDefaultService.shared.conpletedTutorial
         */
        get {
            return standard.bool(forKey: Keys.kCompletedTutorial.rawValue)
        }
        /**
         Hàm set được gọi khi gán giá trị cho biến UserDefaultsService.shared.completedTutorial = true
         */
        set {
            standard.set(newValue, forKey: Keys.kCompletedTutorial.rawValue)
            standard.synchronize()
        }
    }
    
    func clearAll() {
        standard.removeObject(forKey: Keys.kCompletedTutorial.rawValue)
    }
    
}
