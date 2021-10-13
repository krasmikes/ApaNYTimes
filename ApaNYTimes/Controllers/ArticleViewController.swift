//
//  ArticleViewController.swift
//  ApaNYTimes
//
//  Created by Apanasenko Mikhail on 11.10.2021.
//

import UIKit
import WebKit

class ArticleViewController: UIViewController {
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleAuthor: UILabel!
    @IBOutlet weak var articleDate: UILabel!
    @IBOutlet weak var articlePicture: UIImageView!
    @IBOutlet weak var articlePictureCopyright: UILabel!
    @IBOutlet weak var articlePictureCaption: UILabel!
    @IBOutlet weak var articleText: UITextView!
    
    private let pictureFormat: String = "superJumbo"
    
    var index: Int?
    var model: NewsModel?
    var manager: NewsManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let index = index {
            if let article = model?.data.results[index] {
                articleTitle.text = article.title
                articleAuthor.text = article.byline
                articleDate.text = article.published_date
                articleText.text = article.abstract
                if let rawImageData = article.bigPicture {
                    DispatchQueue.main.async {
                        self.articlePicture.image = UIImage(data: rawImageData)
                    }
                } else {
                    if let manager = manager {
                        manager.loadPicture(for: article, format: pictureFormat) { rawImageData, _, _ in
                            if let safeData = rawImageData {
                                self.model?.data.results[index]?.bigPicture = safeData
                                manager.saveData(for: self.model!)
                                
                                DispatchQueue.main.async {
                                    self.articlePicture.image = UIImage(data: safeData)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sourceButtonPressed(_ sender: UIButton) {
        if let index = index {
            if let article = model?.data.results[index] {
                if let url = URL(string: article.url) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}

