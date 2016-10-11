//
//  Accounts.swift
//  AMMAC
//
//  Created by Sefa Sevtekin on 3/17/16.
//  Copyright © 2016 Sefa Sevtekin. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
class AccountsView: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var entries: [Entry] = []
    var currencyFormatter = NumberFormatter()
    struct Entry {
        var name: String
        var amount: Double
    }
    
    let defaultManager: Alamofire.SessionManager = {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "macsevtekin.ddns.net": .disableEvaluation
        ]
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        
        return Alamofire.SessionManager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(AccountsView.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()


    @IBOutlet weak var resultView: UITableView!
    var progressView: UIProgressView?
    var progressLabel: UILabel?
    var timer: Timer?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addControls()
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        
        self.resultView.addSubview(self.refreshControl)
        self.resultView.alwaysBounceVertical = true
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(AccountsView.handleSwipes(_:)))
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(AccountsView.handleSwipes(_:)))
        
        rightSwipe.direction = .right
        leftSwipe.direction = .left
        
        view.addGestureRecognizer(rightSwipe)
        view.addGestureRecognizer(leftSwipe)
        
        grabData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        cell.nameLabel.text = entries[(indexPath as NSIndexPath).row].name
        let tmp:NSNumber? = entries[(indexPath as NSIndexPath).row].amount as NSNumber?
        cell.amountLabel.text =  currencyFormatter.string(from: tmp!)
        //cell.amountLabel.text="BOGUS3"
        if (indexPath as NSIndexPath).row == (entries.count - 1) {
            cell.nameLabel.textColor = UIColor.blue
            cell.amountLabel.textColor = UIColor.blue
            cell.nameLabel.font = UIFont(name:"Noteworthy-Bold", size:16)
            cell.amountLabel.font = UIFont(name:"Noteworthy-Bold", size:16)
        }
        
        
        return cell
    }
    
    
    func grabData(){
        /*
        startProgress()
        defaultManager.request("https://macsevtekin.ddns.net:8443/am/service/v2/reports/sumbyowner")
            .response{ request,response,data,error in
                //print(response)
                self.entries = []
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(NSData(data: data!), options: .AllowFragments)
                    //print("parsed")
                    var entry = Entry(name: "default",amount: 0.00)
                    var total = 0.00
                    if let es = json["entries"] as? [[String: AnyObject]] {
                        for e in es {
                            entry.name = e["account"] as! String
                            entry.amount = e["amount"] as! Double
                            self.entries.append(entry)
                            total+=entry.amount
                        }
                    entry.amount = total
                    entry.name = "TOTAL"
                    self.entries.append(entry)
                    self.resultView.reloadData()
                    self.endProgress()
                    print("Data reloaded")
                    }
                } catch {
                    print("error serializing JSON: \(error)")
                }
        }
        */
        
        startProgress()
        defaultManager.request("https://macsevtekin.ddns.net:8443/amservice/v2/reports/sumbyowner", method: .get).responseJSON{response in
                //print(response)
                self.entries = []
                do {
                    if let json = response.result.value as? [String: Any] {
                        let es = json["entries"] as? [[String: AnyObject]]
                        var entry = Entry(name: "default",amount: 0.00)
                        var total = 0.00
                        for e in es! {
                            entry.name = e["account"] as! String
                            entry.amount = e["amount"] as! Double
                            self.entries.append(entry)
                            total+=entry.amount
                        }
                        entry.amount = total
                        entry.name = "TOTAL"
                        self.entries.append(entry)
                        self.resultView.reloadData()
                        self.endProgress()
                        print("Data reloaded")
                    }
                } catch {
                    print("error serializing JSON: \(error)")
                }
        }

    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        grabData()
        refreshControl.endRefreshing()
    }
    
    func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        
        if sender.direction == .right {
            print("RIGHT")
            performSegue(withIdentifier: "goToVelocity", sender: self)
        }
        
        if sender.direction == .left {
            print("LEFT")
            performSegue(withIdentifier: "goToTop10", sender: self)
        }
        
    }
    
    
    func addControls() {
        // Create Progress View Control
        progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.default)
        progressView?.center = self.view.center
        view.addSubview(progressView!)
        
        // Add Label
        progressLabel = UILabel()
        let frame = CGRect(x: view.center.x - 25, y: view.center.y - 40, width: 100, height: 50)
        progressLabel?.frame = frame
        view.addSubview(progressLabel!)
        self.progressLabel?.isHidden = true
        self.progressView?.isHidden = true
    }
    
    
    func startProgress() {
        print("STARTING")
        self.progressLabel?.isHidden = false
        self.progressView?.isHidden=false
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(AccountsView.updateProgress), userInfo: nil, repeats: true)
    }
    func endProgress() {
        print("ENDING")
        progressView?.progress = 0.0
        progressLabel?.text = "0 %"
        timer?.invalidate()
        self.progressLabel?.isHidden = true
        self.progressView?.isHidden=true
    }
    
    
    func updateProgress() {
        progressView?.progress += 0.23
        let progressValue = self.progressView?.progress
        progressLabel?.text = "\(progressValue! * 100) %"
    }
    
}
