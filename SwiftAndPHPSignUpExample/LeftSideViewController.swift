//
//  LeftSideViewController.swift
//  SwiftAndPHPSignUpExample
//
//  Created by Sergey Kargopolov on 2015-06-27.
//  Copyright (c) 2015 Sergey Kargopolov. All rights reserved.
//

import UIKit

class LeftSideViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    var menuItems:[String] = ["Main","About","Sing out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) 
        
        myCell.textLabel?.text = menuItems[indexPath.row]
        
        return myCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch(indexPath.row)
        {
        case 0:
            let mainPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainPageViewController") as! MainPageViewController
            let mainPageNav = UINavigationController(rootViewController: mainPageViewController)
            
           let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
           appDelegate.drawerContainer!.centerViewController = mainPageNav
           appDelegate.drawerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
            
            break
        case 1:
            let aboutViewController = self.storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
            let aboutPageNav = UINavigationController(rootViewController: aboutViewController)
            
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            appDelegate.drawerContainer!.centerViewController = aboutPageNav
            appDelegate.drawerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
            
            break
        case 2:
            
            UserDefaults.standard.removeObject(forKey: "userFirstName")
            UserDefaults.standard.removeObject(forKey: "userLastName")
            UserDefaults.standard.removeObject(forKey: "userId")
            UserDefaults.standard.synchronize()
            
            
            let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            
            let signInNav = UINavigationController(rootViewController: signInPage)
            
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = signInNav

            break
            
        default:
            print("Not handled")
        }
    }
    
    
     }
