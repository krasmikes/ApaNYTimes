//
//  NewsCell.swift
//  ApaNYTimes
//
//  Created by Apanasenko Mikhail on 11.10.2021.
//

import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellArticleTitle: UILabel!
    @IBOutlet weak var cellArticleAbstract: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellImageView.isHidden = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
