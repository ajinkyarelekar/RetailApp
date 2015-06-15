//
//  StoresVC.swift
//  RetailApp swift
//
//  Created by Ajinkya's on 20/04/15.
//  Copyright (c) 2015 Ajinkya. All rights reserved.
//

import UIKit
import CoreLocation

class StoresVC: UIViewController,CLLocationManagerDelegate
{
    let sideBarVC : SideBarVC = constants().storyBord.instantiateViewControllerWithIdentifier("SideBarVC") as! SideBarVC
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var constant = constants();
    var altWait : UIAlertView = UIAlertView(title: "", message: "Please wait...", delegate: nil, cancelButtonTitle: nil)
    var selectedStoreID : NSString!
    var distance : NSString!
    
    let locoMan : CLLocationManager = CLLocationManager()
    var userLoc : CLLocation = CLLocation()
    var isStoresLoaded = false
    var isSidebarVisible = false
    
    @IBOutlet var tblStores: UITableView!
    @IBOutlet var vwHome: UIView!
    @IBOutlet var vwShadow: UIView!
    
    var arrTblData : NSMutableArray! = NSMutableArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        if CLLocationManager.authorizationStatus() == .NotDetermined
        {
            locoMan.requestAlwaysAuthorization()
        }
        
        // Do any additional setup after loading the view.
        locoMan.delegate = self
        
        if CLLocationManager.locationServicesEnabled()
        {
            locoMan.startUpdatingLocation()
        }
        else
        {
            constant.showAlertWithTitleAndMesssage("Location Services Disabled", msg: "Please enable location services for the app.")
        }
        
        self.sideBarVC.view.frame = CGRect(x: self.view.frame.size.width + 10, y: 0, width: 200, height: self.sideBarVC.view.frame.size.height)
        self.sideBarVC.navCtrlr = self.navigationController
        self.view.addSubview(self.sideBarVC.view)
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
    //MARK: -----------Location Manager Delegates  Methods-----------


    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
         var locationArray = locations as NSArray
        userLoc = locationArray.firstObject as! CLLocation
        
        if(isStoresLoaded == false)
        {
            isStoresLoaded = true
            self.getStores()
        }
        
        locoMan.stopUpdatingLocation()
    }
    
    
//--------------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------Table Methods-----------

    
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
        var cell : StoreLocatorCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! StoreLocatorCell
        
        cell.backgroundView = UIImageView(image: UIImage(named: "row.jpg"))
        
        cell.lblName.text = arrTblData.objectAtIndex(indexPath.row).valueForKey("storename") as? String
        var dist : NSString = NSString(format:"%@",arrTblData.objectAtIndex(indexPath.row).valueForKey("distance") as! String)
        
        cell.lblDistance.text = NSString(format: "%.2f km",dist.floatValue ) as String
        var lat : NSString = NSString(format:"%@",arrTblData.objectAtIndex(indexPath.row).valueForKey("lat") as! String)
        var long : NSString = NSString(format:"%@",arrTblData.objectAtIndex(indexPath.row).valueForKey("lng") as! String)

        let geocoder : CLGeocoder = CLGeocoder()
        var lat1 : CLLocationDegrees = lat.doubleValue
        var long1 : CLLocationDegrees = long.doubleValue
        let LOC : CLLocation = CLLocation(latitude: lat1, longitude: long1)
        
        if(arrTblData.objectAtIndex(indexPath.row).valueForKey("address1")?.isKindOfClass(NSNull) == false)
        {
            cell.lblAddrs.text = arrTblData.objectAtIndex(indexPath.row).valueForKey("address1") as? String
        }
        if(arrTblData.objectAtIndex(indexPath.row).valueForKey("city")?.isKindOfClass(NSNull) == false)
        {
            cell.lblCity.text = arrTblData.objectAtIndex(indexPath.row).valueForKey("city") as? String
        }
        
        cell.lblTime.text = NSString(format: "%@ - %@",arrTblData.objectAtIndex(indexPath.row).valueForKey("opentime") as! NSString,arrTblData.objectAtIndex(indexPath.row).valueForKey("closetime") as! NSString) as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        selectedStoreID = arrTblData.objectAtIndex(indexPath.row).valueForKey("storecode") as? String
        distance = arrTblData.objectAtIndex(indexPath.row).valueForKey("distance") as! String
        self.performSegueWithIdentifier("storeDetails", sender: self)
    }
    
//--------------------------------------------------------------------------------------------------------------------------------------
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

    
    func getStores()
    {
        var urlStr : NSString = NSString(format:"%@%@%@%@",constant.baseUrl,constant.apiKey,constant.getStoresServices,constant.getStoresMethos)
        urlStr = urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        var str : NSString = NSString(format: "lat=%f&lng=%f",userLoc.coordinate.latitude ,userLoc.coordinate.longitude)
        
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
                        
                        var arr : NSArray = d.valueForKey("data")?.valueForKey("stores") as! NSArray
                        
                        self.arrTblData.removeAllObjects()
                        
                        self.arrTblData.addObjectsFromArray(arr as [AnyObject])
                        
                        self.tblStores.reloadData()
                        
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
        
        var detVC : storeDetailsVC = segue.destinationViewController as! storeDetailsVC
        detVC.StoreCode = selectedStoreID
        detVC.distance = distance
    }
    
    
}
