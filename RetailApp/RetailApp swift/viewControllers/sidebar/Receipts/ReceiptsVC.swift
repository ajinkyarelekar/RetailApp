//
//  ReceiptsVC.swift
//  RetailApp swift
//
//  Created by Ajinkya's on 17/04/15.
//  Copyright (c) 2015 Ajinkya. All rights reserved.
//

import UIKit

class ReceiptsVC: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    let sideBarVC : SideBarVC = constants().storyBord.instantiateViewControllerWithIdentifier("SideBarVC") as! SideBarVC
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var constant = constants();
    var altWait : UIAlertView = UIAlertView(title: "", message: "Please wait...", delegate: nil, cancelButtonTitle: nil)
    var selectedSalesID : NSString!
    var isSidebarVisible = false
    
    @IBOutlet var veHome: UIView!
    @IBOutlet var vwShadow: UIView!

    @IBOutlet var tblReceipts: UITableView!
    
    var arrTblData : NSMutableArray! = NSMutableArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.sideBarVC.view.frame = CGRect(x: self.view.frame.size.width + 10, y: 0, width: 200, height: self.sideBarVC.view.frame.size.height)
        self.sideBarVC.navCtrlr = self.navigationController
        self.view.addSubview(self.sideBarVC.view)
        
        self.getReceipts()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
//--------------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------Table  Methods-----------

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrTblData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell : receiptsCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! receiptsCell
        
        cell.backgroundView = UIImageView(image: UIImage(named: "row.jpg"))
        
        var strdate : NSString = arrTblData.objectAtIndex(indexPath.row).valueForKey("Date_Sales") as! NSString
        
        var DF : NSDateFormatter = NSDateFormatter()
        DF.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var date : NSDate = DF.dateFromString(strdate as String)!
        DF.dateFormat = "MMM d yyyy"
        strdate = DF.stringFromDate(date)
        
        cell.lblDate.text = strdate as String
        
        cell.lblCode.text = arrTblData.objectAtIndex(indexPath.row).valueForKey("Sales_ID") as? String
        cell.lblAmmount.text = arrTblData.objectAtIndex(indexPath.row).valueForKey("Amount") as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        selectedSalesID = arrTblData.objectAtIndex(indexPath.row).valueForKey("Sales_ID") as? String
        self.performSegueWithIdentifier("receiptDetails", sender: self)
    }
    
//--------------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------Custom  Methods-----------


    func showMenuView()
    {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            var frmMen,frmhm : CGRect
            frmhm = self.veHome.frame
            frmMen = self.sideBarVC.view.frame
            
            frmMen.origin.x = self.view.frame.size.width - 200
            frmhm.origin.x = self.view.frame.origin.x - 200
            
            self.vwShadow.hidden=false
            self.vwShadow.alpha=0.7
            
            self.veHome.frame=frmhm
            self.sideBarVC.view.frame = frmMen
            
        })
    }
    
    func hideMenuView()
    {
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            var frmMen,frmhm : CGRect
            frmhm = self.veHome.frame
            frmMen = self.sideBarVC.view.frame
            
            frmhm.origin.x = 0
            frmMen.origin.x = self.view.frame.width + 10
            
            self.vwShadow.alpha=0
            self.vwShadow.hidden=true
            
            self.veHome.frame=frmhm
            self.sideBarVC.view.frame=frmMen
        })
    }

    
    func getReceipts()
    {
        var urlStr : NSString = NSString(format:"%@%@%@%@",constant.baseUrl,constant.apiKey,constant.userGetReceiptsService,constant.userGetGetReceiptsMethod)
        urlStr = urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        
        var str : NSString = NSString(format: "up=%@",self.delegate.userDetails.valueForKey("phone") as! NSString)
        
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
                        println("Data Found")
                        
                        var arr : NSArray = d.valueForKey("data")?.valueForKey("receipts") as! NSArray
                        
                        self.arrTblData.removeAllObjects()
                        
                        self.arrTblData.addObjectsFromArray(arr as [AnyObject])
                        
                        self.tblReceipts.reloadData()
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
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
        var detVC : ReceiptsDetailsVC = segue.destinationViewController as! ReceiptsDetailsVC
        detVC.selectedSalesID = selectedSalesID as String
    }
    

}
