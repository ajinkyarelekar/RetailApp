//
//  ViewController.swift
//  RetailApp swift
//
//  Created by Ajinkya's on 24/03/15.
//  Copyright (c) 2015 Ajinkya. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate
{
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet var vwLogin: UIView!
    @IBOutlet var txtPassWordLogin: UITextField!
    @IBOutlet var txtEmailLogin: UITextField!
    @IBOutlet var lblErrorMsg: UILabel!
    
    
    @IBOutlet var vwForgetPass: UIView!
    @IBOutlet var lblFPError: UILabel!
    @IBOutlet var txtForgetPassEmail: UITextField!
    
    @IBOutlet var vwFPSuccess: UIView!
    @IBOutlet var lblFPSuccessMsg: UILabel!
    
    var constant = constants();
    
    
    var altWait : UIAlertView = UIAlertView(title: "", message: "Please wait...", delegate: nil, cancelButtonTitle: nil)
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------
    //MARK: TextField Methods
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        if(textField == txtForgetPassEmail)
        {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.view.frame = CGRect(x: 0, y: -160, width: self.view.frame.size.width, height: self.view.frame.size.height)
            })
            
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        if(textField == txtForgetPassEmail)
        {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            })
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if(textField == txtEmailLogin)
        {
            txtEmailLogin.resignFirstResponder()
            txtPassWordLogin.becomeFirstResponder()
        }
        else
        {
            textField.resignFirstResponder()
        }
        return false
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        self.view.endEditing(true)
    
    }
//-----------------------------------------------------------------------------------------------------------------------------------
    //MARK: IBactions Methods
    
    
    
    @IBAction func btnFPOkClicked(sender: AnyObject)
    {
        self.vwFPSuccess.hidden = true
    }
    
    @IBAction func btnCloseForgtPassClicked(sender: AnyObject)
    {
        self.vwForgetPass.hidden = true
        self.vwLogin.hidden = false
    }
    
    @IBAction func btnNeedHelpClicked(sender: AnyObject)
    {
        self.vwForgetPass.hidden = false
        self.vwLogin.hidden = true
    }
    
    @IBAction func btnSendMeInstructionsClicked(sender: AnyObject)
    {
        self.lblFPError.hidden = true
        
        
        if self.txtForgetPassEmail.text == ""
        {
            self.constant.showAlertWithTitleAndMesssage("Email/Phone Missing", msg: "Please enter email address or phone number.")
            return
        }
        
        altWait.show()
        
        var urlStr : NSString = NSString(format:"%@%@%@%@",constant.baseUrl,constant.apiKey,constant.userPassResetService,constant.userPassResetMethod)
        urlStr = urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        var str : NSString = NSString(format: "acctidentifier=%@",self.txtForgetPassEmail.text)
        
        self.txtForgetPassEmail.text = ""
        
        constant.PerformRequestwith(urlStr, strparam: str,methodUsed:"POST") { (data) -> () in
            self.altWait.dismissWithClickedButtonIndex(0, animated: true)
            if (data != nil)
            {
                var dict: AnyObject?=NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil)
                if (dict?.isKindOfClass(NSDictionary) == true)
                {
                    let d : NSDictionary = dict as! NSDictionary
                    
                    if(d.valueForKey("code")?.intValue == 200)
                    {
                        self.lblFPSuccessMsg.text = d.valueForKey("data") as? String
                        self.vwForgetPass.hidden = true
                        self.vwFPSuccess.hidden = false
                    }
                    else
                    {
                        self.lblFPError.text = d.valueForKey("data") as? String
                        self.lblFPError.hidden = false
                    }
                }
            }
        }
    }
    
    @IBAction func btnCloseLoginClicked(sender: AnyObject)
    {
        vwLogin.hidden=true;
        txtEmailLogin.text = ""
        txtPassWordLogin.text = ""
        lblErrorMsg.hidden = true
    }
    @IBAction func btnLoginClicked(sender: AnyObject)
    {
        vwLogin.hidden=false;
    }
    
    @IBAction func btnSignInClicked(sender: AnyObject)
    {
        lblErrorMsg.hidden = true
        
        var msg : NSString
        
        if txtEmailLogin.text .isEmpty
        {
            msg="Please enter email address"
            
            constant.showAlertWithTitleAndMesssage("Error!", msg: msg)
            return
        }
        else if txtPassWordLogin.text .isEmpty
        {
            msg="Please enter password"
            constant.showAlertWithTitleAndMesssage("Error!", msg: msg)
            return
        }
        
        self.altWait.show()
        
        var urlStr : NSString = NSString(format:"%@%@%@%@",constant.baseUrl,constant.apiKey,constant.userLoginService,constant.userLoginMethod)
        urlStr = urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        
        var str : NSString = NSString(format: "cu=%@&cp=%@",txtEmailLogin.text,txtPassWordLogin.text)
        
        txtEmailLogin.text = ""
        txtPassWordLogin.text = ""
        
        constant.PerformRequestwith(urlStr, strparam: str,methodUsed:"POST") { (data) -> () in
            self.altWait.dismissWithClickedButtonIndex(0, animated: true)
            if (data != nil)
            {
                var dict: AnyObject?=NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil)
                if (dict?.isKindOfClass(NSDictionary) == true)
                {
                    let d : NSDictionary = dict as! NSDictionary
                    
                    if(d.valueForKey("data")?.isKindOfClass(NSDictionary) == true)
                    {
                        println("login successful")
        
                        self.delegate.userDetails=d.valueForKey("data") as! NSMutableDictionary
                        
                        self.performSegueWithIdentifier("LoginSegue", sender: self)
                    }
                    else
                    {
                        println("login failed")
                        
                        self.lblErrorMsg.text = d.valueForKey("data") as? String
                        self.lblErrorMsg.hidden = false
                    }
                }
            }
        }
        
    }
}

