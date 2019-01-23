//
//  ViewController.swift
//  KitsuApiList
//
//  Created by Admin on 1/23/19.
//  Copyright © 2019 Patranto Prabowo. All rights reserved.
//

import UIKit
import SwiftyJSON

class RootViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    var dataAnime:[AnimeModel] = []
    var canFetchMoreData = true
    
    let api = AnimeApi()
    
    
    //open profile button
    @objc func openProfile(_ sender:UIBarButtonItem!){
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let profileController = storyboard.instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
        
        navigationController?.pushViewController(profileController, animated: true)
    }
    
    //on search bar empty
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("on end")
        if (searchBar.text?.isEmpty)!{
            
            searchBar.endEditing(true)
            fetchData()
            
        }
    }
    
    //when searching
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        tableView.setContentOffset(.zero, animated: true)
        
        let spinner = UIViewController.displaySpinner(onView: self.view)
        searchBar.endEditing(true)
        
        //load api from kitsu
        api.getAnimes(parameter: ["page[limit]":"10", "filter[text]":searchBar.text!]) { (result) in
            UIViewController.removeSpinner(spinner: spinner)
            if(result != nil){
                
                if(result?.count == 0){
                    self.showAlert("Not Found", "Search Not Found!")
                    
                }
                
                self.dataAnime = result!
                self.tableView.reloadData()
            }
            
            
        }
    }
    
    //on search cancel
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        fetchData()
    }
    
    //show alert message
    func showAlert(_ title:String,_ message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //return data size
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataAnime.count
    }
    
    // load table cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "animeItemCell", for : indexPath) as! AnimeItemCell
        let item = self.dataAnime[indexPath.row]
        
        cell.titleLabel.text = item.title
        cell.subTitleLabel.text = item.subTitle
        cell.descriptionLabel.text = item.description
        cell.iconView.imageFromURL(urlString: item.imageUrl, imageError: UIImage(named: "poster_notfound")!)
    
        if(indexPath.row >= dataAnime.count - 3 && canFetchMoreData){
            self.canFetchMoreData = false
            fetchNextData()
        }
        
        return cell
    }
    
    //select anime from list
    func tableView(_ tableView: UITableView,  didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = self.dataAnime[indexPath.row]
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let detailController = storyboard.instantiateViewController(withIdentifier: "DetailController") as! DetailViewController
        
        detailController.animeModel = item
        
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    
    //get next pagination data
    func fetchNextData(){
        api.getNext(completion: { (result) in
            
            if(result != nil){
                
                if(result?.count == 0){
                    self.showAlert("Not Found", "Last Data")
                    
                }
                
                for item in result!{
                    self.dataAnime.append(item)
                }
                
                self.tableView.reloadData()
            }else{
                self.showAlert("Not Found", "The connection is maybe lost or server down")
            }
            
            self.canFetchMoreData = true
            
        })
    }
    
    func getYear() -> Int{
        let date = Date()
        let calendar = Calendar.current
        
        
        return calendar.component(.year, from: date)
    }

    func fetchData(){
        //get newest anime list with current year
        let year = getYear()
    
        let spinner = UIViewController.displaySpinner(onView: self.view)
        
        //load api from kitsu
        api.getAnimes(parameter: ["page[limit]":"10", "filter[seasonYear]":String(year)]) { (result) in
            UIViewController.removeSpinner(spinner: spinner)
            if(result != nil){
                if(result?.count == 0){
                    self.showAlert("Not Found", "Data Empty")
                    
                }
                
                self.dataAnime = result!
                self.tableView.reloadData()
            }else{
                self.showAlert("Not Found", "The connection is maybe lost or server down")
            }
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        
        searchBar.delegate = self
        tableView.delegate = self
        
        let profileButton = UIBarButtonItem(title:"Profile", style:.plain ,target :self, action: #selector(RootViewController.openProfile(_:)))
        navigationItem.rightBarButtonItem = profileButton
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

