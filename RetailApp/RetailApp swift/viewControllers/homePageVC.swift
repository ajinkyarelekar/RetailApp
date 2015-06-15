//
//  homePageVC.swift
//  RetailApp swift
//
//  Created by Ajinkya's on 27/03/15.
//  Copyright (c) 2015 Ajinkya. All rights reserved.
//

import UIKit
import MessageUI

class homePageVC: UIViewController,SideBarVCDelegates,UIAlertViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate
{
    let sideBarVC : SideBarVC = constants().storyBord.instantiateViewControllerWithIdentifier("SideBarVC") as! SideBarVC
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var constant = constants();
    var altWait : UIAlertView = UIAlertView(title: "", message: "Please wait...", delegate: nil, cancelButtonTitle: nil)
    
    let arrTopics = ["Service","App Experience","My Account","Login","Registration","General Inquiry","Other"]

    @IBOutlet var vwHome: UIView!
    @IBOutlet var vwSideBar: UIView!
    @IBOutlet var vwShadow: UIView!
    @IBOutlet var lblWelcomeName: UILabel!
    @IBOutlet var vwOrderPopup: UIView!
    @IBOutlet var btnMenu: UIButton!
    
    @IBOutlet var lblBalence: UILabel!
    @IBOutlet var lblPoints: UILabel!
    
    @IBOutlet var vwRefer: UIView!
    @IBOutlet var vwContactUs: UIView!
    @IBOutlet var txtSelectTopic: UITextField!
    @IBOutlet var txtvwMsg: UITextView!
    @IBOutlet var tblTopics: UITableView!
    
    var isSidebarVisible : Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.vwShadow.alpha=0;
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Appbg.jpg")!)
        self.sideBarVC.view.frame = CGRect(x: self.view.frame.size.width+10, y: 0, width: 200, height: self.sideBarVC.view.frame.size.height)
        self.sideBarVC.navCtrlr = self.navigationController
        self.sideBarVC.delegate = self
        self.view.addSubview(self.sideBarVC.view)
        
    }
    override func viewWillAppear(animated: Bool)
    {
        self.lblWelcomeName.text = NSString(format: "Welcome %@!", self.delegate.userDetails.valueForKey("firstname") as! NSString) as String
        self.getPoints()
        
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidDisappear(animated: Bool)
    {
        self.hideMenuView()
        isSidebarVisible = false
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------Tableview Methods-----------
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTopics.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("topicCell") as! UITableViewCell
        cell.textLabel?.text = arrTopics[(indexPath.row)]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        tblTopics.hidden = true
        txtSelectTopic.text = arrTopics[indexPath.row]
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------TextField Methods-----------
    
    override func disablesAutomaticKeyboardDismissal() -> Bool {
        return false
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == txtSelectTopic
        {
            tblTopics.reloadData()
            tblTopics.hidden = false
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView)
    {
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: 0, y: -230, width: self.view.frame.size.width, height: self.view.frame.size.height)
        })
        
    }
    
    func textViewDidEndEditing(textView: UITextView)
    {
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        })
    }
