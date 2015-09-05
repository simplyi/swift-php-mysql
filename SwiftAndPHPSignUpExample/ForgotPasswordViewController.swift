//
//  ForgotPasswordViewController.swift
//  SwiftAndPHPSignUpExample
//
//  Created by Sergey Kargopolov on 2015-07-02.
//  Copyright (c) 2015 Sergey Kargopolov. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var emailAddressTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
 
    @IBAction func sendButtonTapped(sender: AnyObject) {
        let userEmailAddress = emailAddressTextField.text
        
        if(userEmailAddress.isEmpty)
        {
         // Display an alert message 
            displayAlertMessage("Please provide email address")
            return
        }
        
        // Dismiss keyboard
        emailAddressTextField.resignFirstResponder()
    
        
        // Display activity Indicator
        let spiningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spiningActivity.labelText = "Loading"
        spiningActivity.detailsLabelText = "Please wait"
        
        
        // Send HTTP POST
        
        let myUrl = NSURL(string: "http://localhost/SwiftAppAndMySQL/scripts/requestNewPassword.php");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        let postString = "userEmail=\(userEmailAddress)";
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            //Got response from server
            dispatch_async(dispatch_get_main_queue()) {
                spiningActivity.hide(true)
                
                if( error != nil)
                {
                    // display an alert message 
                    self.displayAlertMessage(error.localizedDescription)
                    return
                }
                
                
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err) as? NSDictionary
                
                if let parseJSON = json {
                
                    var userEmail = parseJSON["userEmail"] as? String
                    if(userEmail != nil)
                    {
                        var myAlert = UIAlertController(title: "Alert", message: "We have sent you email message. Please check your Inbox.", preferredStyle: UIAlertControllerStyle.Alert);
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){(action) in
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                        myAlert.addAction(okAction);
                        self.presentViewController(myAlert, animated: true, completion: nil)
 
                    } else {
                        
                        let errorMessage = parseJSON["message"] as? String
                        if(errorMessage != nil)
                        {
                            self.displayAlertMessage(errorMessage!)
                        }
                    }

                }
                
                
            }
            
            
            
            
        }
        task.resume()
        
    }
    
    func displayAlertMessage(userMessage:String)
    {
        var myAlert = UIAlertController(title: "Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil)
        myAlert.addAction(okAction);
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }
    

}
