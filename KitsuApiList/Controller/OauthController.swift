//
//  OauthController.swift
//  KitsuApiList
//
//  Created by bowo on 24/01/19.
//  Copyright © 2019 Patranto Prabowo. All rights reserved.
//

import UIKit


class OauthController: UIViewController{
    
    @IBOutlet var emailField:UITextField!
    @IBOutlet var passwordField:UITextField!
    @IBOutlet var loginButton:UIButton!
    var userApi:UserApi = UserApi()
    
    @objc func login(_ sender:UIButton!){
        
        if (emailField.text?.isEmpty)!{
            showAlert("Error", "Email can't empty!")
            return
        }
        
        if (passwordField.text?.isEmpty)!{
            showAlert("Error", "Password can't empty!")
            return
        }
        
        let spinner = UIViewController.displaySpinner(onView: self.view)
        
        userApi.oauth(email: emailField.text!, password: passwordField.text!) { (token) in
            
            UIViewController.removeSpinner(spinner: spinner)
            
            if token != nil{
                
                SettingHelper.addValue(key: SettingHelper.KEY_TOKEN, value: (token?.access_token)!)
                
                print("TOKEN OAUTH " + (token?.access_token)!)
                
                self.showAlert("Succes", "Login Successfully")
                
                self.navigationController?.popViewController(animated: true)
                
            }else{
                self.showAlert("Error", "Login Failed, please check your credential")
            }
            
        }
        
        
        
        
    }
    
    //show alert message
    func showAlert(_ title:String,_ message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        loginButton.addTarget(self, action: #selector(OauthController.login(_:)), for: .touchUpInside)
        
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
}
