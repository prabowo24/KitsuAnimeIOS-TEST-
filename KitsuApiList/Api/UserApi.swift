//
//  UserApi.swift
//  KitsuApiList
//
//  Created by bowo on 23/01/19.
//  Copyright © 2019 Patranto Prabowo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserApi{
    private let baseUrl = Config.url
    private var token:String = ""
    
    private func execute(data:Any) -> UserModel?{
        
        let json = JSON(data)
        
        if json["data"].count > 0 {
            for(_, item) in json["data"]{
                let attr = item["attributes"]
                
                 let user = UserModel(
                    name:attr["name"].string ?? "",
                    birthDay:attr["birthday"].string ?? "",
                    email:attr["email"].string ?? "",
                    about:attr["about"].string ?? "",
                    avatar:attr["avatar"]["small"].string ?? "",
                    gender:attr["gender"].string ?? ""
                )
                return user
            }
            return nil
        }
        return nil
        
    }
    
    public func oauth(email:String, password:String, completion:@escaping (OauthToken?) -> Void){
        
        guard let url = URL(string:baseUrl + "/api/oauth/token") else{
            completion(nil)
            return
        }
        
        Alamofire.request(url, method:.post, parameters:
            [
                "username":email,
                "password":password,
                "grant_type":"password"
            ])
        .validate()
            .responseJSON{ (responseData) -> Void in
                if let val = responseData.result.value{
                    print(val)
                    let json = JSON(val)
                    
                    let token = OauthToken(
                        access_token: json["access_token"].string ?? "",
                        refresh_token: json["refresh_token"].string ?? "",
                        token_type: json["token_type"].string ?? ""
                    )
                    
                    completion(token)
                    
                }else{
                    completion(nil)
                }
                
        }
        
        
    }
    
    public func	getUser(token:String, completion:@escaping (UserModel?) -> Void){
        
        if token.isEmpty{
            completion(nil)
            return
        }
        
        let headers:HTTPHeaders = [
            "Authorization":"Bearer " + token
        ]
        
        let url = baseUrl + "/api/edge/users?filter[self]=true"
        
        
        
        Alamofire.request(url, headers:headers)
        .validate()
            .responseJSON{ (responseData) -> Void in
                if responseData.result.value != nil{
                    
                    print(responseData.result.value)
                    let collection = self.execute(data: responseData.result.value!)
                    
                    completion(collection)
                }else{
                    completion(nil)
                }
         }
        return;
    }
    
    
}
