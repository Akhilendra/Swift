//
//  sidebarTableVC.swift
//  Travelling
//
//  Created by Muskan on 8/10/16.
//  Copyright © 2016 Muskan. All rights reserved.
//

import UIKit

class sidebarTableVC: UITableViewController {
    
    var myArray = ["","compare","bookings","rides","rate","share","partners","about","logout"]
    var myArray2 = ["","Compare & Book","My Bookings","My Rides","Rate Us","Share","Partners","About","Logout"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //tableView.backgroundColor = UIColor.redColor()
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 140
        } else {
            return 40
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = UITableViewCell()
        //cell.backgroundColor = UIColor.whiteColor()
        if indexPath.row != 0 {
        cell = tableView.dequeueReusableCellWithIdentifier(myArray[indexPath.row], forIndexPath: indexPath)
        cell.textLabel?.text = myArray2[indexPath.row]
        }
        if indexPath.row == 0 {
            cell = sidebarFirstCell()
            cell = tableView.dequeueReusableCellWithIdentifier("userProfile", forIndexPath: indexPath) as! sidebarFirstCell
            cell.backgroundColor = UIColor(red: 239/255, green: 64/255, blue: 42/255, alpha: 1.0)
            //cell.imgUser.image = UIImage(named: "dride-transparent")
            //cell.lbl
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 8 {
            let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("loginVC") as UIViewController
            self.presentViewController(viewController, animated: true, completion: nil)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
