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
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return menuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let myCell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) 
        
        myCell.textLabel?.text = menuItems[indexPath.row]
        
        return myCell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        switch(indexPath.row)
        {
        case 0:
            let mainPageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainPageViewController") as! MainPageViewController
            let mainPageNav = UINavigationController(rootViewController: mainPageViewController)
            
           let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
           appDelegate.drawerContainer!.centerViewController = mainPageNav
           appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
            break
        case 1:
            let aboutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutViewController") as! AboutViewController
            let aboutPageNav = UINavigationController(rootViewController: aboutViewController)
            
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.drawerContainer!.centerViewController = aboutPageNav
            appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
            break
        case 2:
            
            NSUserDefaults.standardUserDefaults().removeObjectForKey("userFirstName")
            NSUserDefaults.standardUserDefaults().removeObjectForKey("userLastName")
            NSUserDefaults.standardUserDefaults().removeObjectForKey("userId")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            
            let signInPage = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
            
            let signInNav = UINavigationController(rootViewController: signInPage)
            
            let appDelegate = UIApplication.sharedApplication().delegate
            appDelegate?.window??.rootViewController = signInNav

            break
            
        default:
            print("Not handled")
        }
    }
    
    
     }
