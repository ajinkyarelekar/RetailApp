//
//  constants.swift
//  RetailApp swift
//
//  Created by Ajinkya's on 31/03/15.
//  Copyright (c) 2015 Ajinkya. All rights reserved.
//

import UIKit

class constants: NSObject,UIAlertViewDelegate
{
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    //MARK: -----------Base URL-----------
    
    let baseUrl : NSString = "https://ppe01.mcppos.com/ws/mcpposasc/sobjects/v3/" // snpposasc
    let apiKey : NSString = "6e099b101ee457b5b62c79deb3b411f4"
        
    //MARK: ----------- Verify User Mobile Number-----------
    
    let verifyUSerService : NSString = "/verifyuser"
    let verifyUserMethd : NSString = "/getnum.json"
    
    //MARK: ----------- verify Code-----------
    let VerifySMScodeService : NSString = "/verifycode"
    let verifyCodeMethd : NSString = "/getnum.json"

    //MARK: ----------- Sign up-----------
    let UserRegistrationService : NSString = "/completesignup"
    let UserRegistrationMethod : NSString = "/verifyaccount.json"

    //MARK: ----------- Login Request-----------
    
    let userLoginService : NSString = "/login"
    let userLoginMethod : NSString = "/verify.json"
    
    //MARK: ----------- Logout Request-----------
    
    let userLogOutService : NSString = "/logout"
    let userLogOutMethod : NSString = "/end.json"
    
    //MARK: ----------- User Password Reset request-----------
    
    let userPassResetService : NSString = "/beginpassreset"
    let userPassResetMethod : NSString = "/getuserinfo.json"
    
    //MARK: ----------- User Profile request-----------
    
    let userProfileService : NSString = "/myaccount"
    let userProfileMethod : NSString = "/profile.json"
    
    //MARK: ----------- User Profile Change Data request-----------
    
    let userProfileChangeDataService : NSString = "/myaccount"
    let userProfileChangeDataMethod : NSString = "/editname.json"
    
    //MARK: ----------- User Profile Change Password request-----------
    
    let userProfileChangePasswordService : NSString = "/myaccount"
    let userProfileChangePasswordMethod : NSString = "/editpassword.json"
    
    //MARK: ----------- User Balance Request-----------
    
    let userBalanceService : NSString = "/myaccount"
    let userBalanceMethod : NSString = "/balance.json"
    
    //MARK: ----------- List Stores Request-----------
    
    let userListStoreService : NSString = "/liststores"
    let userListStoreMethod : NSString = "/getuserloc.json"
    
    //MARK: ----------- Get Store Details Request-----------
    
    let userGetStoreDetailsService : NSString = "/showstoredetails"
    let userGetStoreDetailsMethod : NSString = "/getstorecode.json"
    
    //MARK: ----------- get Receipts-----------
    
    let userGetReceiptsService : NSString = "/listreceipts"
    let userGetGetReceiptsMethod : NSString = "/getuserpurchases.json"
    
    //MARK: ----------- get Receipts Details-----------
    
    let userGetReceiptDetailsService : NSString = "/listreceipts"
    let userGetGetReceiptDetailsMethod : NSString = "/getuserpurchasesdetails.json"
    
    //MARK: ----------- get Stores-----------
    
    let getStoresServices : NSString = "/liststores"
    let getStoresMethos : NSString = "/getuserloc.json"
    
    //MARK: ----------- get Stores Details-----------
    
    let getStoreDetailsServices : NSString = "/showstoredetails"
    let getStoreDetailsMethos : NSString = "/getstorecode.json"
    
    //MARK: ----------- List Points and Balance Request-----------
    
    let getUserPointsServices : NSString = "/listpoints"
    let getUserPointsMethos : NSString = "/showactivity.json"
    let getReceiptsPaidByPointsMethos : NSString = "/getpointsbasedrec.json"
    
    //MARK: -----------Show Menu Catagories-----------
    
    let getMenuCatagoryServices : NSString = "/showmenu"
    let getMenuCatagoryMethos : NSString = "/withcategories.json"
    
    //MARK: -----------Show Catagorie Wise Menu-----------
    
    let getMenuServices : NSString = "/showcatsubmenu"
    let getMenuMethos : NSString = "/getcatid.json"
    
    //MARK: -----------Show Menu Details-----------
    
    let getMenuDetailsServices : NSString = "/showmenuitem"
    let getMenuDetailsMethos : NSString = "/getsku.json"
    
    //MARK: -----------Contact	Us-----------
    
    let ContactUsServices : NSString = "/contactus"
    let ContactUsMethos : NSString = "/savefeedback.json"
    
    //MARK: -----------Pay Request-----------
    
    let PayRequestServices : NSString = "/paynow"
    let PayRequestMethod : NSString = "/getstatus.json"
    
    
    let storyBord : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    //MARK: -----------Alert Method-----------
    
    func showAlertWithTitleAndMesssage(title:NSString,msg:NSString)
    {
        let alert = UIAlertView(title: title as String, message: msg as String, delegate: self, cancelButtonTitle: "Ok")
        
        alert .show()
    }
    
    //MARK: -----------Web service Call Method-----------
    
    
    func PerformRequestwith(url:NSString,strparam:NSString,methodUsed:NSString,WithCompletion:(data : NSData?) -> ())
    {
        let returnData : NSData!
        
        let req : NSMutableURLRequest = NSMutableURLRequest (URL: NSURL(string: url as String)!)
        
        req.HTTPMethod = methodUsed as String
        
        if(methodUsed.isEqualToString("POST")==true)
        {
            req.HTTPBody = strparam.dataUsingEncoding(NSUTF8StringEncoding)
        }
        
        NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue.mainQueue()){
                (response, returnData, err) -> Void in
            WithCompletion(data: returnData)
        }
    }
}
