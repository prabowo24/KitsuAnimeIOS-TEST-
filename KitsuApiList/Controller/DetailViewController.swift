//
//  DetailViewController.swift
//  KitsuApiList
//
//  Created by Admin on 1/23/19.
//  Copyright © 2019 Patranto Prabowo. All rights reserved.
//

import UIKit

class DetailViewController : UIViewController{
    
    @IBOutlet var coverImage:UIImageView!
    @IBOutlet var posterImage:UIImageView!
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var subTitleLabel:UILabel!
    @IBOutlet var popularityLabel:UILabel!
    @IBOutlet var statusLabel:UILabel!
    @IBOutlet var ageRestrictionLabel:UILabel!
    @IBOutlet var descriptionText:UITextView!
    @IBOutlet var episodeLabel:UILabel!
    
    var animeModel:AnimeModel?
    
    
    override func viewDidLoad() {
        
        if animeModel != nil{
            
            let popularity:String = "\(animeModel?.popularity ?? 0)"
            let episode:String = "\(animeModel?.episode ?? 0)"
            
            coverImage.imageFromURL(urlString: (animeModel?.coverImage)!, imageError: UIImage(named: "notofound")!)
            posterImage.imageFromURL(urlString: (animeModel?.imageUrl)!, imageError: UIImage(named: "poster_notfound")!)
            titleLabel.text = animeModel?.title
            subTitleLabel.text = animeModel?.subTitle
            popularityLabel.text = "Popularity : " + popularity
            statusLabel.text = animeModel?.statusShow
            ageRestrictionLabel.text = animeModel?.ageRating
            descriptionText.text = animeModel?.description
            episodeLabel.text = "Episode " + episode
            
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        
    }
    
}
