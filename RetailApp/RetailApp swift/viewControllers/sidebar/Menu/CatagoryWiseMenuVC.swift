//
//  CatagoryWiseMenuVC.swift
//  RetailApp swift
//
//  Created by Ajinkya's on 14/05/15.
//  Copyright (c) 2015 Ajinkya. All rights reserved.
//

import UIKit

class CatagoryWiseMenuVC: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    var constant = constants();
    var altWait : UIAlertView = UIAlertView(title: "", message: "Please wait...", delegate: nil, cancelButtonTitle: nil)
    
    let sideBarVC : SideBarVC = constants().storyBord.instantiateViewControllerWithIdentifier("SideBarVC") as! SideBarVC
    
    @IBOutlet var scrVwMEnu: UIScrollView!
    @IBOutlet var txtBrowsMenu: UITextField!
    @IBOutlet var vwHome: UIView!
    @IBOutlet var vwShadow: UIView!
    @IBOutlet var tblCatagories: UITableView!
    var isSidebarVisible = false
    var selectedCatagory : NSDictionary!
    var arrCatagories : NSArray!
    var selectedSKU : Int!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.txtBrowsMenu.text = selectedCatagory.valueForKey("category") as! String
        
        self.getMenu()
        
        self.sideBarVC.view.frame = CGRect(x: self.view.frame.size.width + 10, y: 0, width: 200, height: self.sideBarVC.view.frame.size.height)
        self.sideBarVC.navCtrlr = self.navigationController
        self.view.addSubview(self.sideBarVC.view)
        
        tblCatagories.backgroundView = UIImageView(image: UIImage(named: "Appbg.jpg"))
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------Table View Methods-----------
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrCatagories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("catCell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = arrCatagories.objectAtIndex(indexPath.row).valueForKey("category") as? String
        
        cell.textLabel?.textColor = UIColor(red: 44/255, green: 27/255, blue: 0, alpha: 1.0)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.hidden = true
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.selectedCatagory = arrCatagories.objectAtIndex(indexPath.row) as! NSDictionary
        
        self.txtBrowsMenu.text = selectedCatagory.valueForKey("category") as! String
        
        for view in self.scrVwMEnu.subviews
        {
            view.removeFromSuperview()
        }
        
        self.getMenu()
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------IB Actions Methods-----------
    
    @IBAction func btnCatogaroiesClicked(sender: AnyObject)
    {
        tblCatagories.hidden = false
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
    
    func btnMenuDetailClicked(sender:UIButton)
    {
        selectedSKU = sender.tag
        self.performSegueWithIdentifier("menudetail", sender: self)
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
        var urlStr : NSString = NSString(format:"%@%@%@%@",constant.baseUrl,constant.apiKey,constant.getMenuServices,constant.getMenuMethos)
        urlStr = urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        var str : NSString = NSString(format: "catid=%@&rid=1",selectedCatagory.valueForKey("id") as! String)
        
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
                        println("Data Found for Catagory wise menu")
                        
                        if(d.valueForKey("data")?.isKindOfClass(NSNull) == false)
                        {
                            d = (d.valueForKey("data") as! NSDictionary)
                            
                            if(d.valueForKey("submenu")?.isKindOfClass(NSNull) == false)
                            {
                                var arrMenu = d.valueForKey("submenu") as! NSArray
                                if(arrMenu.count != 0)
                                {
                                    var yValue : CGFloat = 0
                                    var xValue : CGFloat = 0
                                    for d1  in arrMenu
                                    {
                                        var vwTemp : UIView = UIView()
                                        var imgMenu : UIImageView = UIImageView()
                                        var lblName : UILabel = UILabel()
                                        var actLoading : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
                                        
                                        lblName.textColor = UIColor.whiteColor()
                                        lblName.text = d1.valueForKey("item") as? String
                                        
                                        if(yValue == 0)//(d1.valueForKey("displayorder")?.intValue == 0)
                                        {
                                            vwTemp.frame = CGRect(x: xValue, y: yValue, width: self.view.frame.size.width, height: 175)
                                            imgMenu.frame = vwTemp.bounds
                                            lblName.frame = CGRect(x: 22, y: 130, width: 276, height: 33)
                                            lblName.font = UIFont.boldSystemFontOfSize(21)
                                            yValue = yValue + vwTemp.frame.size.height
                                        }
                                        else
                                        {
                                            vwTemp.frame = CGRect(x: xValue, y: yValue, width: self.view.frame.size.width / 2, height: 138)
                                            imgMenu.frame = vwTemp.bounds
                                            lblName.frame = CGRect(x: 16, y: 110, width: 124, height: 20)
                                            lblName.font = UIFont.boldSystemFontOfSize(13)
                                            
                                            xValue = xValue + vwTemp.frame.size.width
                                            
                                            if(xValue >= self.view.frame.size.width)
                                            {
                                                xValue = 0
                                                yValue = yValue + vwTemp.frame.size.height
                                            }
                                        }
                                        
                                        var urlStr : String = d1.valueForKey("imglocation") as! String
                                        
                                        var req : NSURLRequest = NSURLRequest(URL: NSURL(string: urlStr)!)
                                        
                                        NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue.mainQueue(), completionHandler: { (res, data, err) -> Void in
                                            if(data != nil)
                                            {
                                                imgMenu.image = UIImage(data:data!)
                                            }
                                            actLoading.stopAnimating()
                                        })
                                        vwTemp.addSubview(imgMenu)
                                        vwTemp.addSubview(lblName)
                                        
                                        var btn : UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
                                        btn.frame = vwTemp.bounds
                                        btn.tag = Int(d1.valueForKey("sku")!.intValue)
                                        btn.addTarget(self, action: "btnMenuDetailClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                                        
                                        vwTemp.addSubview(btn)
                                        
                                        actLoading.center = imgMenu.center
                                        imgMenu.addSubview(actLoading)
                                        actLoading.startAnimating()
                                        
                                        self.scrVwMEnu.addSubview(vwTemp)
                                    }
                                    
                                    self.scrVwMEnu.contentSize = CGSize(width: self.view.frame.width, height: yValue)
                                }
                                
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
        var nextVC : MenuDetailVC = segue.destinationViewController as! MenuDetailVC
        nextVC.selectedSKU = "\(selectedSKU)"
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    
    
}
