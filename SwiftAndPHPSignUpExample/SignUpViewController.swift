//
//  SignUpViewController.swift
//  SwiftAndPHPSignUpExample
//
//  Created by Sergey Kargopolov on 2015-06-23.
//  Copyright (c) 2015 Sergey Kargopolov. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var userEmailAddressTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userPasswordRepeatTextField: UITextField!
    @IBOutlet weak var userFirstNameTextField: UITextField!
    @IBOutlet weak var userLastNameTextField: UITextField!
 
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

    @IBAction func signUpButtonTapped(_ sender: AnyObject) {
        let userEmail = userEmailAddressTextField.text
        let userPassword = userPasswordTextField.text
        let userPasswordRepeat = userPasswordRepeatTextField.text
        let userFirstName = userFirstNameTextField.text
        let userLastName = userLastNameTextField.text
        
        if( userPassword != userPasswordRepeat)
        {
          // Display alert message
            displayAlertMessage("Passwords do not match")
            return
        }
        
        if(userEmail!.isEmpty || userPassword!.isEmpty || userFirstName!.isEmpty || userLastName!.isEmpty)
        {
            // Display an alert message
            displayAlertMessage("All fields are required to fill in")
            return
        }
        
        let spinningActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinningActivity?.labelText = "Loading"
        spinningActivity?.detailsLabelText = "Please wait"
        
        
        // Send HTTP POST
        
        let myUrl = URL(string: "http://localhost/SwiftAppAndMySQL/scripts/registerUser.php");
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "userEmail=\(userEmail!)&userFirstName=\(userFirstName!)&userLastName=\(userLastName!)&userPassword=\(userPassword!)";
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
        
            DispatchQueue.main.async
            {
                
                spinningActivity?.hide(true)
                
                if error != nil {
                    self.displayAlertMessage(error!.localizedDescription)
                    return
                }
                
                do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
               
                if let parseJSON = json {
                    
                    let userId = parseJSON["userId"] as? String
                    
                    if( userId != nil)
                    {
                        let myAlert = UIAlertController(title: "Alert", message: "Registration successful", preferredStyle: UIAlertControllerStyle.alert);
                       
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
                } catch{
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
