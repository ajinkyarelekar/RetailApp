//
//  PayNowVC.swift
//  RetailApp swift
//
//  Created by Ajinkya's on 15/05/15.
//  Copyright (c) 2015 Ajinkya. All rights reserved.
//

import UIKit

class PayNowVC: UIViewController,UITextFieldDelegate
{
    var constant = constants();
    var altWait : UIAlertView = UIAlertView(title: "", message: "Please wait...", delegate: nil, cancelButtonTitle: nil)
    
    let sideBarVC : SideBarVC = constants().storyBord.instantiateViewControllerWithIdentifier("SideBarVC") as! SideBarVC

    @IBOutlet var lblPoints: UILabel!
    @IBOutlet var lblValue: UILabel!
    @IBOutlet var lblCurrency: UILabel!
    @IBOutlet var lblBalence: UILabel!
    @IBOutlet var imgCheckBox: UIImageView!
    
    @IBOutlet var vwShadow: UIView!
    @IBOutlet var vwHome: UIView!
    @IBOutlet var vwPay: UIView!
    @IBOutlet var txtConfirmationCode: UITextField!
    @IBOutlet var vwPhoneOrder: UIView!
    
    var isSidebarVisible = false
    var isPayByPointsSelected = false
    var isPhoneOrderSelectede = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.sideBarVC.view.frame = CGRect(x: self.view.frame.size.width + 10, y: 0, width: 200, height: self.sideBarVC.view.frame.size.height)
        self.sideBarVC.navCtrlr = self.navigationController
        self.view.addSubview(self.sideBarVC.view)
        
        self.getDetails()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------textField Methods-----------
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return false
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------IB Actions Methods-----------

    @IBAction func btnReloadClicked(sender: AnyObject)
    {
    }
    @IBAction func btnPayWithPointsClicked(sender: AnyObject)
    {
        if(isPayByPointsSelected == false)
        {
            imgCheckBox.image = UIImage(named: "payCheck.png")
        }
        else
        {
            imgCheckBox.image = UIImage(named: "payUncheck.png")
        }
        
        isPayByPointsSelected = !isPayByPointsSelected
    }
    
    @IBAction func btnPayNowClicked(sender: AnyObject)
    {
        if(isPhoneOrderSelectede == false)
        {
            self.vwShadow.alpha = 0.7
            vwShadow.hidden = false
            vwPay.hidden = false
        }
        else
        {
            self.performSegueWithIdentifier("paymentSegue", sender: self)
        }
    }
    
    @IBAction func btnMenuClikced(sender: AnyObject)
    {
        if isSidebarVisible == true
        {
            self.hideMenuView()
        }
        else
        {
            self.showMenuView()
        }
        isSidebarVisible = !isSidebarVisible
    }
    
    @IBAction func btnPayInStoreClicked(sender: AnyObject)
    {
        self.performSegueWithIdentifier("paymentSegue", sender: self)
    }
    
    @IBAction func btnPayForPhoneOrderClicked(sender: AnyObject)
    {
        vwPay.hidden = true
        vwPhoneOrder.hidden = false
        isPhoneOrderSelectede = true
    }

    @IBAction func btnCloseClicked(sender: AnyObject)
    {
        vwPay.hidden = true
        vwPhoneOrder.hidden = true
        vwShadow.hidden = true
        self.vwShadow.alpha = 0
        isPhoneOrderSelectede = false
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------Custom Methods-----------
    
    func getBalance()
    {
        altWait.show()
        var urlStr : NSString = NSString(format:"%@%@%@%@",constant.baseUrl,constant.apiKey,constant.PayRequestServices,constant.PayRequestMethod)
        urlStr = urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        var str : NSString = NSString(format: "up=%@",constant.delegate.userDetails.valueForKey("phone") as! String)
        
        constant.PerformRequestwith(urlStr, strparam: str,methodUsed:"POST") { (data) -> () in
            self.altWait.dismissWithClickedButtonIndex(0, animated: true)
            if (data != nil)
            {
                var dict: AnyObject?=NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil)
                if (dict?.isKindOfClass(NSDictionary) == true)
                {
                    var d : NSDictionary = dict as! NSDictionary
                    
                    if(d.valueForKey("code")?.intValue == 200)
                    {
                        if (d.valueForKey("data")!.isKindOfClass(NSDictionary) == true)
                        {
                            d = d.valueForKey("data") as! NSDictionary
                        }
                        
                    }
                }
            }
        }
    }
    
    func showMenuView()
    {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            var frmMen,frmhm : CGRect
            frmhm = self.vwHome.frame
            frmMen = self.sideBarVC.view.frame
            
            frmMen.origin.x = self.view.frame.size.width - 200
            frmhm.origin.x = self.view.frame.origin.x - 200
            
            self.vwShadow.hidden=false
            self.vwShadow.alpha=0.7
            
            self.vwHome.frame=frmhm
            self.sideBarVC.view.frame = frmMen
            
        })
    }
    
    func hideMenuView()
    {
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            var frmMen,frmhm : CGRect
            frmhm = self.vwHome.frame
            frmMen = self.sideBarVC.view.frame
            
            frmhm.origin.x = 0
            frmMen.origin.x = self.view.frame.width + 10
            
            self.vwShadow.alpha=0
            self.vwShadow.hidden=true
            
            self.vwHome.frame=frmhm
            self.sideBarVC.view.frame=frmMen
        })
    }
    
    func getDetails()
    {
        self.altWait.show()
        var urlStr : NSString = NSString(format:"%@%@/paynow/verify.json",constant.baseUrl,constant.apiKey)
        urlStr = urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        var str = ""
        
        var strparam :NSString=NSString(format:"up=%@", str)
        
        
        constant.PerformRequestwith(urlStr, strparam: strparam,methodUsed:"POST") { (data) -> () in
            
            self.altWait.dismissWithClickedButtonIndex(0, animated: true)
            
            if (data != nil)
            {
                var dict: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil)
                
                if (dict?.isKindOfClass(NSDictionary) == true)
                {
                    let d : NSDictionary = dict as! NSDictionary
                    println("\(d)")
                }
            }
        }

    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "paymentSegue")
        {
            var nextVC : PaymentVC = segue.destinationViewController as! PaymentVC
            nextVC.isPhoneOrderSelectede = isPhoneOrderSelectede
        }
    }
    

}
