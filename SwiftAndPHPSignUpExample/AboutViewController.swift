//
//  AboutViewController.swift
//  SwiftAndPHPSignUpExample
//
//  Created by Sergey Kargopolov on 2015-06-27.
//  Copyright (c) 2015 Sergey Kargopolov. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
