//
//  registerVC.swift
//  Travelling
//
//  Created by Muskan on 8/6/16.
//  Copyright © 2016 Muskan. All rights reserved.
//

import UIKit
import TextFieldEffects

class registerVC: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pickerCountry: UIPickerView!
    
    var pickerDataSource = ["Argentina","Brazil", "China","Canada","Iceland","Hungary","India","Indonesia", "USA"]
    var txtName: MadokaTextField!
    var txtEmail: MadokaTextField!
    var txtMobile: MadokaTextField!
    var txtCode: MadokaTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //data_request()
        
        self.pickerCountry.dataSource = self
        self.pickerCountry.delegate = self
        
        let textFieldFrame = CGRectMake(20, 100, 335, 50)
        txtName = MadokaTextField(frame: textFieldFrame)
        txtName.textColor = UIColor.whiteColor()
        txtName.placeholder = "Your Name"
        txtName.placeholderColor = .whiteColor()
        txtName.borderColor = .redColor()
        //txtName.isFirstResponder()
        txtName.becomeFirstResponder()
        self.view.addSubview(txtName)
        
        let textFieldFrame2 = CGRectMake(20, 160, 335, 50)
        txtEmail = MadokaTextField(frame: textFieldFrame2)
        txtEmail.textColor = UIColor.whiteColor()
        txtEmail.placeholder = "Your Email"
        txtEmail.placeholderColor = .whiteColor()
        txtEmail.borderColor = .redColor()
        self.view.addSubview(txtEmail)
        
//        let lblFrame1 = CGRectMake(20, 270, 335, 50)
//        let lbl = UILabel(frame: lblFrame1)
//        lbl.textColor = UIColor.whiteColor()
//        lbl.text = "+91"
//        lbl.layer.borderColor = UIColor.redColor().CGColor
//        lbl.layer.borderWidth = 1
//        self.view.addSubview(lbl)
        
        let lblFrame = CGRectMake(20, 220, 45, 50)
        txtCode = MadokaTextField(frame: lblFrame)
        txtCode.textColor = UIColor.whiteColor()
        //txtCode.text = "+91"
        txtCode.placeholder = "+91"
        txtCode.placeholderColor = .whiteColor()
        txtCode.placeholderFontScale = 1.0
        txtCode.borderColor = .redColor()
        txtCode.userInteractionEnabled = false
        txtCode.enabled = false
        self.view.addSubview(txtCode)
        
        let textFieldFrame3 = CGRectMake(70, 220, 285, 50)
        txtMobile = MadokaTextField(frame: textFieldFrame3)
        txtMobile.textColor = UIColor.whiteColor()
        txtMobile.placeholder = "Your Mobile Number"
        txtMobile.placeholderColor = .whiteColor()
        txtMobile.borderColor = .redColor()
        self.view.addSubview(txtMobile)
        
        pickerCountry.selectRow(6, inComponent: 0, animated: false)
    }
    
//    func createTextField(textField: UITextField , x: CGFloat , y: CGFloat) {
//        let textFieldFrame = CGRectMake(20, 220, 335, 50)
//        textField = MadokaTextField(frame: textFieldFrame)
//        textField.textColor = UIColor.whiteColor()
//        textField.placeholderColor = .whiteColor()
//        textField.borderColor = .redColor()
//        
//        self.view.addSubview(textField)
//    }
    
    @IBAction func goBtnAction(sender: AnyObject) {
        if (txtName.text?.characters.count) == 0 {
            showAlert("Please enter your name.")
            return
        } else if (txtEmail.text?.characters.count) < 4 {
            showAlert("Please enter your email")
            return
        } else if (txtMobile.text?.characters.count) < 4 {
            showAlert("Please enter your mobile number")
            return
        } else {
            activityIndicator.startAnimating()
            data_request()
            NSUserDefaults.standardUserDefaults().setValue(txtMobile.text!, forKey: TravellingConstants.NSUserDefaults.user_mobile)
        }
        
//        data_request()
//        activityIndicator.startAnimating()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
//        if(row == 0)
//        {
//            self.view.backgroundColor = UIColor.whiteColor();
//        }
//        else if(row == 1)
//        {
//            self.view.backgroundColor = UIColor.redColor();
//        }
//        else if(row == 2)
//        {
//            self.view.backgroundColor =  UIColor.greenColor();
//        }
//        else
//        {
//            self.view.backgroundColor = UIColor.blueColor();
//        }
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
        let userId = defaults.valueForKey(TravellingConstants.NSUserDefaults.userId)
        let onesignal_id = NSUserDefaults.standardUserDefaults().valueForKey(TravellingConstants.NSUserDefaults.onesignal_userId)
        let paramString = "name=\(txtName.text!)&email=\(txtEmail.text!)&mobile=+91\(txtMobile.text!)&did=\(deviceId)&onesignal_id=\(onesignal_id!)&fbid=\(userId!)"
        print("regiter params: \(paramString)")
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
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
                                self.performSegueWithIdentifier("showOtpVerify", sender: self)
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
