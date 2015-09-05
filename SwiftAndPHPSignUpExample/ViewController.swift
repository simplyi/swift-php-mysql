//
//  ViewController.swift
//  SwiftAndPHPSignUpExample
//
//  Created by Sergey Kargopolov on 2015-06-23.
//  Copyright (c) 2015 Sergey Kargopolov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var userEmailAddressTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signInButtonTapped(sender: AnyObject) {
       
        let userEmailAddress = userEmailAddressTextField.text
        let userPassword = userPasswordTextField.text
        
        
        if(userEmailAddress.isEmpty || userPassword.isEmpty)
        {
          // Display an alert message
            var myAlert = UIAlertController(title: "Alert", message:"All fields are required to fill in", preferredStyle: UIAlertControllerStyle.Alert);
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil)
            myAlert.addAction(okAction);
            self.presentViewController(myAlert, animated: true, completion: nil)
            return
        }
        
        
        let spinningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spinningActivity.labelText = "Loading"
        spinningActivity.detailsLabelText = "Please wait"
        
        
     let myUrl = NSURL(string: "http://localhost/SwiftAppAndMySQL/scripts/userSignIn.php");
       
    let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
     let postString = "userEmail=\(userEmailAddress)&userPassword=\(userPassword)";
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
           
            dispatch_async(dispatch_get_main_queue())
            {
                
                spinningActivity.hide(true)
                
                
               if(error != nil)
               {
                  //Display an alert message
                var myAlert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert);
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil)
                myAlert.addAction(okAction);
                self.presentViewController(myAlert, animated: true, completion: nil)
                 return
               }
                
                
                
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err) as? NSDictionary
                
                if let parseJSON = json {
                 
                    let userId = parseJSON["userId"] as? String
                    if(userId != nil)
                    {
                        
                       NSUserDefaults.standardUserDefaults().setObject(parseJSON["userFirstName"], forKey: "userFirstName")
                        NSUserDefaults.standardUserDefaults().setObject(parseJSON["userLastName"], forKey: "userLastName")
                       NSUserDefaults.standardUserDefaults().setObject(parseJSON["userId"], forKey: "userId")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
                       // take user to a protected page
                        /*
                        let mainPage = self.storyboard?.instantiateViewControllerWithIdentifier("MainPageViewController") as! MainPageViewController
                        
                        let mainPageNav = UINavigationController(rootViewController: mainPage)
                        let appDelegate = UIApplication.sharedApplication().delegate
                        
                        appDelegate?.window??.rootViewController = mainPageNav
                  */
                        
                     let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        
                        appDelegate.buildNavigationDrawer()
                        
                        
                    } else {
                      // display an alert message
                        let userMessage = parseJSON["message"] as? String
                        var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert);
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil)
                        myAlert.addAction(okAction);
                        self.presentViewController(myAlert, animated: true, completion: nil)
                    }
                
                }
                
                
            }
            
            
            
        }).resume()
        
    }

}

