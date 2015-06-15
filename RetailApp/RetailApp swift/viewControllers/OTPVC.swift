//
//  OTPVC.swift
//  RetailApp swift
//
//  Created by Ajinkya's on 27/03/15.
//  Copyright (c) 2015 Ajinkya. All rights reserved.
//

import UIKit

class OTPVC: UIViewController,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate
{
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var timer : NSTimer!
    var timeSec : Int! = 60
    
    var TandC : Int!
    
    var vwFAQ : UIView!
    
    @IBOutlet var imgVwBG: UIImageView!
    @IBOutlet var vwLogo: UIView!
    
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var btnSend: UIButton!
    
    //MobileNo View
    @IBOutlet var vwMobileNo: UIView!
    @IBOutlet var btnSelectCountry: UIButton!
    
    //Verification View
    @IBOutlet var vwVerifyOTP: UIView!
    @IBOutlet var txtCountryCode: UITextField!
    @IBOutlet var txtPhoneNo: UITextField!
    @IBOutlet var txtN1: UITextField!
    @IBOutlet var txtN2: UITextField!
    @IBOutlet var txtN3: UITextField!
    @IBOutlet var txtN4: UITextField!
    @IBOutlet var btnResendCode: UIButton!
    
    //SignUpView
    @IBOutlet var vwSignUp: UIView!
    @IBOutlet var btnCheckBox: UIButton!
    @IBOutlet var btnTandC: UIButton!
    @IBOutlet var btnCreateAccount: UIButton!
    @IBOutlet var txtDay: UITextField!
    @IBOutlet var txtMonth: UITextField!
    @IBOutlet var txtYear: UITextField!
    @IBOutlet var txtReferralCode: UITextField!
    @IBOutlet var txtCivilID: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtFirstNAme: UITextField!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var btnBirthDateNeed: UIButton!
    
    var currentTXT : UITextField!
    
    var arrDay : NSArray = NSArray(objects: "1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31")
    var arrMonth : NSArray = NSArray(objects: "1","2","3","4","5","6","7","8","9","10","11","12")
    var arrYear : NSMutableArray!
    var arrPickerArray : NSMutableArray!
    
    var vwShadow : UIView = UIView()
    
    
    let constant = constants()
    
    var altWait : UIAlertView = UIAlertView(title: "", message: "Please wait...", delegate: nil, cancelButtonTitle: nil)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.btnResendCode.enabled=false
        
        arrYear = NSMutableArray()
        arrPickerArray = NSMutableArray()
        
        var i :Int
        
        for i = 1915 ; i <= 2100 ; i++
        {
            var str : NSString = NSString(format: "%d",i)
            arrYear.addObject(str)
        }
        
        btnSend.clipsToBounds = true;
        btnSend.layer.cornerRadius = 10;
        
