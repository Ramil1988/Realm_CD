//
//  UserSettings.swift
//  Homework 14
//
//  Created by Ramil Sharapov on 13.06.2021.
//

import Foundation


final class UserSettings {
    
    private enum UsersKeys: String {
        case userName
        case userSurname
    }
    
    static var userName: String! {
        get {
            return UserDefaults.standard.string(forKey: UsersKeys.userName.rawValue)
            
        } set { // прописываем то, что должно происходить, когда будет присваиваться новое значени
            let defaults = UserDefaults.standard
            let key = UsersKeys.userName.rawValue
            guard let name = newValue else { return defaults.removeObject(forKey: key) }
            defaults.set(name, forKey: key)
            print("value: \(name) was added for key \(key)")
            
        }
    }
    
    static var userSurname: String! {
        get {
            return UserDefaults.standard.string(forKey: UsersKeys.userSurname.rawValue)
            
        } set { // прописываем то, что должно происходить, когда будет присваиваться новое значени
            let defaults = UserDefaults.standard
            let key = UsersKeys.userSurname.rawValue
            guard let surname = newValue else { return defaults.removeObject(forKey: key) }
            defaults.set(surname, forKey: key)
            print("value: \(surname) was added for key \(key)")
        }
    }
}
