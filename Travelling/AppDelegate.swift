//
//  AppDelegate.swift
//  Travelling
//
//  Created by Muskan on 8/6/16.
//  Copyright © 2016 Muskan. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Fabric
import Crashlytics
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
         //Override point for customization after application launch.
        //var rootViewController = self.window?.rootViewController
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let isLoggedin:Bool = NSUserDefaults.standardUserDefaults().boolForKey("isLoggedin")
        if(!isLoggedin){
            //var loginVC = mainStoryboard.instantiateViewControllerWithIdentifier("loginVC") as! loginVC
            let loginView = mainStoryboard.instantiateViewControllerWithIdentifier("loginVC") as! loginVC
            window?.rootViewController = loginView
            window?.makeKeyAndVisible()
        } else {
            //var protectedPage = mainStoryboard.instantiateViewControllerWithIdentifier("protectedPage") as! FBLoggedinVC
            //let protectedPage = mainStoryboard.instantiateViewControllerWithIdentifier("mainPage") as! ViewController
            let protectedPage = mainStoryboard.instantiateViewControllerWithIdentifier("sidebarController") as! SWRevealViewController
            window?.rootViewController = protectedPage
            window?.makeKeyAndVisible()
        }
        
        //Google analytics
            
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
        gai.logger.logLevel = GAILogLevel.Verbose  // remove before app release
            
        //end google analytics
            
        //fabric and crashlytics start
        Fabric.with([Crashlytics.self])
        //fabric and crashlytics end
            
        //onesignal start
        OneSignal.initWithLaunchOptions(launchOptions, appId: "f600eb34-1154-415b-9f64-d88488f08377")
//        _ = OneSignal(launchOptions: launchOptions, appId: "b2f7f966-d8cc-11e4-bed1-df8f05be55ba") { (message, additionalData, isActive) in
//            NSLog("OneSignal Notification opened:\nMessage: %@", message)
//            print(message)
//            if additionalData != nil {
//                NSLog("additionalData: %@", additionalData)
//                // Check for and read any custom values you added to the notification
//                // This done with the "Additonal Data" section the dashbaord.
//                // OR setting the 'data' field on our REST API.
//                if let customKey = additionalData["customKey"] as! String? {
//                    NSLog("customKey: %@", customKey)
//                }
//            }
//        }
        OneSignal.IdsAvailable({ (userId, pushToken) in
            NSLog("UserId:%@", userId)
            NSUserDefaults.standardUserDefaults().setValue(userId, forKey: TravellingConstants.NSUserDefaults.onesignal_userId)
            if (pushToken != nil) {
                NSLog("pushToken:%@", pushToken)
            }
        })
        //onesignal end
        
        //GMSServices.provideAPIKey("AIzaSyAVYSPiyBRdaOskOnKRUoWJw54o3TCgqAE")   //google maps
        GMSServices.provideAPIKey("AIzaSyDjHicSIwW31ITc-f9IEK347ydzWMkOG-E")
        GMSPlacesClient.provideAPIKey("AIzaSyAVYSPiyBRdaOskOnKRUoWJw54o3TCgqAE")   //google places
        
        //nav bar appearance
        UINavigationBar.appearance().barTintColor = UIColor.blackColor()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        //application.statusBarStyle = .LightContent
        //UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
//    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
//        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
//    }
    
//    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
//        
//        FBSDKLoginButton.classForCoder()
//        
//        let faceBook =  FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
//        let google = GIDSignIn.sharedInstance().handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
//        
//        return faceBook || google
//    }
    
    func application(application: UIApplication, openURL url: NSURL, options: [String: AnyObject]) -> Bool { return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as! String, annotation: nil) || GIDSignIn.sharedInstance().handleURL(url, sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String, annotation: options[UIApplicationOpenURLOptionsAnnotationKey] as? String) }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

