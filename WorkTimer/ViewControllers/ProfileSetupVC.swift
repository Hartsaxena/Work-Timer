//
//  NewProfileVC.swift
//  WorkTimer
//
//  Created by James Sun on 10/19/22.
//

import UIKit

class ViewController: UIViewController {
    /*
     Doesn't really need to adhere to the `Themed` protocol because this VC should never even show itself if a different theme from "Default" is currently selected.
     This is because in order to change the current theme from "Default" would require a profile, which this VC creates. If there is already a profile, this VC won't show itself.
     */

    @IBOutlet weak var UsernameField: UITextField!
    @IBOutlet weak var StudySessionSpecifier: UIDatePicker!
    @IBOutlet weak var UsernameErrorLabel: UILabel!
    
    var CurrentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    func changeToMainScene() {
        self.dismiss(animated: true)
    }

    
    @IBAction func profileSave(_ sender: Any) {
        /*
         Save Profile button.
         Pretty self-explanatory. Saves the profile when the "Save Profile" button is pressed.
         Duh.
         What did you think it did? Idiot.
         Stop reading this. Get out of my sight.
         */
        guard let Username = UsernameField.text else {return} // Make errors
        if Username.trimmingCharacters(in: .whitespaces).count == 0 {
            UsernameErrorLabel.text = "Please fill in a Username."
            return
        }
        let StudySessionLength = Int(StudySessionSpecifier.countDownDuration)
        CurrentUser = User(name: Username, studySessionLength: StudySessionLength)
        SharedData.shared.currentUser = CurrentUser
        SharedData.shared.saveUserProfile()
        self.changeToMainScene()
    }
}

