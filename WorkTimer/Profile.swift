//
//  Profile.swift
//  WorkTimer
//
//  Created by James Sun on 10/19/22.
//

import Foundation

class User: Codable {
    var name: String
    var studyMinutes: Int = 0
    var studySessionLength: Int
    var focusPoints: Int = 0
    
    var currentThemeIndex: Int = 0
    var unlockedThemes: [Int] = []
    
    
    init(name: String, studySessionLength: Int) {
        self.name = name
        self.studySessionLength = studySessionLength
    }
}
