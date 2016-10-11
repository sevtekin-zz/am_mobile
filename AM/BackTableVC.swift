//
//  BackTableVC.swift
//  AM
//
//  Created by Sefa Sevtekin on 3/30/16.
//  Copyright © 2016 Sefa Sevtekin. All rights reserved.
//

import Foundation
import UIKit


class BackTableVC: UITableViewController {
    var TableArray = [String]()
    
    override func viewDidLoad() {
        TableArray = ["Accounts","Top 10","Velocity", "Annual Trends"]
        self.tableView.delegate = self
        self.view.backgroundColor = UIColor.lightGray
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableArray[(indexPath as NSIndexPath).row],for: indexPath) as UITableViewCell
        
        cell.textLabel!.text = TableArray[(indexPath as NSIndexPath).row]
        
        return cell
    }
    
    override var shouldAutorotate : Bool {
        print("++++++++++++++++++++++++++++ should have done this")
        return true
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        var identifier = ""
//        print("----------------------- TABLE " + TableArray[indexPath.row])
//        
//        switch TableArray[indexPath.row] {
//        case "Accounts":
//            identifier = "AccountsView"
//        case "Top10":
//            identifier = "Top10View"
//        case "Velocity":
//            identifier = "VelocityView"
//        case "Annual Trends":
//            identifier = "AnnualTrendsView"
//        default:
//            identifier = "AccountsView"
//        }
//        print("----------------------- IDENTIFIER " + identifier)
//        
//        let dest = storyBoard.instantiateViewControllerWithIdentifier(identifier) as UIViewController
//        self.presentViewController(dest, animated:true, completion:nil)
//        
//    }
    
}
