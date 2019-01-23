//
//  AnimeApi.swift
//  KitsuApiList
//
//  Created by Admin on 1/23/19.
//  Copyright © 2019 Patranto Prabowo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AnimeApi{
    
    private let baseUrl = Config.url
    private var nextUrl:String = ""
    
    private func execute(data:Any) -> [AnimeModel]{
        var collection:[AnimeModel] = []
        
        let json = JSON(data)
        
        self.nextUrl = json["links"]["next"].string ?? ""
        
        for (_, item) in json["data"]{
            
            let animeModel = AnimeModel(
                title:item["attributes"]["canonicalTitle"].string!,
                subTitle:item["attributes"]["showType"].string!,
                description:item["attributes"]["synopsis"].string ?? "No Description Available",
                imageUrl:item["attributes"]["posterImage"]["small"].string ?? "",
                rating:item["attributes"]["ageRating"].string ?? "No Rating",
                coverImage:item["attributes"]["coverImage"]["small"].string ?? "",
                episode:item["attributes"]["episodeCount"].intValue ,
                ageRating:item["attributes"]["ageRatingGuide"].string ?? "",
                popularity:item["attributes"]["popularityRank"].intValue ,
                statusShow:item["attributes"]["status"].string ?? ""
            )
            
            collection.append(animeModel)
            
        }
        
        return collection
        
    }
    
    public func getNext(completion:@escaping([AnimeModel]?) -> Void){
        
        if(nextUrl.isEmpty){
            completion(nil)
            return
        }
        
        guard let url = URL(string: nextUrl) else{
            completion(nil)
            return
        }
        
        Alamofire.request(url, method: .get)
            .validate()
            .responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil){
                    
                    let collection = self.execute(data: responseData.result.value!)
                    
                    completion(collection)
                    
                }else{
                    completion(nil)
                    
                }
        }
        return;
    }
    
    public func getAnimes(parameter:[String:String], completion: @escaping ([AnimeModel]?) -> Void){
        
        guard let url = URL(string: baseUrl + "/api/edge/anime") else{
            completion(nil)
            return
        }
        
        Alamofire.request(url, method: .get , parameters:parameter)
        .validate()
            .responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil){
                    
                    let collection = self.execute(data: responseData.result.value!)
                    
                    completion(collection)
                    
                }else{
                    completion(nil)
                    
                }
        }
        return;
        
    }
    
}
