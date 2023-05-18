//
//  HomeScene.swift
//  WorkTimer
//
//  Created by James Sun on 11/14/22.
//

import UIKit

class HomeScene: ViewController, Themed {
    /*
     Here, I declare @IBOutlet variables to link to the view controller objects.
     Then, I set the variables needed to conform to the `Themed` protocol.
     I know you're thinking "Oh lord this is a terrible idea," but I couldn't think of a better way to do this because for some reason @IBOutlet variables can't be declared in protocols.
     */
    @IBOutlet weak var topBarOutlet: UIView!
    @IBOutlet var bodyOutlet: UIView!
    @IBOutlet weak var storeViewOutlet: UIStackView!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var storeLabel: UILabel!
    
    var topBar: UIView!
    var body: UIView!
    var normalText: Array<UILabel> = []
    var titleText: Array<UILabel> = []
    var fancyText: Array<UILabel> = []
    var smallText: Array<UILabel> = []
    
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    var quotes: [APIResponse] = []
    var themes: [Theme]?

    @IBOutlet weak var storeCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        storeCollectionView.delegate = self
        storeCollectionView.dataSource = self
        Task { 
            self.quotes = await QuoteAPIService.getQuotes()
            DispatchQueue.main.async {
                self.newQuote()
                SharedData.shared.quoteAPIFetched = true
            }
        }
        
        self.themes = SharedData.shared.themes
        
        // Link outlets to `Themed` protocol conforming variables
        self.topBar = topBarOutlet
        self.body = bodyOutlet
        self.normalText += [storeLabel]
        self.titleText += [homeLabel]
        self.fancyText += [quoteLabel, authorLabel]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ThemeApplier.applyTheme(viewController: self)
        
        if (SharedData.shared.quoteAPIFetched) {
            self.newQuote()
        }
    }
    
    
    func newQuote() {
        /*
         Randomly generate a new inspiration quote every time the view reappears
         */
        let randomIndex = Int.random(in: 0..<Int(quotes.count))
        let randomResponse = quotes[randomIndex]
        quoteLabel.text = randomResponse.q
        authorLabel.text = randomResponse.a
    }
}
extension HomeScene: UICollectionViewDelegate, UICollectionViewDataSource {
    /*
     Extension to conform to UICollectionView
     */
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return themes!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreCell", for: indexPath) as? StoreCollectionViewCell else {
            print("PROBLEM GETTING CELL. ABORTING.")
            return UICollectionViewCell()
        }
        cell.themeIndex = indexPath.row
        
        let theme = self.themes![indexPath.row]
        var imageUrlPath = theme.previewImage
        if (imageUrlPath == "") {
            print("No previewImage found. Using default image.")
            imageUrlPath = "departure"
        }
        let unscaledImage = UIImage(named: imageUrlPath)
        let image = self.resizeImage(image: unscaledImage!, width: 128.0, height: 128.0);
        cell.priceLabel.text = String(theme.price)
        // Assign preview image to filepath
        cell.previewImage.image = image
        
        return cell
    }
    
    private func resizeImage(image: UIImage, width: Float, height: Float) -> UIImage? {
        /*
         Function for resizing an image to a given width and height.
         Took me years to figure out.
         */
        let targetSize = CGSizeMake(CGFloat(width), CGFloat(height))
        let size = image.size
        
        let widthRatio = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if (widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
