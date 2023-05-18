//
//  StoreCollectionViewCell.swift
//  WorkTimer
//
//  Created by James Sun on 3/24/23.
//

import UIKit

class StoreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
    
    var themeIndex: Int?
    
    
    @IBAction func buy(_ sender: Any) {
        if (SharedData.shared.currentUser == nil) {
            print("Guest user - no buying permissions granted")
            return
        }

        if (!SharedData.shared.currentUser!.unlockedThemes.contains(self.themeIndex!)) {
            // Check if theme has already been purchased
            let price = Int(priceLabel.text!)!
            if (SharedData.shared.currentUser!.focusPoints < price) {
                print("Not enough money to buy theme")
                return
            }
            SharedData.shared.currentUser!.focusPoints -= price
        } else {
            print("Theme is already purchased. Changing current theme to selected theme")
        }

        SharedData.shared.currentUser!.currentThemeIndex = self.themeIndex!
        SharedData.shared.currentUser!.unlockedThemes += [self.themeIndex!]
        SharedData.shared.saveUserProfile()
    }
}