//-----------------------------------------------------------------------------------------------------------------------------------
    //MARK: -----------IBactions Methods-----------
   
    @IBAction func btnSubmitContactUsMessageClicked(sender: AnyObject)
    {
        
        if txtSelectTopic.text.isEmpty
        {
            self.constant.showAlertWithTitleAndMesssage("Please select a topic!", msg: "Please select a topic to send feedback.")
            return
        }
        else if txtvwMsg.text.isEmpty
        {
            self.constant.showAlertWithTitleAndMesssage("Please enter message!", msg: "Please enter a message to send feedback.")
            return
        }
        altWait.show()
        var urlStr : NSString = NSString(format:"%@%@%@%@",constant.baseUrl,constant.apiKey,constant.ContactUsServices,constant.ContactUsMethos)
        urlStr = urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        var str : NSString = NSString(format: "topic=%@&message=%@",self.txtSelectTopic.text,txtvwMsg.text)
        
        txtSelectTopic.text = ""
        txtvwMsg.text = ""
        
        txtvwMsg.resignFirstResponder()
        constant.PerformRequestwith(urlStr, strparam: str,methodUsed:"POST") { (data) -> () in
            self.altWait.dismissWithClickedButtonIndex(0, animated: true)
            if (data != nil)
            {
                self.btnCloseContactUs(UIButton())
                var dict: AnyObject?=NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil)
                if (dict?.isKindOfClass(NSDictionary) == true)
                {
                    var d : NSDictionary = dict as! NSDictionary
                    if(d.valueForKey("code")?.intValue == 200)
                    {
                        self.constant.showAlertWithTitleAndMesssage("Thank You :)", msg: d.valueForKey("data") as! String)
                        UIApplication.sharedApplication().keyWindow?.endEditing(true)
                    }
                    else
                    {
                        self.constant.showAlertWithTitleAndMesssage("Error", msg: "Your feedback could not be posted")
                    }
                }
            }
        }
    }
    
    func isKeyboardOnScreen() -> Bool
    {
        var isKBVisb = false
        var window = UIApplication.sharedApplication().windows
        if window.count > 1
        {
            var arrSubV = window[1].subviews
            if arrSubV.count != 0
            {
                var KBFrame = arrSubV[0].frame
                var scrFrame = window[1].frame
                if KBFrame.origin.y + KBFrame.size.height == scrFrame.size.height
                {
                    isKBVisb = true
                }
            }
        }
        return isKBVisb
    }
    
    @IBAction func btnInviteByMsgClicked(sender: AnyObject)
    {
        if MFMessageComposeViewController.canSendText()
        {
            var messageVC:MFMessageComposeViewController = MFMessageComposeViewController()
            
            messageVC.body = "Hey, try the new SAO app to find nearby store, offers, and order for pick up or delivery. Also if you sign up we both earn 15 points, which are redeemable at anyone of their stores. Use this code: xxxxxxx when you register. Download the app at: http://itunes.com/{url}"
            
            messageVC.messageComposeDelegate = self
            
            self.presentViewController(messageVC, animated: false, completion: nil)
        }
        else
        {
            constant.showAlertWithTitleAndMesssage("Error!", msg: "Cannot send SMS.")
        }
    }
    
    @IBAction func btnInviteByMailClicked(sender: AnyObject)
    {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setSubject("I think you and SAO will get along!")
        mailComposerVC.setMessageBody("Hey, try the new SAO app to find nearby store, offers, and order for pick up or delivery. Also if you sign up we both earn 15 points, which are redeemable at anyone of their stores. Use this code: xxxxxxx when you register. Download the app at: http://itunes.com/{url}", isHTML: false)
        
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposerVC, animated: true, completion: nil)
        } else {
            self.constant.showAlertWithTitleAndMesssage("Error!", msg: "Can not send mail.")
        }
    }
    
    @IBAction func btnCloseContactUs(sender: AnyObject) {
        self.vwShadow.alpha=0
        vwContactUs.hidden = true
        vwShadow.hidden = true
        btnMenu.hidden = false
    }
    @IBAction func btnCloseReferClicked(sender: AnyObject)
    {
        self.vwShadow.alpha=0
        vwRefer.hidden = true
        vwShadow.hidden = true
        btnMenu.hidden = false
    }
    
    @IBAction func btnPayNowClicked(sender: AnyObject)
    {
        self.performSegueWithIdentifier("paynow", sender: self)
    }
    
    @IBAction func btnNearByStoresClicked(sender: AnyObject)
    {
        self.performSegueWithIdentifier("OrderClickedSegue", sender: self)
    }
    
    @IBAction func btnPointsClicked(sender: AnyObject)
    {
        self.performSegueWithIdentifier("pointsSegue", sender: self)
    }
    
    @IBAction func btnCloseOrderPopupClicked(sender: AnyObject)
    {
        self.vwShadow.alpha=0
        vwOrderPopup.hidden = true
        vwShadow.hidden = true
        btnMenu.hidden = false
    }
    
    @IBAction func btnStoreAppClicked(sender: AnyObject)
    {
        self.btnCloseOrderPopupClicked(UIButton())
        self.performSegueWithIdentifier("OrderClickedSegue", sender: self)
    }
    
    @IBAction func btnDeliverToAddressClicked(sender: AnyObject)
    {
        var altCall: UIAlertView = UIAlertView()
        
        altCall.delegate = self
        altCall.tag = 123
        
        altCall.title = "1800200300"
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
                UIApplication.sharedApplication().openURL(NSURL(string: "tel://" + alertView.title)!)
            }
        }
    }
    
    
    @IBAction func btnOrderClicked(sender: AnyObject)
    {
        self.vwShadow.alpha=0.9
        vwOrderPopup.hidden = false
        vwShadow.hidden = false
        btnMenu.hidden = true
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
    
//-----------------------------------------------------------------------------------------------------------------------------------    //MARK: -----------MFMailComposeViewControllerDelegate Method-----------

    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult)
    {
        switch (result.value)
        {
            case MessageComposeResultCancelled.value:
                println("Message was cancelled")
                break;
            case MessageComposeResultFailed.value:
                println("Message failed")
                break;
            case MessageComposeResultSent.value:
                println("Message was sent")
                break;
            default:
                break;
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------    //MARK: -----------Custom methods-----------
    
    func showMenuView()
    {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            var frmMen,frmhm : CGRect
            frmhm = self.vwHome.frame
            frmMen = self.sideBarVC.view.frame
            
            frmhm.origin.x = self.view.frame.origin.x - 200
            frmMen.origin.x = self.view.frame.size.width - 200
            
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
    
    
    func getPoints()
    {
        altWait.show()
        var urlStr : NSString = NSString(format:"%@%@%@%@",constant.baseUrl,constant.apiKey,constant.getUserPointsServices,constant.getUserPointsMethos)
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
                        println("Data Found for points")
                        
                        d = d.valueForKey("data") as! NSDictionary
                        
                        if(d.valueForKey("activity")?.isKindOfClass(NSNull) == false)
                        {
                            var dict : NSDictionary = d.valueForKey("activity")?.firstObject as! NSDictionary
                            self.lblPoints.text = dict.valueForKey("points") as? String
                            self.lblPoints.text = "\(self.lblPoints.text!) pts"
                            self.lblBalence.text = dict.valueForKey("balance") as? String
                            self.lblBalence.text = "KD \(self.lblBalence.text!)"
                        }
                    }
                }
            }
        }
    }
//-----------------------------------------------------------------------------------------------------------------------------------    //MARK: -----------Sidebar delegate methods-----------
    
    func btnClickedForVC(ViewControler: AnyObject, IsHomeClicked flag: Bool)
    {
        if(flag == true)
        {
            self.hideMenuView()
            isSidebarVisible = false
        }
    }
    
    func btnReferClicked()
    {
        vwShadow.alpha=0.9
        vwRefer.hidden = false
        vwShadow.hidden = false
        btnMenu.hidden = true
    }
    
    func btnContactUSClicked()
    {
        vwShadow.alpha=0.9
        vwContactUs.hidden = false
        vwShadow.hidden = false
        btnMenu.hidden = true
    }
    
    
    
       // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        self.hideMenuView()
    }
    
}
