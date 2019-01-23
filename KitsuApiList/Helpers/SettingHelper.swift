//
//  SettingHelper.swift
//  KitsuApiList
//
//  Created by bowo on 24/01/19.
//  Copyright © 2019 Patranto Prabowo. All rights reserved.
//

import Foundation
class SettingHelper{
    
    public static let KEY_TOKEN:String = "key_token"
    
    public init(){
        
    }
    
    
    public static func addValue(key:String, value:String){
        let defaults = UserDefaults.standard
        
        defaults.set(value, forKey: key)
    }
    
    public static func getValue(key:String) -> String?{
        let defaults = UserDefaults.standard
        if let data  = defaults.string(forKey: key){
            print("VALUE " + data)
            return data
        }
        
        return nil
    }
    
    public static func clear(){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: self.KEY_TOKEN)
    }
    
    public static func hasKey(_ key:String) -> Bool{
        
        if self.getValue(key: key) != nil{
            return true
        }
        
        return false
    }
}
