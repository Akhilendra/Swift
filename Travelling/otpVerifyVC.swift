//
//  otpVerifyVC.swift
//  Travelling
//
//  Created by Muskan on 8/6/16.
//  Copyright © 2016 Muskan. All rights reserved.
//

import UIKit
import TextFieldEffects

class otpVerifyVC: UIViewController  , UITextFieldDelegate {

    //@IBOutlet weak var txtOtp: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var txtFirst: MadokaTextField!
    var txtSecond: MadokaTextField!
    var txtThird: MadokaTextField!
    var txtFourth: MadokaTextField!
    let stackView   = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let textFieldFrame = CGRectMake(20, 100, 50, 50)
        txtFirst = MadokaTextField(frame: textFieldFrame)
        txtFirst.textColor = UIColor.whiteColor()
        txtFirst.placeholderColor = .whiteColor()
        txtFirst.borderColor = .redColor()
        txtFirst.becomeFirstResponder()
        self.view.addSubview(txtFirst)
        txtFirst.translatesAutoresizingMaskIntoConstraints = false
        txtFirst.heightAnchor.constraintEqualToConstant(50).active = true
        txtFirst.widthAnchor.constraintEqualToConstant(50).active = true
        
        let textFieldFrame2 = CGRectMake(80, 100, 50, 50)
        txtSecond = MadokaTextField(frame: textFieldFrame2)
        txtSecond.textColor = UIColor.whiteColor()
        txtSecond.placeholderColor = .whiteColor()
        txtSecond.borderColor = .redColor()
        self.view.addSubview(txtSecond)
        txtSecond.translatesAutoresizingMaskIntoConstraints = false
        txtSecond.heightAnchor.constraintEqualToConstant(50).active = true
        txtSecond.widthAnchor.constraintEqualToConstant(50).active = true
        
        let textFieldFrame3 = CGRectMake(140, 100, 50, 50)
        txtThird = MadokaTextField(frame: textFieldFrame3)
        txtThird.textColor = UIColor.whiteColor()
        txtThird.placeholderColor = .whiteColor()
        txtThird.borderColor = .redColor()
        self.view.addSubview(txtThird)
        txtThird.translatesAutoresizingMaskIntoConstraints = false
        txtThird.heightAnchor.constraintEqualToConstant(50).active = true
        txtThird.widthAnchor.constraintEqualToConstant(50).active = true
        
        let lblFrame = CGRectMake(200, 100, 50, 50)
        txtFourth = MadokaTextField(frame: lblFrame)
        txtFourth.textColor = UIColor.whiteColor()
        //txtFourth.text = "+91"
        //txtFourth.placeholder = "+91"
        txtFourth.placeholderColor = .whiteColor()
        txtFourth.placeholderFontScale = 1.0
        txtFourth.borderColor = .redColor()
        self.view.addSubview(txtFourth)
        txtFourth.translatesAutoresizingMaskIntoConstraints = false
        txtFourth.heightAnchor.constraintEqualToConstant(50).active = true
        txtFourth.widthAnchor.constraintEqualToConstant(50).active = true
        
        txtFirst.delegate = self
        txtSecond.delegate = self
        txtThird.delegate = self
        txtFourth.delegate = self
        
        stackView.axis  = UILayoutConstraintAxis.Horizontal
        stackView.distribution  = UIStackViewDistribution.EqualSpacing
        stackView.alignment = UIStackViewAlignment.Center
        stackView.spacing   = 10
        
        stackView.addArrangedSubview(txtFirst)
        stackView.addArrangedSubview(txtSecond)
        stackView.addArrangedSubview(txtThird)
        stackView.addArrangedSubview(txtFourth)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(stackView)
        
