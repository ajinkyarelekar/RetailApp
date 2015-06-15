//
//  SideBarVC.swift
//  RetailApp swift
//
//  Created by Ajinkya's on 30/04/15.
//  Copyright (c) 2015 Ajinkya. All rights reserved.
//

import UIKit

@objc protocol SideBarVCDelegates
{
    optional func btnClickedForVC(ViewControler : AnyObject, IsHomeClicked flag:Bool)
    optional func btnReferClicked()
    optional func btnContactUSClicked()
}

class SideBarVC: UIViewController
{
    var delegate : SideBarVCDelegates?
    var navCtrlr : UINavigationController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnMenuClicked(sender: UIButton)
    {
        var isHomeClicked = false
        var VC : AnyObject?
        var SB = UIStoryboard(name: "Main", bundle: nil)
        
        var parantVC = self.view.superview?.nextResponder()
        
        
        switch(sender.tag)
        {
            case 11:
                //Home
                isHomeClicked = true
                
                for ViewCntrl in self.navCtrlr.viewControllers
                {
                    if(ViewCntrl.isMemberOfClass(homePageVC) == true)
                    {
                        self.navCtrlr.popToViewController(ViewCntrl as! homePageVC, animated: true)
                        VC = ViewCntrl
                        break
                    }
                }
                    break
            
            case 12:
                //Our Menu
                VC = SB.instantiateViewControllerWithIdentifier("OurMenuVC")
                self.navCtrlr.pushViewController(VC as! OurMenuVC, animated: true)
                    break;
            
            case 13:
                //Refil Bonus
        
                VC = SB.instantiateViewControllerWithIdentifier("PayNowVC")
                self.navCtrlr.pushViewController(VC as! PayNowVC, animated: true)
                    break;
            
            case 14:
                //Points
                VC = SB.instantiateViewControllerWithIdentifier("pointsVC")
                self.navCtrlr.pushViewController(VC as! pointsVC, animated: true)
                    break;
            
            case 15:
                //Receipts
                VC = SB.instantiateViewControllerWithIdentifier("ReceiptsVC")
                self.navCtrlr.pushViewController(VC as! ReceiptsVC, animated: true)
                    break;
            
            case 16:
                //Profile
                VC = SB.instantiateViewControllerWithIdentifier("ProfileVC")
                self.navCtrlr.pushViewController(VC as! ProfileVC, animated: true)
                    break;
            
            case 17:
                //Store Locator
                VC = SB.instantiateViewControllerWithIdentifier("StoresVC")
                self.navCtrlr.pushViewController(VC as! StoresVC, animated: true)
                    break;
            
            case 18:
                //Refer Friends
                
                isHomeClicked = true
                
                for ViewCntrl in self.navCtrlr.viewControllers
                {
                    if(ViewCntrl.isMemberOfClass(homePageVC) == true)
                    {
                        self.navCtrlr.popToViewController(ViewCntrl as! homePageVC, animated: true)
                        VC = ViewCntrl
                        
                        delegate?.btnClickedForVC!(VC! , IsHomeClicked: isHomeClicked)
                        delegate?.btnReferClicked!()
                        return
                    }
                }

                break;
            
            case 19:
                //Contact Us
                
                isHomeClicked = true
                
                for ViewCntrl in self.navCtrlr.viewControllers
                {
                    if(ViewCntrl.isMemberOfClass(homePageVC) == true)
                    {
                        self.navCtrlr.popToViewController(ViewCntrl as! homePageVC, animated: true)
                        VC = ViewCntrl
                        
                        delegate?.btnClickedForVC!(VC! , IsHomeClicked: isHomeClicked)
                        delegate?.btnContactUSClicked!()
                        return
                    }
                }

                break;

            default:
                break;
        }
        
        delegate?.btnClickedForVC!(VC! , IsHomeClicked: isHomeClicked)
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
