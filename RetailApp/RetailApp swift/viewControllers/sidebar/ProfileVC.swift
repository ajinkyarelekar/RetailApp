//
//  ProfileVC.swift
//  RetailApp swift
//
//  Created by Ajinkya's on 07/04/15.
//  Copyright (c) 2015 Ajinkya. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController,UITextFieldDelegate,UIAlertViewDelegate
{
    
    let constant = constants()
    
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtPhone: UITextField!
    
    @IBOutlet var vwChangePassword: UIView!
    @IBOutlet var txtCurrentPass: UITextField!
    @IBOutlet var txtNewPass: UITextField!
    @IBOutlet var txtConfirmNewPass: UITextField!

    @IBOutlet var btnEdit: UIButton!

    var altWait : UIAlertView = UIAlertView(title: "", message: "Please wait...", delegate: nil, cancelButtonTitle: nil)
    var isChangePasswordViewVisible = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        txtFirstName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 40))
        txtLastName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 40))
        txtPassword.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 40))
        txtEmail.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 40))
        txtPhone.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 40))
        
        txtFirstName.leftViewMode = UITextFieldViewMode.Always
        txtLastName.leftViewMode = UITextFieldViewMode.Always
        txtPassword.leftViewMode = UITextFieldViewMode.Always
        txtEmail.leftViewMode = UITextFieldViewMode.Always
        txtPhone.leftViewMode = UITextFieldViewMode.Always
        
        txtEmail.enabled = false
        txtPhone.enabled = false
        
        txtCurrentPass.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 40))
        txtNewPass.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 40))
        txtConfirmNewPass.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 40))
        
        txtCurrentPass.leftViewMode = UITextFieldViewMode.Always
        txtNewPass.leftViewMode = UITextFieldViewMode.Always
        txtConfirmNewPass.leftViewMode = UITextFieldViewMode.Always
        

        // Do any additional setup after loading the view.
        
        self.getProfileDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------Textfield  Methods-----------
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return false
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------Custom  Methods-----------
    func getProfileDetails()
    {
        self.altWait.show()
        var urlStr : NSString = NSString(format:"%@%@%@%@",constant.baseUrl,constant.apiKey,constant.userProfileService,constant.userProfileMethod)
        urlStr = urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        constant.PerformRequestwith(urlStr, strparam: "", methodUsed: "POST") { (data) -> () in
            
            self.altWait.dismissWithClickedButtonIndex(0, animated: true)
            if (data != nil)
            {
                var dict: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil)
                
                if (dict?.isKindOfClass(NSDictionary) == true)
                {
                    let d : NSDictionary = dict as! NSDictionary
                    
                    if (d.valueForKey("code")?.intValue == 200)
                    {
                        println("Profile data found")
                        
                        var det : NSDictionary = d .valueForKey("data")?.valueForKey("profile")?.firstObject as! NSDictionary
                        
                        self.txtFirstName.text = det.valueForKey("firstname") as! String
                        self.txtLastName.text = det.valueForKey("lastname") as! String
                        self.txtEmail.text = det.valueForKey("email") as! String
                        self.txtPhone.text = det.valueForKey("phone") as! String
                    }
                }
                else
                {
                    println(" failed")
                    
                    self.constant.showAlertWithTitleAndMesssage("Code not sent", msg: "Code could not be sent due to sone internal error! Please try again later.")
                }
            }
        }

    }
    
    func saveProfile()
    {
        self.altWait.show()
        var urlStr : NSString = NSString(format:"%@%@%@%@",constant.baseUrl,constant.apiKey,constant.userProfileChangeDataService,constant.userProfileChangeDataMethod)
        urlStr = urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        var str : NSString = NSString(format: "fname=%@&lname=%@",self.txtFirstName.text,self.txtLastName.text)
        
        constant.PerformRequestwith(urlStr, strparam: str, methodUsed: "POST") { (data) -> () in
            
            self.altWait.dismissWithClickedButtonIndex(0, animated: true)
            if (data != nil)
            {
                var dict: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil)
                
                if (dict?.isKindOfClass(NSDictionary) == true)
                {
                    let d : NSDictionary = dict as! NSDictionary
                    
                    if (d.valueForKey("code")?.intValue == 200)
                    {
                        var alt : UIAlertView = UIAlertView(title: "Success", message: d.valueForKey("data") as? String, delegate: self, cancelButtonTitle: "OK")
                        alt.tag = 100
                        alt.show()
                        var tempDict : NSMutableDictionary = self.constant.delegate.userDetails.mutableCopy() as! NSMutableDictionary
                        tempDict.setValue(self.txtFirstName.text, forKey: "firstname")
                        self.constant.delegate.userDetails = tempDict
                    }
                }
            }
        }
    }
    
    func changePassword()
    {
        self.altWait.show()
        var urlStr : NSString = NSString(format:"%@%@%@%@",constant.baseUrl,constant.apiKey,constant.userProfileChangePasswordService,constant.userProfileChangePasswordMethod)
        urlStr = urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        var str : NSString = NSString(format:"oldpass=%@&newpass1=%@&newpass2=%@",self.txtCurrentPass.text,self.txtNewPass.text,self.txtConfirmNewPass.text)
        
        constant.PerformRequestwith(urlStr, strparam: str, methodUsed: "POST"){ (data) -> () in
            
            self.altWait.dismissWithClickedButtonIndex(0, animated: true)
            if (data != nil)
            {
                var dict: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil)
                
                if (dict?.isKindOfClass(NSDictionary) == true)
                {
                    let d : NSDictionary = dict as! NSDictionary
                    
                    if (d.valueForKey("code")?.intValue == 200)
                    {
                        self.constant.showAlertWithTitleAndMesssage("Success", msg: d.valueForKey("data") as! NSString)
                        self.btnBackClicked(UIButton())
                    }
                    else if (d.valueForKey("code")?.intValue == 404)
                    {
                        self.constant.showAlertWithTitleAndMesssage("Failed", msg: d.valueForKey("errors")?.firstObject as! NSString)
                    }
                    else if (d.valueForKey("code")?.intValue == 400)
                    {
                        self.constant.showAlertWithTitleAndMesssage("Failed", msg: d.valueForKey("data") as! NSString)
                    }
                }
            }
        }
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------IBActions  Methods-----------
    
    @IBAction func btnPasswordNextClicked(sender: AnyObject)
    {
        vwChangePassword.hidden = false
        isChangePasswordViewVisible = true
    }
    
    @IBAction func btnBackClicked(sender: AnyObject)
    {
        if(isChangePasswordViewVisible == false)
        {
            for ViewCntrl in self.navigationController!.viewControllers
            {
                if(ViewCntrl.isMemberOfClass(homePageVC) == true)
                {
                    self.navigationController!.popToViewController(ViewCntrl as! homePageVC, animated: true)
                    break
                }
            }
        }
        else
        {
            vwChangePassword.hidden = true
            isChangePasswordViewVisible = false
        }
    }
    
    @IBAction func editBtnClicked(sender: AnyObject)
    {
        if(isChangePasswordViewVisible == true)
        {
            self.changePassword()
        }
        else
        {
            self.saveProfile()
        }
    }
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int)
    {
        if alertView.tag == 100
        {
            self.btnBackClicked(UIButton())
        }
    }
    /*
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
