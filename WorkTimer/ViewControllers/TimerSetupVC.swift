//
//  TimerSetupScene.swift
//  WorkTimer
//
//  Created by James Sun on 11/14/22.
//

import UIKit

class TimerSetupScene: UIViewController, Themed {

    // `Themed` protocol stubs + object references (for `Themed` protocol)
    var topBar: UIView!
    var body: UIView!
    var normalText: Array<UILabel> = []
    var titleText: Array<UILabel> = []
    var fancyText: Array<UILabel> = []
    var smallText: Array<UILabel> = []
    @IBOutlet weak var topBarOutlet: UIView!
    @IBOutlet var bodyOutlet: UIView!
    
    @IBOutlet weak var timeSelector: UIDatePicker!
    @IBOutlet weak var setupProfileWarning: UILabel!
    
    var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            if let data = UserDefaults.standard.data(forKey: "UserProfile") {
                self.currentUser = try JSONDecoder().decode(User.self, from: data)
                SharedData.shared.currentUser = self.currentUser
                print("Successfully decoded saved user profile.")
                saveTime(seconds: self.currentUser!.studySessionLength)
                setupProfileWarning.isHidden = false
            } else {
                print("No data under key UserProfile.")
                setupProfileWarning.isHidden = true
                
            }
        } catch let error {
            print("Error decoding: \(error) - Revealing \"Setup profile\" view.")
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.topBar = topBarOutlet
        self.body = bodyOutlet
        
        ThemeApplier.applyTheme(viewController: self)
    }
    

    override func viewDidAppear(_ animated: Bool) {
        if (currentUser != nil) {
            if (!SharedData.shared.doNotResegue) {
                performSegue(withIdentifier: "TimerSegue", sender: self)
            } else {
                SharedData.shared.doNotResegue = false
            }
        }
    }
    
    
    @IBAction func startTimer(_ sender: Any) {
        let selectedSeconds = Int(timeSelector.countDownDuration)
        self.saveTime(seconds: selectedSeconds)
        performSegue(withIdentifier: "TimerSegue", sender: self)
    }
    
    
    func saveTime(seconds: Int) {
        SharedData.shared.timerStartSeconds = seconds
        print("Successfully encoded timer starting time: \(seconds) seconds.")
    }

}