        btnCancel.clipsToBounds = true;
        btnCancel.layer.cornerRadius = 10;

    }
    
    override func viewWillAppear(animated: Bool)
    {
        txtCountryCode.text=delegate.countryCode as String
        btnSelectCountry.setTitle(delegate.countryName as String, forState: UIControlState.Normal)
        txtCountryCode.userInteractionEnabled=false
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
            self.view.endEditing(true)
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------Picker Methods-----------
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return arrPickerArray.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!
    {
        return arrPickerArray.objectAtIndex(row) as! String
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        currentTXT.text = arrPickerArray.objectAtIndex(row) as! String
    }
    
//--------------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------TextField Methods-----------

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        let toolbar : UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        toolbar.barStyle=UIBarStyle.BlackTranslucent
        toolbar.items = NSArray(objects: UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "doneWithPicker")) as [AnyObject]
        toolbar.sizeToFit()
        
        let pickr = UIPickerView(frame: CGRectMake(0, 203, 320, 162));
        pickr.dataSource=self
        pickr.delegate=self
       
        currentTXT = textField
        
        if (textField == txtDay)
        {
            arrPickerArray.removeAllObjects()
            arrPickerArray.addObjectsFromArray(arrDay as [AnyObject])
            pickr.reloadAllComponents()
            textField.inputView=pickr
            textField.inputAccessoryView=toolbar
            textField.text = "1"
        }
        else if (textField == txtMonth)
        {
            arrPickerArray.removeAllObjects()
            arrPickerArray.addObjectsFromArray(arrMonth as [AnyObject])
            pickr.reloadAllComponents()
            textField.inputView=pickr
            textField.inputAccessoryView=toolbar
            textField.text = "1"
        }
        else if (textField == txtYear)
        {
            arrPickerArray.removeAllObjects()
            arrPickerArray.addObjectsFromArray(arrYear as [AnyObject])
            pickr.reloadAllComponents()
            textField.inputView=pickr
            textField.inputAccessoryView=toolbar
            textField.text = "1915"
        }
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return false
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        if textField == txtN1
        {
            if string != ""
            {
                textField.text=string
                textField .resignFirstResponder()
                txtN2.becomeFirstResponder()
            }
            else
            {
                textField.text=""
            }
            return false
        }
        else if textField == txtN2
        {
            textField .resignFirstResponder()
            if string != ""
            {
                textField.text=string
                txtN3.becomeFirstResponder()
            }
            else
            {
                textField.text=""
                txtN1.becomeFirstResponder()
            }
            return false
        }
        else if textField == txtN3
        {
            textField .resignFirstResponder()
            if string != ""
            {
                textField.text=string
                txtN4.becomeFirstResponder()
            }
            else
            {
                textField.text=""
                txtN2.becomeFirstResponder()
            }
            return false
        }
        else if textField == txtN4
        {
            if string != ""
            {
                textField.text=string
                textField .resignFirstResponder()
                self.btnDoneClicked(UIButton())
            }
            else if string == ""
            {
                textField.text=""
                textField .resignFirstResponder()
                txtN3.becomeFirstResponder()
            }
            return false
        }
        else if textField == txtCivilID
        {
            if (string != "" && count(txtCivilID.text) == 16)
            {
                return false
            }
            else
            {
                return true
            }
        }
        else if textField == txtReferralCode
        {
            if (string != "" && count(txtReferralCode.text) == 10)
            {
                return false
            }
            else
            {
                return true
            }
        }
        return true
    }
    
    
