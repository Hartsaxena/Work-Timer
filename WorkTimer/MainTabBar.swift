//
//  MainTabBar.swift
//  WorkTimer
//
//  Created by James Sun on 5/17/23.
//

import UIKit

class MainTabBar: UITabBarController {

    override func viewDidLoad() {
        /*
         Because this tab bar controller manages the entire program, the viewDidLoad method is basically one of the first things that's run.
         I'm taking advantage of this fact and putting a bunch of setting up here.
         */
        super.viewDidLoad()

        // import themes
        SharedData.shared.themes = ThemeManager.getThemes()
        _ = SharedData.shared.loadUserProfile()
    }

}
