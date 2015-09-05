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
        var myCell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as! UITableViewCell
        
        myCell.textLabel?.text = menuItems[indexPath.row]
        
        return myCell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        switch(indexPath.row)
        {
        case 0:
            var mainPageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainPageViewController") as! MainPageViewController
            var mainPageNav = UINavigationController(rootViewController: mainPageViewController)
            
           var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
           appDelegate.drawerContainer!.centerViewController = mainPageNav
           appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
            break
        case 1:
            var aboutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutViewController") as! AboutViewController
            var aboutPageNav = UINavigationController(rootViewController: aboutViewController)
            
            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
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
            println("Not handled")
        }
    }
    
    
     }
