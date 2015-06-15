//
//  CountryCodesVC.swift
//  RetailApp swift
//
//  Created by Ajinkya's on 07/04/15.
//  Copyright (c) 2015 Ajinkya. All rights reserved.
//

import UIKit

class CountryCodesVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate
{
    @IBOutlet var serchCountry: UISearchBar!
    @IBOutlet var tblCodes: UITableView!
    
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var arrCountries : NSArray!
    var arrFilteredCountries : NSMutableArray!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        var filePath : NSString = NSBundle.mainBundle().pathForResource("countrycodes", ofType: "json")!
        
        var data : NSData = NSData .dataWithContentsOfMappedFile(filePath as String) as! NSData
        
        arrCountries = NSArray()
        arrCountries = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSArray
        
        arrFilteredCountries = NSMutableArray(array: arrCountries)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//--------------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------IBActions Methods-----------

    
    @IBAction func btnBAckClicked(sender: AnyObject)
    {
        if let navController = self.navigationController
        {
            navController.popViewControllerAnimated(true)
        }
    }
    
//--------------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------Table view  Methods-----------

    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       return arrFilteredCountries.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.contentView.viewWithTag(100)?.removeFromSuperview()
        cell.contentView.viewWithTag(101)?.removeFromSuperview()
        
        var lblName,lblCode : UILabel
        
        lblName=UILabel(frame: CGRectMake(8, 8, 175, 25))
        lblName.text = arrFilteredCountries .objectAtIndex(indexPath.row).valueForKey("name") as? String
        lblName.tag = 100
        
        lblCode=UILabel(frame: CGRectMake(252, 8, 60, 25))
        lblCode.text = arrFilteredCountries .objectAtIndex(indexPath.row).valueForKey("phone-code") as? String
        lblCode.tag=101
        lblCode.textAlignment=NSTextAlignment.Right
        
        cell.contentView.addSubview(lblName)
        cell.contentView.addSubview(lblCode)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        delegate.countryCode=arrFilteredCountries .objectAtIndex(indexPath.row).valueForKey("phone-code") as! NSString
        delegate.countryName=arrFilteredCountries .objectAtIndex(indexPath.row).valueForKey("name") as! NSString
        self.navigationController?.popViewControllerAnimated(true)
    }
    
//--------------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------SearchBar  Methods-----------

    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "")
        {
            arrFilteredCountries.removeAllObjects()
            arrFilteredCountries.addObjectsFromArray(arrCountries! as [AnyObject])
        }
        return true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        let SerchT : NSString = searchText as NSString
        if (SerchT.length<3)
        {
            arrFilteredCountries.removeAllObjects()
            arrFilteredCountries.addObjectsFromArray(arrCountries! as [AnyObject])
            tblCodes.reloadData()
            return;
        }
        
        for d in arrFilteredCountries
        {
            var dict : NSDictionary = d as! NSDictionary
            
            var str : NSString = d .valueForKey("name") as! NSString
    
            str = str.substringToIndex(SerchT.length)
            if(str .caseInsensitiveCompare(searchText) == NSComparisonResult.OrderedSame)//(str .isEqualToString(searchText))
            {
                continue
            }
            else
            {
                arrFilteredCountries .removeObject(d)
            }
        }
        
        tblCodes.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
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
