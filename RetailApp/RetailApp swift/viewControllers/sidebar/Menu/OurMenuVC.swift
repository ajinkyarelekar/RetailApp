//
//  OurMenuVC.swift
//  RetailApp swift
//
//  Created by Ajinkya's on 27/04/15.
//  Copyright (c) 2015 Ajinkya. All rights reserved.
//

import UIKit

class OurMenuVC: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    var constant = constants();
    var altWait : UIAlertView = UIAlertView(title: "", message: "Please wait...", delegate: nil, cancelButtonTitle: nil)
    
    let sideBarVC : SideBarVC = constants().storyBord.instantiateViewControllerWithIdentifier("SideBarVC") as! SideBarVC
    
    @IBOutlet var scrVwMEnu: UIScrollView!
    @IBOutlet var txtBrowsMenu: UITextField!
    @IBOutlet var vwHome: UIView!
    @IBOutlet var vwShadow: UIView!
    var isSidebarVisible = false
    var selectedCatagory : NSDictionary!
    
    @IBOutlet var tblCatagory: UITableView!
    
    var arrMenuData : NSMutableArray = NSMutableArray()
    
    var arrImgBack : NSArray = NSArray(objects:UIImage(named: "classics.jpg")!,UIImage(named: "specialty.jpg")!,UIImage(named: "blended.jpg")!,UIImage(named: "coffee.jpg")!,UIImage(named: "food.jpg")!,UIImage(named: "cheese.jpg")!)

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.getMenu()
        
        self.sideBarVC.view.frame = CGRect(x: self.view.frame.size.width + 10, y: 0, width: 200, height: self.sideBarVC.view.frame.size.height)
        self.sideBarVC.navCtrlr = self.navigationController
        self.view.addSubview(self.sideBarVC.view)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------Table Methods-----------
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrMenuData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell : MenuCell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
        
        cell.backgroundView = UIImageView(image: UIImage(named: "row.jpg"))
        
        cell.backgroundView = UIImageView(image: arrImgBack.objectAtIndex(indexPath.row % 6) as? UIImage)
        
        cell.lblCatagory.text = ""// arrMenuData.objectAtIndex(indexPath.row).valueForKey("category")?.uppercaseString //as? String
        
        return cell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.selectedCatagory = arrMenuData.objectAtIndex(indexPath.row) as! NSDictionary
        
        self.performSegueWithIdentifier("catagorymenu", sender: self)
    }
    


//-----------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------IB Actions Methods-----------

    
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
    
//-----------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------Custom Methods-----------

    
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

    
    func getMenu()
    {
        altWait.show()
        var urlStr : NSString = NSString(format:"%@%@%@%@",constant.baseUrl,constant.apiKey,constant.getMenuCatagoryServices,constant.getMenuCatagoryMethos)
        urlStr = urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        var str : NSString = NSString(format: "rid=1")
        
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
                        println("Data Found for menu catagories")
                        
                        if(d.valueForKey("data")?.isKindOfClass(NSNull) == false)
                        {
                            d = (d.valueForKey("data") as! NSDictionary)
                            
                            if(d.valueForKey("menucatorgies")?.isKindOfClass(NSNull) == false)
                            {
                                var temp = d.valueForKey("menucatorgies") as! NSArray
                                self.arrMenuData.removeAllObjects()
                                
                                self.arrMenuData.addObjectsFromArray(temp as [AnyObject])
                                
                                self.tblCatagory.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }

    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        var NextVC = segue.destinationViewController as! CatagoryWiseMenuVC
        NextVC.selectedCatagory = selectedCatagory
        NextVC.arrCatagories = self.arrMenuData as NSArray
    }
    
}
