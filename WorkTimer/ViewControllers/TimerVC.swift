//
//  Timer.swift
//  WorkTimer
//
//  Created by James Sun on 12/1/22.
//

import UIKit


class MyTimer: UIViewController, Themed {
    
    // `Themed` protocol stubs + object references (for `Themed` protocol)
    var topBar: UIView! = UIView() // There is no top bar in TimerVC
    var body: UIView!
    var normalText: Array<UILabel> = []
    var titleText: Array<UILabel> = []
    var fancyText: Array<UILabel> = []
    var smallText: Array<UILabel> = []
    @IBOutlet var bodyOutlet: UIView!
    
    
    var currentTime = 0
    var timePassed = 0
    var paused = true

    @IBOutlet weak var playButton: UIImageView!
    @IBOutlet weak var pauseButton: UIImageView!
    @IBOutlet weak var topTime: UILabel!
    @IBOutlet weak var bottomTime: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let startSeconds = SharedData.shared.timerStartSeconds
        
        print("Successfully decoded timer starting time: \(startSeconds) seconds.")
        self.currentTime = Int(startSeconds)

        self.updateViewTime()
        paused = false
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {timer in
            if (!self.paused) {
                self.currentTime -= 1
                self.timePassed += 1
                if self.currentTime == 0 {
                    timer.invalidate()
                }
                self.updateViewTime()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.body = bodyOutlet
        
        ThemeApplier.applyTheme(viewController: self)
    }
    
    
    func updateViewTime() {
        let newTime = calculateDisplayTimes(self.currentTime)
        let minutes = newTime[0]
        let seconds = newTime[1]
        
        self.topTime.text = String(format: "%02d", minutes)
        self.bottomTime.text = String(format: "%02d", seconds)
    }
    
    
    func calculateDisplayTimes(_ seconds: Int) -> [Int] {
        var time: [Int]
        if (seconds >= 3600) {
            let hours: Int = Int(floor(Double(seconds / 60)))
            let remainingMinutes: Int = seconds - (hours * 60)
            time = [hours, remainingMinutes]
        } else {
            let minutes: Int = Int(floor(Double(seconds / 60)))
            let remainingSeconds: Int = seconds - (minutes * 60)
            time = [minutes, remainingSeconds]
        }

        return time
    }
    
    
    func saveTime() {
        let minutes = Int(floor(Double(self.timePassed) / 60))
        print("Minutes Saved: \(minutes)")
        
        if (SharedData.shared.currentUser != nil) {
            SharedData.shared.currentUser!.studyMinutes += minutes
            SharedData.shared.currentUser!.focusPoints += minutes
        }
    }


    @IBAction func togglePause(_ sender: Any) {
        playButton.isHidden = !playButton.isHidden
        pauseButton.isHidden = !pauseButton.isHidden
        paused = !paused
        
        self.saveTime()
        self.timePassed = 0
    }
    

    @IBAction func exitButton(_ sender: Any) {
        self.saveTime()
        SharedData.shared.saveUserProfile()
        SharedData.shared.doNotResegue = true
        self.dismiss(animated: true)
    }
}
