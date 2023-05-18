//
//  ProfileScene.swift
//  WorkTimer
//
//  Created by James Sun on 10/28/22.
//

import UIKit


enum UserDefaultDecodingError: Error {
    case noDataInKey(msg: String)

    // Throw in all other cases
    case unexpected(code: Int)
}


class ProfileScene: UIViewController, Themed {
    
    // `Themed` protocol stubs + object references (for `Themed` protocol)
    var topBar: UIView!
    var body: UIView!
    var normalText: Array<UILabel> = []
    var titleText: Array<UILabel> = []
    var fancyText: Array<UILabel> = []
    var smallText: Array<UILabel> = []
    @IBOutlet weak var topBarOutlet: UIView!
    @IBOutlet var bodyOutlet: UIView!
    @IBOutlet weak var titleOutlet: UILabel!
    
    @IBOutlet weak var setupProfileStack: UIStackView!
    @IBOutlet weak var profileStack: UIStackView!

    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileFocusPoints: UILabel!
    @IBOutlet weak var profileStudyMinutes: UILabel!
    @IBOutlet weak var profileDailyStudyMinutes: UILabel!
    
    var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.topBar = topBarOutlet
        self.body = bodyOutlet
        
        self.normalText += [titleOutlet, profileNameLabel]
        self.smallText += [profileFocusPoints, profileStudyMinutes, profileDailyStudyMinutes]
        
        ThemeApplier.applyTheme(viewController: self)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if SharedData.shared.loadUserProfile() {
            self.currentUser = SharedData.shared.currentUser
            self.setupProfileStack.isHidden = true
            self.profileStack.isHidden = false
            self.updateProfileStack(profile: self.currentUser!)
        } else {
            print("Error loading User Profile - Revealing \"Setup profile\" view.")
            self.setupProfileStack.isHidden = false
            self.profileStack.isHidden = true
        }
    }
    
    
    func updateProfileStack(profile: User) {
        self.profileNameLabel.text = "\(profile.name)"
        self.profileFocusPoints.text = "Focus points: \(profile.focusPoints)"
        self.profileStudyMinutes.text = "Total minutes studied: \(profile.studyMinutes)"
    }
    
}
