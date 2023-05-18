//
//  Themes.swift
//  WorkTimer
//
//  Created by James Sun on 3/27/23.
//

import Foundation
import UIKit


struct Theme: Codable {
    var name: String
    var previewImage: String
    var price: Int
    
    var topBarColor: String
    var bodyColor: String

    var normalFont: String
    var titleFont: String
    var fancyFont: String
    var smallFont: String
}


class fileAccessor {
    var filePath: String
    var fileURL: URL?
    
    init(_ filePath: String) {
        self.filePath = filePath
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            self.fileURL = dir.appendingPathComponent(self.filePath)
        } else {
            print("Error establishing dir in fileAccessor.")
        }
    }
    
    func read() -> String {
        let fileString: String

        do {
            fileString = try String(contentsOf: self.fileURL!, encoding: .utf8)
        } catch {
            print(error)
            fileString = "ERROR GENERATED RETURN: fileAccessor.read()"
        }
        
        return fileString
    }
    
    func write(_ text: String) {
        do {
            try text.write(to: self.fileURL!, atomically: false, encoding: .utf8)
        } catch {
            print(error)
        }
    }
}


class ThemeManager {
    /*
     My teacher said that I shouldn't just have getThemes() lying around acting as a global function, so I'll put it in a class...
     */
    static func getThemes() -> [Theme] {
        // Get JSON String
        guard let themeFilePath = Bundle.main.url(forResource: "themes", withExtension: "json"),
              let themeData = FileManager.default.contents(atPath: themeFilePath.path) else
        {
            print("ThemeFilePath Error. Aborting.")
            exit(1)
        }
        let decoderRing = JSONDecoder()
        do {
            let themes = try decoderRing.decode([Theme].self, from: themeData)
            return themes
        } catch {
            print(error)
            exit(1)
        }
    }
}

/*
 Objects for theming view controllers. View controllers that want the current theme to be applied to them must adhere to the `Themed` protocol.
 
 Use the ThemeApplier class to apply themes
 */

protocol Themed {
    var topBar: UIView! { get set }
    var body: UIView! { get set }

    var normalText: Array<UILabel> { get set }
    var titleText: Array<UILabel> { get set }
    var fancyText: Array<UILabel> { get set }
    var smallText: Array<UILabel> { get set }
}


class ThemeApplier {
    
    private static func setLabelFonts(arr: Array<UILabel>, font: UIFont) {
        /*
         Short helper function. Applies a theme to every label in a list of them.
         I could use some sort of map function (they have that in Python, so they probably have that here), but I don't want to raise complications that i could avoid by just making a simple function myself.
         */
        for label in arr {
            label.font = font
        }
    }
    
    static func applyTheme(viewController: Themed) {
        /*
         Where all the magic happens.
         Applies the current global theme to a given View Controller (must adhere to the `Themed` protocol.
         */
        var theme: Theme
        if SharedData.shared.currentUser == nil {
            theme = SharedData.shared.themes![0]
        } else {
            theme = SharedData.shared.themes![SharedData.shared.currentUser!.currentThemeIndex]
        }

        let normalFontSize = 31.0
        let titleFontSize = 37.0
        let fancyFontSize = 33.0
        let smallFontSize = 17.0
        
        var normalFont = UIFont.systemFont(ofSize: normalFontSize)
        var titleFont = UIFont.systemFont(ofSize: titleFontSize)
        var fancyFont = UIFont.systemFont(ofSize: fancyFontSize)
        var smallFont = UIFont.systemFont(ofSize: smallFontSize)
        if (theme.normalFont != "System") {
            normalFont = UIFont(name: theme.normalFont, size: normalFontSize)!
        }
        if (theme.titleFont != "System") {
            titleFont = UIFont(name: theme.titleFont, size: titleFontSize)!
        }
        if (theme.fancyFont != "System") {
            fancyFont = UIFont(name: theme.fancyFont, size: fancyFontSize)!
        }
        if (theme.smallFont != "System") {
            smallFont = UIFont(name: theme.smallFont, size: smallFontSize)!
        }

        viewController.topBar.backgroundColor = UIColor(hexString: theme.topBarColor)
        viewController.body.backgroundColor = UIColor(hexString: theme.bodyColor)
    
        ThemeApplier.setLabelFonts(arr: viewController.normalText, font: normalFont)
        ThemeApplier.setLabelFonts(arr: viewController.titleText, font: titleFont)
        ThemeApplier.setLabelFonts(arr: viewController.fancyText, font: fancyFont)
        ThemeApplier.setLabelFonts(arr: viewController.smallText, font: smallFont)
    }
}
