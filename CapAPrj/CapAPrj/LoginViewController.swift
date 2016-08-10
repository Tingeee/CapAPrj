//
//  LoginViewController.swift
//  CapAPrj
//
//  Created by Ting on 16/7/21.
//  Copyright © 2016年 Ting. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    
    @IBOutlet weak var respC: UITextField!
    @IBOutlet weak var url: UITextField!
    @IBOutlet weak var time: UITextField!
    @IBOutlet weak var vin: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //let vintext = vin.text
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(sender: AnyObject) {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.loggedIn = true
        if vin.hasText(){
            //print("Hello")
            delegate.objects = ["vin": vin.text!, "time":time.text!, "url":url.text!, "responsecode":respC.text!, "none":""]
            //delegate.objects = []
            //print(delegate.objects)
        }else{
            delegate.objects.removeAll()
        }
        delegate.setupRootViewController(true)
       //03.08.16
        
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    // override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
    // }
     
    
}
