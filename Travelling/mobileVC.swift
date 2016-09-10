//
//  mobileVC.swift
//  Travelling
//
//  Created by Muskan on 8/10/16.
//  Copyright © 2016 Muskan. All rights reserved.
//

import UIKit
import TextFieldEffects

class mobileVC: UIViewController {

    //@IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var txtMobile: MadokaTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let textFieldFrame = CGRectMake(20, 100, 335, 50)
        txtMobile = MadokaTextField(frame: textFieldFrame)
        txtMobile.textColor = UIColor.whiteColor()
        txtMobile.placeholder = "Your Mobile Number"
        txtMobile.placeholderColor = .whiteColor()
        txtMobile.borderColor = .redColor()
        //txtMobile.isFirstResponder()
        txtMobile.becomeFirstResponder()
        self.view.addSubview(txtMobile)
    }
    
    @IBAction func btnSendOtp(sender: AnyObject) {
//        if txtMobile.text == "" {
//            showAlert("Please enter your mobile number!")
//            return
//        }
        NSUserDefaults.standardUserDefaults().setValue(txtMobile.text!, forKey: TravellingConstants.NSUserDefaults.user_mobile)
        data_request()
        activityIndicator.startAnimating()
    }
    
    func data_request() {
        let url:NSURL = NSURL(string:TravellingConstants.urls.users)!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        
        let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        
        //let paramString = "name=\(txtFirstName.text!)&email=\(txtEmail.text!)&mobile=\(txtMobile.text!)&password=\(txtPassword.text!)&did=sfmhfmsm&onesignal_id=2&fbid=dgdm"
        //print(paramString)
        let defaults = NSUserDefaults.standardUserDefaults()
        let username = defaults.valueForKey(TravellingConstants.NSUserDefaults.username)
        let uemail = defaults.valueForKey(TravellingConstants.NSUserDefaults.user_email)
        let onesignal_userId = defaults.valueForKey(TravellingConstants.NSUserDefaults.onesignal_userId)
        let userId = defaults.valueForKey(TravellingConstants.NSUserDefaults.userId)
        let paramString = "name=\(username!)&email=\(uemail!)&mobile=+91\(txtMobile.text!)&did=\(deviceId)&onesignal_id=\(onesignal_userId!)&fbid=\(userId!)"
        print(paramString)
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error occurred fetching otp")
                return
            }
            
            if let HTTPResponse = response as? NSHTTPURLResponse {
                let statusCode = HTTPResponse.statusCode
                print(statusCode)
                self.activityIndicator.stopAnimating()
                
                if statusCode == 200 || statusCode == 201 {
                    let readableJSON = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
                    print(readableJSON)
                    
                    if readableJSON["error"] == true {
                        let errorMsg = readableJSON["error_msg"].string as String! ?? String("Something went wrong.Please try again.")
                        print("Error occurred \(errorMsg)")
                        dispatch_async(dispatch_get_main_queue(), {
                            self.activityIndicator.stopAnimating()
                            //show alert message
                            //self.showAlert("Something went wrong.Please try again.")
                            self.showAlert(errorMsg)
                            return
                        })
                        
                    } else {
                        let otp = readableJSON["otp"].string as String!
                        print(readableJSON["otp"].string as String!)
                        let defaults = NSUserDefaults.standardUserDefaults()
                        defaults.setValue(otp, forKey: "otp")
                        defaults.synchronize()
                        
                        if error != true {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.activityIndicator.stopAnimating()
                                //self.performSegueWithIdentifier("showOtpVerify", sender: self)
                                let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("otpVerifyVC") as! otpVerifyVC
                                self.presentViewController(viewController, animated: true, completion: nil)
                                return
                            })
                        }
                    }
                }//end of for loop
            }
        }
        task.resume()
    }
    
    func showAlert(yourMsg: String) {
        //show alert message
        let alert = UIAlertController(title: "", message: "\(yourMsg)", preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        //end alert
        // Delay the dismissal by 5 seconds
        let delay = 3.0 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alert.dismissViewControllerAnimated(true, completion: nil)
        })
    }

}
