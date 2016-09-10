//
//  loginVC.swift
//  Travelling
//
//  Created by Muskan on 8/6/16.
//  Copyright © 2016 Muskan. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import CoreLocation

class loginVC: UIViewController , FBSDKLoginButtonDelegate , GIDSignInDelegate , GIDSignInUIDelegate , CLLocationManagerDelegate {
    
    var username = String()
    var useremail = String()
    var userPicURL = String()
    
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    //@IBOutlet weak var googleSignInButton: GIDSignInButton!
    @IBOutlet weak var mobileSignIn: UIButton!
    @IBOutlet weak var customGsigninBtn: UIButton!
    
    //User Location
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Location
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        mobileSignIn.backgroundColor = UIColor.clearColor()
        mobileSignIn.layer.cornerRadius = 5
        mobileSignIn.layer.borderWidth = 1
        mobileSignIn.layer.borderColor = UIColor.whiteColor().CGColor
        mobileSignIn.clipsToBounds = true
        mobileSignIn.layer.masksToBounds = true
        //mobileSignIn.imageView?.tintColor = UIColor.whiteColor()
        
        fbLoginButton.backgroundColor = UIColor.clearColor()
        customGsigninBtn.layer.cornerRadius = 5
        customGsigninBtn.clipsToBounds = true

        let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
        
        GIDSignIn.sharedInstance().signOut()
        
        GIDSignIn.sharedInstance().clientID = "716814812925-fbbetijseecielpdej3ulb761l35pqm9.apps.googleusercontent.com"
        //GPPDeepLink.delegate = self
        //GPPDeepLink.readDeepLinkAfterInstall()
        
        if FBSDKAccessToken.currentAccessToken() == nil {
            print ("Not logged in")
        } else {
            print("logged in..")
            //performSegueWithIdentifier("showNext", sender: self)
        }
        
        fbLoginButton.readPermissions = ["public_profile","email"]
        fbLoginButton.delegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isLoggedin")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
//    override func viewWillAppear(animated: Bool) {
//        if ((FBSDKAccessToken.currentAccessToken() != nil) || (GIDSignIn.sharedInstance().hasAuthInKeychain()) || (NSUserDefaults.standardUserDefaults().boolForKey("loginWithMobile"))) {
//            let navigationViewController = self.storyboard!.instantiateViewControllerWithIdentifier("nav") as! MyNavigationController
//            let actionViewController = self.storyboard?.instantiateViewControllerWithIdentifier(TravellingConstants.StoryBoard.MapViewController) as! MapViewController
//            
//            self.presentViewController(navigationViewController, animated: true, completion: nil)
//            self.navigationController?.pushViewController(actionViewController, animated: true)
//        }
//    }
    
    
    @IBAction func fbLoginBtnAction(sender: AnyObject) {
        
    }
    
    @IBAction func customGSigninAction(sender: AnyObject) {
         GIDSignIn.sharedInstance().signIn()
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error == nil {
            fetchProfile()
        } else {
            print(error.localizedDescription)
        }
    }
    
    func fetchProfile() {
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler({ (connection, user, requestError) -> Void in
            
            if requestError != nil {
                print(requestError)
                print("user cancelled login")
                return
            }
            
            print("Logged in successfully")
            
            let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("mobileVC") as UIViewController
            self.presentViewController(viewController, animated: true, completion: nil)
            
            //NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isLoggedin")
            
            let email = user["email"] as? String
            let firstName = user["first_name"] as? String
            let lastName = user["last_name"] as? String
            let userID = user.valueForKey("id") as! NSString
            print(userID)
            
            self.username = "\(firstName!) \(lastName!)"
            self.useremail = email!
            print(self.username)
            print(self.useremail)
            
            if let picture = user["picture"] as? NSDictionary, data = picture["data"] as? NSDictionary, url = data["url"] as? String {
                self.userPicURL = url
            }
            self.saveInDefaults(self.username, uemail: self.useremail , userImageUrl: self.userPicURL , userID: userID as String)
            print(NSUserDefaults.standardUserDefaults().valueForKey(TravellingConstants.NSUserDefaults.userId)!)
            //print(self.userPicURL)
        })
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User loged out...")
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("name")
        defaults.removeObjectForKey("email")
        defaults.removeObjectForKey("imgUrl")
        defaults.setBool(false, forKey: "isLoggedin")
        let test = defaults.valueForKey("name") as? String
        print("After log out \(test)")
    }
    
    //MARK:- GoogleSignIn Delegate
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error == nil) {
            let imageURL = user.profile.imageURLWithDimension(50)
            //let email = user.profile.email
            let gid = user.userID
            //NSUserDefaults.standardUserDefaults().setObject(email, forKey: "email")
            //let idToken = user.authentication.idToken
//            saveToUserDefaults(user.profile.givenName, profilePic: String(imageURL), id: idToken)
//            loginInSuccessfully()
            
            saveInDefaults(user.profile.givenName , uemail: user.profile.email , userImageUrl: String(imageURL) , userID: gid)
            let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("mobileVC") as UIViewController
            self.presentViewController(viewController, animated: true, completion: nil)
            //NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isLoggedin")
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        
    }
    
    func signIn(signIn: GIDSignIn!, presentViewController viewController: UIViewController!) {
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func signIn(signIn: GIDSignIn!, dismissViewController viewController: UIViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveInDefaults(uname: String , uemail: String , userImageUrl: String , userID: String?){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(uname, forKey: TravellingConstants.NSUserDefaults.username)
        defaults.setValue(uemail, forKey: TravellingConstants.NSUserDefaults.user_email)
        defaults.setValue(userImageUrl, forKey: TravellingConstants.NSUserDefaults.user_pic)
        defaults.setValue(userID, forKey: TravellingConstants.NSUserDefaults.userId)
//        defaults.setValue(uname, forKey: "name")
//        defaults.setValue(uemail, forKey: "email")
//        defaults.setValue(userImageUrl, forKey: "imgUrl")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
