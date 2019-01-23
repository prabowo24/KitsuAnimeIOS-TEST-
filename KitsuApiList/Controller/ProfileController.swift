//
//  LoginController.swift
//  KitsuApiList
//
//  Created by bowo on 23/01/19.
//  Copyright © 2019 Patranto Prabowo. All rights reserved.
//

import UIKit

class ProfileController : UIViewController{
    
    @IBOutlet var avatarImage:UIImageView!
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var emailLabel:UILabel!
    @IBOutlet var bodLabelText:UILabel!
    @IBOutlet var bodLabel:UILabel!
    @IBOutlet var genderLabelText:UILabel!
    @IBOutlet var genderLabel:UILabel!
    @IBOutlet var bioLabelText:UILabel!
    @IBOutlet var bioText:UITextView!
    @IBOutlet var buttonLogin:UIButton!
    
    var userApi:UserApi = UserApi()
    
    //recheck if come again
    override func viewWillAppear(_ animated: Bool) {
        
        if SettingHelper.hasKey(SettingHelper.KEY_TOKEN){
            fetchUser()
            
        }else{
            hideElement()
        }
        
    }
    
    //check the auth user
    override func viewDidLoad() {
        
        if SettingHelper.hasKey(SettingHelper.KEY_TOKEN){
            fetchUser()
            
        }else{
            hideElement()
        }
        
        buttonLogin.addTarget(self, action: #selector(ProfileController.onLogin(_:)), for: .touchUpInside)
        
    }
    
    //go to login page
    @objc func onLogin(_ sender : UIButton!){
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let loginController = storyboard.instantiateViewController(withIdentifier: "LoginController") as! OauthController
        
        navigationController?.pushViewController(loginController, animated: true)
    }
    
    //get user self
    func fetchUser(){
        let token:String = SettingHelper.getValue(key: SettingHelper.KEY_TOKEN)!
        let spinner = UIViewController.displaySpinner(onView: self.view)
        
        userApi.getUser(token: token) { (userModel) in
            UIViewController.removeSpinner(spinner: spinner)
            
            if userModel != nil{
                
                self.avatarImage.imageFromURL(urlString: (userModel?.avatar)!, imageError: UIImage(named:"poster_notfound")!)
                self.nameLabel.text = userModel?.name
                self.bodLabelText.text = userModel?.birthDay
                self.genderLabelText.text = userModel?.gender
                self.bioText.text = userModel?.about
                self.emailLabel.text = userModel?.email
                
                self.showElement()
            }else{
                self.hideElement()
            }
            
            
        }
    }
    
    //hide profile until login
    func hideElement(){
        avatarImage.isHidden = true
        nameLabel.isHidden = true
        bodLabel.isHidden = true
        bodLabelText.isHidden = true
        genderLabelText.isHidden = true
        genderLabel.isHidden = true
        bioLabelText.isHidden = true
        bioText.isHidden = true
        buttonLogin.isHidden = false
        emailLabel.text = "Please login to see your profile."
    }
    
    //show profile
    func showElement(){
        avatarImage.isHidden = false
        nameLabel.isHidden = false
        bodLabel.isHidden = false
        bodLabelText.isHidden = false
        genderLabelText.isHidden = false
        genderLabel.isHidden = false
        bioLabelText.isHidden = false
        bioText.isHidden = false
        buttonLogin.isHidden = true
        emailLabel.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
}
