//
//  AppDelegate.swift
//  SwiftAndPHPSignUpExample
//
//  Created by Sergey Kargopolov on 2015-06-23.
//  Copyright (c) 2015 Sergey Kargopolov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var drawerContainer:MMDrawerController?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let userId = NSUserDefaults.standardUserDefaults().stringForKey("userId")
        
        if(userId != nil)
        {
            // take user to protected page
            /*let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainPage = mainStoryboard.instantiateViewControllerWithIdentifier("MainPageViewController") as! MainPageViewController
            
            let mainPageNav = UINavigationController(rootViewController: mainPage)
            self.window?.rootViewController = mainPageNav
            */
            
            buildNavigationDrawer()
          
            
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    func buildNavigationDrawer()
    {
        // Navigate to Protected page
        let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        
        // Create View Controllers
        let mainPage:MainPageViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("MainPageViewController") as! MainPageViewController
        
        let leftSideMenu:LeftSideViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("LeftSideViewController") as! LeftSideViewController
        
        let rightSideMenu:RightSideViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("RightSideViewController") as! RightSideViewController
        
        let mainPageNav = UINavigationController(rootViewController:mainPage)
        let leftSideMenuNav = UINavigationController(rootViewController:leftSideMenu)
        let rightSideMenuNav = UINavigationController(rootViewController:rightSideMenu)
        
        
        drawerContainer  = MMDrawerController(centerViewController: mainPageNav, leftDrawerViewController: leftSideMenuNav, rightDrawerViewController: rightSideMenuNav)
        
        drawerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.PanningCenterView
        drawerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.PanningCenterView
        
        window?.rootViewController = drawerContainer
        
        
    }

}

