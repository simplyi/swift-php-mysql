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

    @IBAction func signInButtonTapped(_ sender: AnyObject) {
       
        let userEmailAddress = userEmailAddressTextField.text
        let userPassword = userPasswordTextField.text
        
        
        if(userEmailAddress!.isEmpty || userPassword!.isEmpty)
        {
          // Display an alert message
            let myAlert = UIAlertController(title: "Alert", message:"All fields are required to fill in", preferredStyle: UIAlertControllerStyle.alert);
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
            myAlert.addAction(okAction);
            self.present(myAlert, animated: true, completion: nil)
            return
        }
        
        
        let spinningActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinningActivity?.labelText = "Loading"
        spinningActivity?.detailsLabelText = "Please wait"
        
        
     let myUrl = URL(string: "http://localhost/SwiftAppAndMySQL/scripts/userSignIn.php");
       
     var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
     let postString = "userEmail=\(userEmailAddress!)&userPassword=\(userPassword!)";
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
           
            DispatchQueue.main.async
            {
                
                spinningActivity?.hide(true)
                
                
               if(error != nil)
               {
                  //Display an alert message
                let myAlert = UIAlertController(title: "Alert", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert);
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
                myAlert.addAction(okAction);
                self.present(myAlert, animated: true, completion: nil)
                 return
               }
                
                
                
                do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                 
                    let userId = parseJSON["userId"] as? String
                    if(userId != nil)
                    {
                        
                       UserDefaults.standard.set(parseJSON["userFirstName"], forKey: "userFirstName")
                        UserDefaults.standard.set(parseJSON["userLastName"], forKey: "userLastName")
                       UserDefaults.standard.set(parseJSON["userId"], forKey: "userId")
                        UserDefaults.standard.synchronize()
                        
                       // take user to a protected page
                        /*
                        let mainPage = self.storyboard?.instantiateViewControllerWithIdentifier("MainPageViewController") as! MainPageViewController
                        
                        let mainPageNav = UINavigationController(rootViewController: mainPage)
                        let appDelegate = UIApplication.sharedApplication().delegate
                        
                        appDelegate?.window??.rootViewController = mainPageNav
                  */
                        
                     let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        
                        appDelegate.buildNavigationDrawer()
                        
                        
                    } else {
                      // display an alert message
                        let userMessage = parseJSON["message"] as? String
                        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
                        myAlert.addAction(okAction);
                        self.present(myAlert, animated: true, completion: nil)
                    }
                
                    }
                } catch
                {
                   print(error)
                }
                
                
            }
            
            
            
        }
        task.resume()
        
    }

}

