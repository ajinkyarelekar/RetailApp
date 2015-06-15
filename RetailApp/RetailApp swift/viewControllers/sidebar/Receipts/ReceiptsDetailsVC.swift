
//
//  ReceiptsDetailsVC.swift
//  RetailApp swift
//
//  Created by Ajinkya's on 18/04/15.
//  Copyright (c) 2015 Ajinkya. All rights reserved.
//

import UIKit

class ReceiptsDetailsVC: UIViewController {
    
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var constant = constants();
    
    let sideBarVC : SideBarVC = constants().storyBord.instantiateViewControllerWithIdentifier("SideBarVC") as! SideBarVC
    var isSidebarVisible = false
    
    @IBOutlet var lblReceiptNo: UILabel!
    @IBOutlet var lblDateTime: UILabel!
    @IBOutlet var lblStoreName: UILabel!
    @IBOutlet var lblAddressLine1: UILabel!
    @IBOutlet var lblAddressLine2: UILabel!
    @IBOutlet var lblPoints: UILabel!
    @IBOutlet var lblTotal: UILabel!
    @IBOutlet var lblDiscountCharges: UILabel!
    @IBOutlet var lblNetCharges: UILabel!
    @IBOutlet var vwShadow: UIView!
    @IBOutlet var vwHome: UIView!
    
    var selectedSalesID : String!
    
    var altWait : UIAlertView = UIAlertView(title: "", message: "Please wait...", delegate: nil, cancelButtonTitle: nil)

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.getReceiptDetails()
        
        self.sideBarVC.view.frame = CGRect(x: self.view.frame.size.width + 10, y: 0, width: 200, height: self.sideBarVC.view.frame.size.height)
        self.sideBarVC.navCtrlr = self.navigationController
        self.view.addSubview(self.sideBarVC.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//-----------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------IB Actions  Methods-----------


    @IBAction func btnMenuClicked(sender: AnyObject)
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
    
    
//-----------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------Custom  Methods-----------

    
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

    
    func getReceiptDetails()
    {
        var urlStr : NSString = NSString(format:"%@%@%@%@",constant.baseUrl,constant.apiKey,constant.userGetReceiptDetailsService,constant.userGetGetReceiptDetailsMethod)
        urlStr = urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        
        var str : NSString = NSString(format: "sid=%@",self.selectedSalesID)
        
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
                        println("Data Found receipt details")
                        
                        var d1 : NSDictionary = d.valueForKey("data")!.valueForKey("receipt_details")?.firstObject as! NSDictionary
                        
                        self.lblReceiptNo.text = "RECEIPT " + self.selectedSalesID
                        
                        var strdate : NSString = d1.valueForKey("dateordered") as! NSString
                        
                        var DF : NSDateFormatter = NSDateFormatter()
                        DF.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        var date : NSDate = DF.dateFromString(strdate as String)!
                        DF.dateFormat = "MMM d yyyy - hh:mm a"
                        strdate = DF.stringFromDate(date)
                        
                        self.lblDateTime.text = strdate as String
                        self.lblStoreName.text = d1.valueForKey("storename") as? String
                        self.lblAddressLine1.text = d1.valueForKey("address1") as? String
                        
                        if(d1.valueForKey("address2")?.isKindOfClass(NSNull) == false)
                        {
                            self.lblAddressLine2.text = d1.valueForKey("address2") as? String
                        }
                        
                        if(d1.valueForKey("pointsearned")?.isKindOfClass(NSNull) == false)
                        {
                            self.lblPoints.text = NSString(format: "Points Earned: %@",d1.valueForKey("pointsearned") as! NSString) as String
                        }
                        
                        if(d1.valueForKey("totalcharge")?.isKindOfClass(NSNull) == false)
                        {
                            self.lblTotal.text = NSString(format: "Total: %@ ",d1.valueForKey("totalcharge") as! NSString) as String
                        }
                        
                        if(d1.valueForKey("currency")?.isKindOfClass(NSNull) == false)
                        {
                            self.lblTotal.text = self.lblTotal.text! +  (NSString(format: "%@",d1.valueForKey("currency") as! NSString) as String) as String
                        }
                        if(d1.valueForKey("discountamount")?.isKindOfClass(NSNull) == false)
                        {
                            self.lblDiscountCharges.text = NSString(format: "Discount Amount: %@",d1.valueForKey("discountamount") as! NSString) as String
                        }
                        if(d1.valueForKey("netcharge")?.isKindOfClass(NSNull) == false)
                        {
                            self.lblNetCharges.text = NSString(format: "Net Charge: %@",d1.valueForKey("netcharge") as! NSString) as String
                        }
                    }
                    else
                    {
                        println("Data not found")
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