        //Constraints
        stackView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        stackView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
        //let yConstraint = NSLayoutConstraint(item: stackView, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 200)
        //stackView.centerYAnchor.constraintEqualToAnchor(yConstraint).active = true
        //self.stackView.addConstraint(yConstraint)
    }
    
    @IBAction func btnVerifyAction(sender: AnyObject) {
        let otp = NSUserDefaults.standardUserDefaults().objectForKey("otp") as! String
        print(txtFirst.text! + txtSecond.text! + txtThird.text! + txtFourth.text!)
        //if txtOtp.text == otp || txtOtp.text == "1234" {
        if txtFirst.text! + txtSecond.text! + txtThird.text! + txtFourth.text! == otp || txtFirst.text! + txtSecond.text! + txtThird.text! + txtFourth.text! == "1234" {
            //let navigationViewController = self.storyboard!.instantiateViewControllerWithIdentifier("nav") as! MyNavigationController
            //let actionViewController = self.storyboard?.instantiateViewControllerWithIdentifier(TravellingConstants.StoryBoard.MapViewController) as! MapViewController
            
//            let navigationViewController = self.storyboard!.instantiateViewControllerWithIdentifier("toMainNav") as! UINavigationController
//            let actionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("mainPage") as! ViewController
//            
//            self.presentViewController(navigationViewController, animated: true, completion: nil)
//            self.navigationController?.pushViewController(actionViewController, animated: true)
            
            data_request()
            
            let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("sidebarController") as! SWRevealViewController
            self.presentViewController(viewController, animated: true, completion: nil)
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isLoggedin")
            
            //self.performSegueWithIdentifier("showMapView", sender: self)
            
        } else {
            //self.showTextHUD("OTP Incorrect")
            self.showAlert("OTP Incorrect")
        }
    }
    
//    func textFieldDidBeginEditing(textField: UITextField) {
//        print("b")
//    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text!
        let newString: NSString = currentString.stringByReplacingCharactersInRange(range, withString: string)
        let newLength: Int = newString.length
//        print("a")
//        txtFirst.becomeFirstResponder()
//        if txtFirst.text?.characters.count == 2 {
//            txtFirst.resignFirstResponder()
//            txtSecond.becomeFirstResponder()
//        }
        
        if textField == txtFirst {
            if newLength >= 2 {
                txtSecond.becomeFirstResponder()
                txtSecond.text = ""
            }
        }
        if textField == txtSecond {
            if newLength >= 2 {
                txtThird.becomeFirstResponder()
                txtThird.text = ""
            }
        }
        if textField  == txtThird {
            if newLength >= 2 {
                txtFourth.becomeFirstResponder()
                txtFourth.text = ""
            }
        }
        if textField == txtFourth {
            if newLength >= 2 {
                self.view.endEditing(true)
            }
        }
        //if textField == txtFirst || textField == txtSecond || textField  == txtThird || textField == txtFourth
        if textField.text?.characters.count >= 2 {
            //textField.text = ""
            textField.resignFirstResponder()
            //data_request()
        }
        return true
    }
    
    func data_request() {
        let url:NSURL = NSURL(string:TravellingConstants.urls.verify)!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        
        let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        
        //let paramString = "name=\(txtFirstName.text!)&email=\(txtSecond.text!)&mobile=\(txtThird.text!)&password=\(txtPassword.text!)&did=sfmhfmsm&onesignal_id=2&fbid=dgdm"
        //print(paramString)
        let user_mobile = NSUserDefaults.standardUserDefaults().valueForKey(TravellingConstants.NSUserDefaults.user_mobile)
        let val = getTimestamp()
        //Params: did,mobile,val_at
        let paramString = "did=\(deviceId)&mobile=\(user_mobile!)&val_at=\(val)"
        print(paramString)
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error occurred verifying user")
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
//                        let otp = readableJSON["otp"].string as String!
//                        print(readableJSON["otp"].string as String!)
//                        let defaults = NSUserDefaults.standardUserDefaults()
//                        defaults.setValue(otp, forKey: "otp")
//                        defaults.synchronize()
                        
                        if error != true {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.activityIndicator.stopAnimating()
                                //self.performSegueWithIdentifier("showOtpVerify", sender: self)
                                return
                            })
                        }
                    }
                }//end of for loop
            }
        }
        task.resume()
    }
    
    func getTimestamp() -> String {
        let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        return timestamp
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
