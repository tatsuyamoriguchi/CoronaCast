//
//  NewsViewController.swift
//  CoronaCast
//
//  Created by Tatsuya Moriguchi on 7/30/20.
//  Copyright © 2020 Tatsuya Moriguchi. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, UITextViewDelegate {

    var selectedCountry: String?
    var newsTitle: String?
    var excerpt: String?
    var heat: Int?
    var webUrl: String?
    var publishedDateTime: String?
    var providerName: String?
    var images: [Image]?
    
    @IBOutlet weak var selectedCountryLabel: UILabel!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var heatLabel: UILabel!
    @IBOutlet weak var providerNameLabel: UILabel!
    @IBOutlet weak var excerptTextView: UITextView!
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageTitle: UILabel!
    
    
    @IBAction func backToNewsFeedButton(_ sender: Any) {

        performSegue(withIdentifier: "unwindToNewsFeed", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        selectedCountryLabel.text = selectedCountry

        newsTitleLabel.text = newsTitle
        if let heatValue = heat {
            let heatValueString = String(heatValue)
            heatLabel.text = "News AI Rate: " + heatValueString
        }
        if let providerNameString = providerName, let publishedDateTimeString = publishedDateTime {
            providerNameLabel.text = providerNameString + " @ " + publishedDateTimeString
        }
        
        // if wehUrl is available, use it to embed to text
        if let webUrlString = webUrl {
            let sourceString = "Link to news source"
            let attributedString = NSMutableAttributedString(string: sourceString)
            attributedString.addAttribute(.link, value: webUrlString as Any, range: (sourceString as NSString).range(of: sourceString))
            excerptTextView.attributedText = attributedString
            excerptTextView.font = UIFont(name: "Avenir Next", size: 18)

        }
        
        // If excerpt, it is displayed with link. If ecerpt is nil, "Linke to news source" is displayed, instead.
        if let excerptString = excerpt {
            excerptTextView.text = excerptString
        }
        
        
        
        if let imagesArray = images {
            var num = 1
            for image in imagesArray {
                
                if num == 1 {
                    if let urlString = image.url {
                        
                        let url = URL(string: urlString)
                        
                        UIImage.loadFrom(url: url!) { image in
                            self.imageView.image = image
                        }
                    }
                    
                    imageTitle.text = image.title
                }
                num += 1
                
            }
        }
}
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
          UIApplication.shared.open(URL)
          return false
      }
    
}

extension UIImage {

    public static func loadFrom(url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }

}

