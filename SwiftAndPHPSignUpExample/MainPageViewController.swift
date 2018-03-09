//
//  MainPageViewController.swift
//  SwiftAndPHPSignUpExample
//
//  Created by Sergey Kargopolov on 2015-06-26.
//  Copyright (c) 2015 Sergey Kargopolov. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var profilePhotoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let userFistName = UserDefaults.standard.string(forKey: "userFirstName")!
        
        let userLastName = UserDefaults.standard.string(forKey: "userLastName")!
        
        let userFullName = userFistName + " " + userLastName
        userFullNameLabel.text = userFullName
        
       if(profilePhotoImageView.image == nil)
       {
          let userId = UserDefaults.standard.string(forKey: "userId")
          let imageUrl = URL(string:"http://localhost/SwiftAppAndMySQL/profile-pictures/\(userId!)/user-profile.jpg")
        
         DispatchQueue.global(qos: .background).async {
        
            let imageData = try? Data(contentsOf: imageUrl!)
            
            if(imageData != nil)
            {
                DispatchQueue.main.async(execute: {
                    self.profilePhotoImageView.image = UIImage(data: imageData!)
                })
            }
            
        }
        
       }
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectProfilePhotoButtonTapped(_ sender: AnyObject) {
        let myImagePicker = UIImagePickerController()
        myImagePicker.delegate = self
        myImagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(myImagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
       profilePhotoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        let spinningActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinningActivity?.labelText = "Loading"
        spinningActivity?.detailsLabelText = "Please wait"
        
        
        myImageUploadRequest()
    }
    
    
    func myImageUploadRequest()
    {
       let myUrl = URL(string: "http://localhost/SwiftAppAndMySQL/scripts/imageUpload.php");
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let userId:String? = UserDefaults.standard.string(forKey: "userId")
        
        let param = [
            "userId" : userId!
        ]
        
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = UIImageJPEGRepresentation(profilePhotoImageView.image!, 1)
        
        if(imageData==nil)  { return; }
        
        request.httpBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            
            DispatchQueue.main.async
            {
              MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            }
            
            if error != nil {
                // Display an alert message
                return
            }
            
            do {
 
            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
            
            DispatchQueue.main.async
            {
            
                if let parseJSON = json {
                // let userId = parseJSON["userId"] as? String
                
                // Display an alert message
                    let userMessage = parseJSON["message"] as? String
                    self.displayAlertMessage(userMessage!)
                } else {
               // Display an alert message
                    let userMessage = "Could not upload image at this time"
                    self.displayAlertMessage(userMessage)
                }
            }
            } catch
            {
                print(error)
            }
            
        }
            
            task.resume()
            
        
        
    }
    
    /*
    @IBAction func signOutButtonTapped(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userFirstName")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userLastName")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userId")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        
        let signInPage = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        
        let signInNav = UINavigationController(rootViewController: signInPage)
        
        let appDelegate = UIApplication.sharedApplication().delegate
        appDelegate?.window??.rootViewController = signInNav
        
    
    }
*/
    func createBodyWithParameters(_ parameters: [String: String]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> Data {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey)
        body.appendString("\r\n")
        
        
        
        body.appendString("--\(boundary)--\r\n")
        
        return body as Data
    }
 

func generateBoundaryString() -> String {
   // Create and return a unique string.
   return "Boundary-\(UUID().uuidString)"
}
    
    func displayAlertMessage(_ userMessage:String)
    {
        let myAlert = UIAlertController(title: "Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
        
        myAlert.addAction(okAction);
        
        self.present(myAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func leftSideButtonTapped(_ sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
       appDelegate.drawerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    @IBAction func rightSideButtonTapped(_ sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.drawerContainer!.toggle(MMDrawerSide.right, animated: true, completion: nil)
    }
  

}



extension NSMutableData {
    
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
