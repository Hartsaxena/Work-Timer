//
//  SharedData.swift
//  WorkTimer
//
//  Created by James Sun on 1/19/23.
//

import Foundation


class SharedData {
    static let shared = SharedData()
    
    var timerStartSeconds: Int = 0
    var currentUser: User?
    var doNotResegue = false
    var quoteAPIFetched = false
    var themes: [Theme]?
    
    func saveUserProfile() {
        do {
            let data = try JSONEncoder().encode(self.currentUser)
            UserDefaults.standard.set(data, forKey: "UserProfile")
            print("Saved User Profile")
        } catch let error {
            print("Error encoding: \(error)")
        }
    }
    func loadUserProfile() -> Bool {
        do {
            if let data = UserDefaults.standard.data(forKey: "UserProfile") {
                self.currentUser = try JSONDecoder().decode(User.self, from: data)
                print("Successfully decoded saved user profile.")
            } else {
                // I honestly don't know why the purpose of making a custom error and throwing it here, but I'm too tired to deal with it.
                throw UserDefaultDecodingError.noDataInKey(msg: "Couldn't find data for key \"UserProfile\"")
            }
        } catch {
            print(error)
            return false
        }
        
        print("Loaded User Profile")
        return true
    }
}
