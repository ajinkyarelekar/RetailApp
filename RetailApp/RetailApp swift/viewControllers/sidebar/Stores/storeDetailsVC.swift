//
//  storeDetailsVC.swift
//  RetailApp swift
//
//  Created by Ajinkya's on 21/04/15.
//  Copyright (c) 2015 Ajinkya. All rights reserved.
//

import UIKit
import MapKit

class storeDetailsVC: UIViewController,MKMapViewDelegate,UIAlertViewDelegate
{
    
    var constant = constants();
    var altWait : UIAlertView = UIAlertView(title: "", message: "Please wait...", delegate: nil, cancelButtonTitle: nil)
    
    var StoreCode : NSString!
    var distance : NSString!

    @IBOutlet var lblStoreName: UILabel!
    @IBOutlet var mapViewStore: MKMapView!
    @IBOutlet var txtVwAddress: UITextView!
    @IBOutlet var lblDistance: UILabel!
    @IBOutlet var lblPhone: UILabel!
    @IBOutlet var lblMondayWH: UILabel!
    @IBOutlet var lbltuesdayWH: UILabel!
    @IBOutlet var lblWednesdayWH: UILabel!
    @IBOutlet var lblThursdayWH: UILabel!
    @IBOutlet var lblFridayWH: UILabel!
    @IBOutlet var lblSaturdaydayWH: UILabel!
    @IBOutlet var lblSundayWH: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getStoreDetails()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackClicked(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
//--------------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------IB Actions Methods-----------

    
    @IBAction func btnCallClicked(sender: AnyObject)
    {
        var altCall: UIAlertView = UIAlertView()
        
        altCall.delegate = self
        altCall.tag = 123
        
        altCall.title = self.lblPhone.text!
        altCall.addButtonWithTitle("Cancel")
        altCall.addButtonWithTitle("Call")
        altCall.show()
    }

    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)
    {
        if(alertView.tag == 123)
        {
            if(buttonIndex == 0)
            {
                alertView.dismissWithClickedButtonIndex(buttonIndex, animated: true)
            }
            else
            {
                UIApplication.sharedApplication().openURL(NSURL(string: "tel://" + self.lblPhone.text!)!)
            }
        }
    }

//--------------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------Custom Methods-----------

    
    func getStoreDetails()
    {
        var urlStr : NSString = NSString(format:"%@%@%@%@",constant.baseUrl,constant.apiKey,constant.getStoreDetailsServices,constant.getStoreDetailsMethos)
        urlStr = urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        var str : NSString = NSString(format: "sc=%@",self.StoreCode)
        
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
                        var arrTemp : NSArray = d.valueForKey("data")?.valueForKey("store_details") as! NSArray
                        
                        if (arrTemp.count > 0)
                        {
                            println("store details Data Found")
                            
                            d = arrTemp.firstObject as! NSDictionary
                            
                            var sName = d.valueForKey("storename") as! String
                            
                            self.lblStoreName.text = sName.capitalizedString
                            
                            if(d.valueForKey("address1")?.isKindOfClass(NSNull) == false)
                            {
                                self.txtVwAddress.text = d.valueForKey("address1") as! String + "\n"
                            }
                            if(d.valueForKey("address2")?.isKindOfClass(NSNull) == false)
                            {
                                self.txtVwAddress.text = self.txtVwAddress.text + (d.valueForKey("address2") as! String) + "\n"
                            }
                            if(d.valueForKey("address3")?.isKindOfClass(NSNull) == false)
                            {
                                self.txtVwAddress.text = self.txtVwAddress.text + (d.valueForKey("address3") as! String) + "\n"
                            }
                            if(d.valueForKey("city")?.isKindOfClass(NSNull) == false)
                            {
                                self.txtVwAddress.text = self.txtVwAddress.text + (d.valueForKey("city") as! String) + "\n"
                            }
                            if(d.valueForKey("province")?.isKindOfClass(NSNull) == false)
                            {
                                self.txtVwAddress.text = self.txtVwAddress.text + (d.valueForKey("province") as! String) + "\n"
                            }
                            if(d.valueForKey("postal")?.isKindOfClass(NSNull) == false)
                            {
                                self.txtVwAddress.text = self.txtVwAddress.text + (d.valueForKey("postal") as! String) + "\n"
                            }
                            if(d.valueForKey("country")?.isKindOfClass(NSNull) == false)
                            {
                                self.txtVwAddress.text = self.txtVwAddress.text + (d.valueForKey("country") as! String)
                            }
                            
                            self.lblDistance.text = NSString(format: "%.2f km",self.distance.floatValue ) as String
                            
                            if(d.valueForKey("opentime")?.isKindOfClass(NSNull) == false)
                            {
                                self.lblMondayWH.text = (d.valueForKey("opentime") as? String)! + " - "
                                self.lbltuesdayWH.text = self.lblMondayWH.text
                                self.lblWednesdayWH.text = self.lblMondayWH.text
                                self.lblThursdayWH.text = self.lblMondayWH.text
                                self.lblFridayWH.text = self.lblMondayWH.text
                                self.lblSaturdaydayWH.text = self.lblMondayWH.text
                                self.lblSundayWH.text = self.lblMondayWH.text
                            }
                            
                            if(d.valueForKey("closetime")?.isKindOfClass(NSNull) == false)
                            {
                                self.lblMondayWH.text = self.lblMondayWH.text! + (d.valueForKey("closetime") as? String)!
                                self.lbltuesdayWH.text = self.lblMondayWH.text
                                self.lblWednesdayWH.text = self.lblMondayWH.text
                                self.lblThursdayWH.text = self.lblMondayWH.text
                                self.lblFridayWH.text = self.lblMondayWH.text
                                self.lblSaturdaydayWH.text = self.lblMondayWH.text
                                self.lblSundayWH.text = self.lblMondayWH.text
                            }
                            
                            self.lblPhone.text = d.valueForKey("phone") as? String
                            
                            var lat : NSString = NSString(format:"%@",d.valueForKey("lat") as! String)
                            var long : NSString = NSString(format:"%@",d.valueForKey("lng") as! String)
                            
                            var lat1 : CLLocationDegrees = lat.doubleValue
                            var long1 : CLLocationDegrees = long.doubleValue
                            let LOC : CLLocation = CLLocation(latitude: lat1, longitude: long1)
                            
                            var latDelta:CLLocationDegrees = 0.01
                            var longDelta:CLLocationDegrees = 0.01
                            var theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
                            var theRegion:MKCoordinateRegion = MKCoordinateRegionMake(LOC.coordinate, theSpan)
                            self.mapViewStore.setRegion(theRegion, animated: true)
                            
                            var anot : MKPointAnnotation = MKPointAnnotation()
                            anot.coordinate = LOC.coordinate
                            anot.title = sName.capitalizedString
                            self.mapViewStore.addAnnotation(anot)
                        }
                        else
                        {
                            println("No Data Found")
                        }
                    }
                }
            }
        }
    }
    
//--------------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------MapView Methods-----------

    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView!
    {
//        if (annotation is MKUserLocation)
//        {
//            //if annotation is not an MKPointAnnotation (eg. MKUserLocation),
//            //return nil so map draws default view for it (eg. blue dot)...
//            return nil
//        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView.image = UIImage(named:"green.png")
            anView.canShowCallout = true
        }
        else {
            //we are re-using a view, update its annotation reference...
            anView.annotation = annotation
        }
        
        return anView
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
