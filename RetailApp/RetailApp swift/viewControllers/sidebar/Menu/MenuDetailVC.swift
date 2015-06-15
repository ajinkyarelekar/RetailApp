//
//  MenuDetailVC.swift
//  RetailApp swift
//
//  Created by Ajinkya's on 14/05/15.
//  Copyright (c) 2015 Ajinkya. All rights reserved.
//

import UIKit

class MenuDetailVC: UIViewController
{
    
    var constant = constants();
    var altWait : UIAlertView = UIAlertView(title: "", message: "Please wait...", delegate: nil, cancelButtonTitle: nil)
    
    @IBOutlet var imgMenuItem: UIImageView!
    @IBOutlet var lblMenuName: UILabel!
    @IBOutlet var txtvwDescription: UITextView!
    @IBOutlet var lblIngredients: UILabel!
    @IBOutlet var txtVwAdditionalText: UITextView!
    
    var selectedSKU : String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getMenuDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------IB Actions Methods-----------
    
    @IBAction func btnBackClicked(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------Custom Methods-----------
    
    func getMenuDetails()
    {
        altWait.show()
        var urlStr : NSString = NSString(format:"%@%@%@%@",constant.baseUrl,constant.apiKey,constant.getMenuDetailsServices,constant.getMenuDetailsMethos)
        urlStr = urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        var str : NSString = NSString(format: "skuid=%@",selectedSKU)
        
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
                        println("Data Found for menu details")
                        
                        d = d.valueForKey("data")!.valueForKey("itemdetail")?.firstObject as! NSDictionary
                        
                        var actLoading : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
                        
                        actLoading.startAnimating()
                        
                        var urlStr : String = d.valueForKey("itemdetailimg") as! String
                        
                        var req : NSURLRequest = NSURLRequest(URL: NSURL(string: urlStr)!)
                        
                        NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue.mainQueue(), completionHandler: { (res, data, err) -> Void in
                            if(data != nil)
                            {
                                self.imgMenuItem.image = UIImage(data:data!)
                            }
                            actLoading.stopAnimating()
                        })
                        
                        self.lblMenuName.text = d.valueForKey("item") as? String
                        self.txtvwDescription.text = d.valueForKey("description") as? String
                        self.lblIngredients.text = d.valueForKey("description") as? String
                        self.txtVwAdditionalText.text = ""
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