//--------------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------IBActions Methods-----------
    
    @IBAction func btnDoneClicked(sender: AnyObject)
    {
        var msg : NSString
        
        if (txtN1.text.isEmpty || txtN2.text.isEmpty || txtN3.text.isEmpty || txtN4.text.isEmpty)
        {
            msg="Please enter verification code correctly."
            
            constant.showAlertWithTitleAndMesssage("Error!", msg: msg)
            return
        }
        
        self.altWait.show()
        
        var urlStr : NSString = NSString(format:"%@%@%@%@",constant.baseUrl,constant.apiKey,constant.VerifySMScodeService,constant.verifyUserMethd)
        urlStr = urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        var str : NSString =  NSString(format:"%@%@",txtCountryCode.text,txtPhoneNo.text)
        
        var strparam :NSString=NSString(format:"up=%@&uc=%@%@%@%@", str,txtN1.text,txtN2.text,txtN3.text,txtN4.text)
        
        txtN1.text = ""
        txtN2.text = ""
        txtN3.text = ""
        txtN4.text = ""
        
        
        constant.PerformRequestwith(urlStr, strparam: strparam,methodUsed:"POST") { (data) -> () in
            if (data != nil)
            {
                self.altWait.dismissWithClickedButtonIndex(0, animated: true)
                var dict: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil)
                
                if (dict?.isKindOfClass(NSDictionary) == true)
                {
                    let d : NSDictionary = dict as! NSDictionary
                        
                    if (d.valueForKey("code")?.intValue == 200)
                    {
                        var str : NSString = d.valueForKey("data") as! NSString
                        
                        if(str.isEqualToString("Your phone number has been confirmed.") == true)
                        {
                            println("successful")
                            self.btnNextViewClicked(UIButton())
                        }
                        else
                        {
                            self.constant.showAlertWithTitleAndMesssage("", msg: d.valueForKey("data") as! NSString)
                        }
                    }
                    else if (d.valueForKey("code")?.intValue == 400)
                    {
                        self.constant.showAlertWithTitleAndMesssage("", msg: d.valueForKey("data") as! NSString)
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
    
    @IBAction func btnCancelClicked(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btnSendMobNoClicked(sender: AnyObject)
    {
        var msg : NSString
        
        if txtPhoneNo.text .isEmpty
        {
            msg="Please enter phone number."
            
            constant.showAlertWithTitleAndMesssage("Error!", msg: msg)
            return
        }
        
        self.altWait.show()
        var urlStr : NSString = NSString(format:"%@%@%@%@",constant.baseUrl,constant.apiKey,constant.verifyUSerService,constant.verifyUserMethd)
        urlStr = urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        var str : NSString =  NSString(format:"%@%@",txtCountryCode.text,txtPhoneNo.text)
        
        var strparam :NSString=NSString(format:"up=%@", str)
        
        
        constant.PerformRequestwith(urlStr, strparam: strparam,methodUsed:"POST") { (data) -> () in
            
            self.altWait.dismissWithClickedButtonIndex(0, animated: true)
            
            if (data != nil)
            {
                var dict: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil)
                
                if (dict?.isKindOfClass(NSDictionary) == true)
                {
                    let d : NSDictionary = dict as! NSDictionary
                    
                    if (d.valueForKey("code")?.intValue == 200)
                    {
                        println("successful")
                        self.constant.showAlertWithTitleAndMesssage("Code Sent", msg: d.valueForKey("data") as! NSString)
                        self.btnNextClicked(UIButton())
                        self.txtN1.becomeFirstResponder()
                        self.startTimer()
                    }
                    else if (d.valueForKey("code")?.intValue == 400)
                    {
                        println(" failed")
                        
                        var alt : UIAlertView = UIAlertView(title: "Code not sent!", message: d.valueForKey("data") as? String, delegate: self, cancelButtonTitle: "OK")
                        alt.tag = 1010
                        alt.show()
                        self.txtPhoneNo.becomeFirstResponder()
                    }
                    else
                    {
                        println(" failed")
                        
                        var alt : UIAlertView = UIAlertView(title: "Code not sent!", message: d.valueForKey("errors")?.firstObject as? String, delegate: self, cancelButtonTitle: "OK")
                        alt.tag = 1010
                        alt.show()
                        self.txtPhoneNo.becomeFirstResponder()
                    }
                }
                else
                {
                    println(" failed")
                    
                    self.constant.showAlertWithTitleAndMesssage("Code not sent", msg: "Please check your internet connection.")
                }
            }

            
        }
    }
    
    @IBAction func btnBackClicked(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btnNextClicked(sender: AnyObject)
    {
        vwMobileNo.hidden=true
        vwVerifyOTP.hidden=false
        vwSignUp.hidden=true
        vwLogo.hidden=true
        imgVwBG.hidden=true
    }
    
    @IBAction func btnCloseSignUpViewClicked(sender: AnyObject)
    {
        self.vwSignUp.hidden=true
        self.vwMobileNo.hidden=false
        self.vwVerifyOTP.hidden=true
        vwLogo.hidden=true
        imgVwBG.hidden=true
        
        txtFirstNAme.text = ""
        txtLastName.text = ""
        txtEmail.text = ""
        txtPassword.text = ""
        txtMonth.text = ""
        txtDay.text = ""
        txtYear.text = ""
    }
    
    @IBAction func btnResendCodeClicked(sender: AnyObject)
    {
        
        vwMobileNo.hidden=false
        vwVerifyOTP.hidden=true
        vwSignUp.hidden=true
        vwLogo.hidden=true
        imgVwBG.hidden=true
        txtPhoneNo.becomeFirstResponder()
    }
    @IBAction func btnCallMeClicked(sender: AnyObject)
    {
        vwFAQ = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 350))
        vwFAQ.backgroundColor = UIColor.whiteColor()
        var lblTitle = UILabel(frame: CGRect(x: 91, y: 20, width: 100, height: 20))
        lblTitle.text = "Need Help ?"
        var txtvw = UITextView(frame: CGRect(x: 20, y: 50, width: 260, height: 280))
        txtvw.text = "1.  I did not receive a text msg with SMS code?\nA:  Sometimes, it could take up to 60 seconds to receive your SMS code.  Also please make sure your number is correct.\n\n2.  I tried 3 times, I am still not getting the SMS code?\nA:  Please send us an email to support@mcppos.com with your full name and phone number."
        txtvw.font = UIFont.systemFontOfSize(15)
        txtvw.editable = false
        var btnRemoveFAQ : UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        btnRemoveFAQ.frame = CGRect(x: 250, y: 10, width: 40, height: 40)
        btnRemoveFAQ.setTitle("X", forState: UIControlState.Normal)
        btnRemoveFAQ.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btnRemoveFAQ.addTarget(self, action: "removeAlert", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        vwShadow.frame = self.view.bounds
        vwShadow.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        
        self.view.addSubview(vwShadow)
        
        vwFAQ.addSubview(lblTitle)
        vwFAQ.addSubview(txtvw)
        vwFAQ.addSubview(btnRemoveFAQ)
        vwFAQ.center = self.view.center
        self.view.addSubview(vwFAQ)
    }
    
    func removeAlert()
    {
        vwShadow.removeFromSuperview()
        vwFAQ.removeFromSuperview()
    }
    
    @IBAction func btnNextViewClicked(sender: AnyObject)
    {
        vwSignUp.hidden=false;
        imgVwBG.hidden=false;
        vwLogo.hidden=false;
        vwVerifyOTP.hidden=true;
        vwMobileNo.hidden=true;
    }
    
    @IBAction func btnCheckBoxClicked(sender: AnyObject)
    {
        let btn = sender as! UIButton
        btn.selected = !btn.selected
    }
    
    @IBAction func btnAgreeTandCclicked(sender: AnyObject)
    {
        
    }
    
    @IBAction func btnCreateAccountClicked(sender: AnyObject)
    {
        var msg : NSString
        
        TandC = 1
        var refCod = "0"
        
        if txtFirstNAme.text .isEmpty
        {
            msg="Please enter First Name."
            
            constant.showAlertWithTitleAndMesssage("Error!", msg: msg)
            return
        }
        else if txtLastName.text .isEmpty
        {
            msg="Please enter Last Name."
            
            constant.showAlertWithTitleAndMesssage("Error!", msg: msg)
            return
        }
        else if txtEmail.text .isEmpty
        {
            msg="Please enter e-Mail."
            
            constant.showAlertWithTitleAndMesssage("Error!", msg: msg)
            return
        }
        else if txtPassword.text .isEmpty
        {
            msg="Please enter Password."
            
            constant.showAlertWithTitleAndMesssage("Error!", msg: msg)
            return
        }
        else if txtCivilID.text .isEmpty
        {
            msg="Please enter Civil ID."
            
            constant.showAlertWithTitleAndMesssage("Error!", msg: msg)
            return
        }
        else if (txtDay.text.isEmpty || txtMonth.text.isEmpty || txtYear.text.isEmpty)
        {
            msg="Please enter date of birth properly."
            
            constant.showAlertWithTitleAndMesssage("Error!", msg: msg)
            return
        }
        else if (btnCheckBox.selected == false)
        {
            TandC = 0
            msg="To proceed, please agree to the terms and conditions."
            constant.showAlertWithTitleAndMesssage("Error!", msg: msg)
            return
        }
        
        if(txtReferralCode.text.isEmpty == false)
        {
            refCod = txtReferralCode.text
        }
        
        self.altWait.show()
        
        var urlStr : NSString = NSString(format:"%@%@%@%@",constant.baseUrl,constant.apiKey,constant.UserRegistrationService,constant.UserRegistrationMethod)
        urlStr = urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        var strparam :NSString=NSString(format:"fn=%@&ln=%@&em=%@&ph=%@%@&ps=%@&cid=%@&rid=%@&db=%@-%02d-%02d 00:00:00&lg=%d",txtFirstNAme.text,txtLastName.text,txtEmail.text,txtCountryCode.text,txtPhoneNo.text,txtPassword.text,txtCivilID.text,refCod,txtYear.text,txtMonth.text.toInt()!,txtDay.text.toInt()!,TandC)
        
        
        constant.PerformRequestwith(urlStr, strparam: strparam,methodUsed:"POST") { (data) -> () in
            
            self.altWait.dismissWithClickedButtonIndex(0, animated: true)
            if (data != nil)
            {
                var dict: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil)
                
                if (dict?.isKindOfClass(NSDictionary) == true)
                {
                    let d : NSDictionary = dict as! NSDictionary
                    
                    if(d.valueForKey("code")?.isKindOfClass(NSNull) == false)
                    {
                        if (d.valueForKey("code")?.intValue == 200)
                        {
                            println("successful")
                            self.constant.showAlertWithTitleAndMesssage("", msg: d.valueForKey("data") as! String)
                            self.getUserLogin()
                        }
                        else if (d.valueForKey("code")?.intValue == 400)
                        {
                            println(" failed")
                            if(d.valueForKey("data")?.isKindOfClass(NSNull) == true)
                            {
                                self.constant.showAlertWithTitleAndMesssage("Error!", msg: d.valueForKey("errors")?.firstObject as! NSString)
                            }
                            else
                            {
                                self.constant.showAlertWithTitleAndMesssage("Error!", msg: d.valueForKey("data") as! NSString)
                            }
                        }
                    }
                    else
                    {
                        println(" failed")
                        self.constant.showAlertWithTitleAndMesssage("Error!", msg: d.valueForKey("errors")?.firstObject as! NSString)
                    }
                }
                else
                {
                    println(" failed")
                    
                    self.constant.showAlertWithTitleAndMesssage("Check internet!", msg: "Please check your internet connection.")
                }
            }
        }
    }
    
    @IBAction func btnWhyNeddBDClicked(sender: AnyObject)
    {
        self.constant.showAlertWithTitleAndMesssage("", msg: "For your Free Birth Day Rewards.")
    }

//-----------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------AlertView Methods-----------
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int)
    {
        if alertView.tag == 1010
        {
            txtPhoneNo.resignFirstResponder()
            txtPhoneNo.becomeFirstResponder()
        }
    }
    
    
//-----------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------Custom Methods-----------

    func doneWithPicker()
    {
        currentTXT.resignFirstResponder()
    }
    
    func startTimer()
    {
        self.btnResendCode.enabled=false
        btnResendCode.setTitle(NSString(format: "Code Arriving In %d Seconds", self.timeSec) as String, forState: UIControlState.Normal)
        self.timer = NSTimer(timeInterval: 1.0, target: self, selector:"timerTick:" , userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(self.timer, forMode: NSDefaultRunLoopMode)
    }
    
    func timerTick(timer:NSTimer)
    {
        self.timeSec=self.timeSec-1
        
        btnResendCode.setTitle(NSString(format: "Code Arriving In %d Seconds", self.timeSec) as String, forState: UIControlState.Normal)
        if(timeSec == 0)
        {
            self.stopTimer()
            timeSec=60
            self.btnResendCode.enabled=true
            btnResendCode.setTitle(NSString(format: "Resend Code                            ") as String, forState: UIControlState.Normal)
        }
    }
    
    func stopTimer()
    {
        self.timer.invalidate()
        self.timeSec=60
    }
    
    func getUserLogin()
    {
        
        var urlStr : NSString = NSString(format:"%@%@%@%@",constant.baseUrl,constant.apiKey,constant.userLoginService,constant.userLoginMethod)
        urlStr = urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        var str : NSString = NSString(format: "cu=%@&cp=%@",txtEmail.text,txtPassword.text)
        
        constant.PerformRequestwith(urlStr, strparam: str,methodUsed:"POST") { (data) -> () in
            self.altWait.dismissWithClickedButtonIndex(0, animated: true)
            if (data != nil)
            {
                var dict: AnyObject?=NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil)
                if (dict?.isKindOfClass(NSDictionary) == true)
                {
                    let d : NSDictionary! = dict as! NSDictionary
                    
                    if(d.valueForKey("data")?.isKindOfClass(NSNull) == false)
                    {
                        if(d.valueForKey("data")?.isKindOfClass(NSDictionary) == true)
                        {
                            println("login successful")
                            
                            self.delegate.userDetails=d.valueForKey("data") as! NSMutableDictionary
                            
                            self.performSegueWithIdentifier("RegisterSegue", sender: self)
                        }
                    }
                    else
                    {
                        println("login failed")
                        self.constant.showAlertWithTitleAndMesssage("Login failed", msg: d.valueForKey("data") as! NSString)
                    }
                }
            }
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
