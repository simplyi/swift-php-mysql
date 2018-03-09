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
    

    @IBAction func cancelButtonTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
 
    @IBAction func sendButtonTapped(_ sender: AnyObject) {
        let userEmailAddress = emailAddressTextField.text
        
        if(userEmailAddress!.isEmpty)
        {
         // Display an alert message 
            displayAlertMessage("Please provide email address")
            return
        }
        
        // Dismiss keyboard
        emailAddressTextField.resignFirstResponder()
    
        
        // Display activity Indicator
        let spiningActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        spiningActivity?.labelText = "Loading"
        spiningActivity?.detailsLabelText = "Please wait"
        
        
        // Send HTTP POST
        
        let myUrl = URL(string: "http://localhost/SwiftAppAndMySQL/scripts/requestNewPassword.php");
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "userEmail=\(String(describing: userEmailAddress))";
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            
            //Got response from server
            DispatchQueue.main.async {
                spiningActivity?.hide(true)
                
                if( error != nil)
                {
                    // display an alert message 
                    self.displayAlertMessage(error!.localizedDescription)
                    return
                }
                
                
                do {
                let json =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                
                    let userEmail = parseJSON["userEmail"] as? String
                    if(userEmail != nil)
                    {
                        let myAlert = UIAlertController(title: "Alert", message: "We have sent you email message. Please check your Inbox.", preferredStyle: UIAlertControllerStyle.alert);
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){(action) in
                            self.dismiss(animated: true, completion: nil)
                        }
                        myAlert.addAction(okAction);
                        self.present(myAlert, animated: true, completion: nil)
 
                    } else {
                        
                        let errorMessage = parseJSON["message"] as? String
                        if(errorMessage != nil)
                        {
                            self.displayAlertMessage(errorMessage!)
                        }
                    }

                }
                } catch {
                  print(error)
                }
                
                
            }
            
            
            
            
        }
        task.resume()
        
    }
    
    func displayAlertMessage(_ userMessage:String)
    {
        let myAlert = UIAlertController(title: "Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
        myAlert.addAction(okAction);
        self.present(myAlert, animated: true, completion: nil)
        
    }
    

}
