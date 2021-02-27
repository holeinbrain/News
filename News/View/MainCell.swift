//
//  MainCell.swift
//  News
//
//  Created by Anton Levin on 26.02.2021.
//

import UIKit
import Kingfisher

class MainCell: UITableViewCell {
  @IBOutlet weak var titleTxt: UILabel!
  @IBOutlet weak var descriptionTxt: UILabel!
  @IBOutlet weak var articleImage: UIImageView!
  @IBOutlet weak var autorTxt: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    articleImage.layer.borderWidth = 0.3
    articleImage.layer.cornerRadius = 20
    self.layer.borderWidth = 0.3
    self.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3030237867)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func configure(article: Article) {
    titleTxt.text = article.title
    autorTxt.text = article.author
    descriptionTxt.text = article.description
    if let url = article.urlToImage {
      articleImage.kf.setImage(with: url)
        
      }
    }
  }
  

