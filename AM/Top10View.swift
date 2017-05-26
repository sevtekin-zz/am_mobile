//
//  Top10View.swift
//  AMMAC
//
//  Created by Sefa Sevtekin on 3/18/16.
//  Copyright © 2016 Sefa Sevtekin. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class Top10View: UIViewController, NSURLConnectionDelegate, UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDelegate, UITableViewDataSource {
    
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
    
    @IBOutlet weak var resultView: UITableView!
    @IBOutlet weak var yearPicker: UIPickerView!
    @IBOutlet weak var sortSegment: UISegmentedControl!
    var progressView: UIProgressView?
    var progressLabel: UILabel?
    var timer: Timer?
        
    var yearPickerData = ["2014","2015","2016","2017"]
    var sortOrder = "asc"

   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        addControls()
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(Top10View.handleSwipes(_:)))
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(Top10View.handleSwipes(_:)))
        
        rightSwipe.direction = .right
        leftSwipe.direction = .left
        
        view.addGestureRecognizer(rightSwipe)
        view.addGestureRecognizer(leftSwipe)
        
        yearPicker.delegate = self
        yearPicker.dataSource = self
        yearPicker.selectRow(3, inComponent: 0, animated: true)
        grabData()

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Top10CustomCell
        cell.nameLabel.text = entries[(indexPath as NSIndexPath).row].name
        let tmp:NSNumber? = entries[(indexPath as NSIndexPath).row].amount as NSNumber?
        cell.amountLabel.text =  currencyFormatter.string(from: tmp!)
        //cell.amountLabel.text =  currencyFormatter.string(from: NSNumber(entries[(indexPath as NSIndexPath).row].amount))
        //cell.amountLabel.text = "BOGUS"
        if (indexPath as NSIndexPath).row == (entries.count - 1) {
            cell.nameLabel.textColor = UIColor.blue
            cell.amountLabel.textColor = UIColor.blue
            cell.nameLabel.font = UIFont(name:"Noteworthy-Bold", size:14)
            cell.amountLabel.font = UIFont(name:"Noteworthy-Bold", size:14)
        }else{
            cell.nameLabel.textColor = UIColor.black
            cell.amountLabel.textColor = UIColor.black
            cell.nameLabel.font = UIFont(name:"Noteworthy-Bold", size:12)
            cell.amountLabel.font = UIFont(name:"Noteworthy-Bold", size:12)
        }
        return cell

    }
    
    
    func grabData(){
        startProgress()
        var selectedYear =  String(yearPickerData[yearPicker.selectedRow(inComponent: 0)])
        var urlStr = "https://macsevtekin.ddns.net:8443/amservice/v2/reports/top10bycategory/"+selectedYear!+"/" + sortOrder
        defaultManager.request(urlStr, method: .get).responseJSON{response in
                //print(response , " | " , data)
                self.entries = []
                do {
                    if let json = response.result.value as? [String: Any] {
                        let es = json["entries"] as? [[String: AnyObject]]
                        var entry = Entry(name: "default",amount: 0.00)
                        var total = 0.00
                        for e in es! {
                            entry.name = e["category"] as! String
                            entry.amount = e["amount"] as! Double
                            if (self.sortOrder == "asc" && entry.amount<0.00) || (self.sortOrder == "desc" && entry.amount>=0.00) {
                                self.entries.append(entry)
                            }
                            total+=entry.amount
                            //print("added " , entry.name , " | " , entry.amount , " | " , self.entries.count)
                        }
                        print(total)
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(yearPickerData[row], " SELECTED")
        grabData()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return yearPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return yearPickerData[row]
    }
    
    
    
    //added actions
    
    @IBAction func changeSortOrder(_ sender: AnyObject) {
        if sortSegment.selectedSegmentIndex == 0 {
            sortOrder = "asc"
        } else {
            sortOrder = "desc"
        }
        grabData()
    }
    
    
    func handleSwipes(_ sender:UISwipeGestureRecognizer) {
    
        if sender.direction == .right {
            print("RIGHT")
            performSegue(withIdentifier: "goToAccounts", sender: self)
        }
        
        if sender.direction == .left {
            print("LEFT")
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
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(Top10View.updateProgress), userInfo: nil, repeats: true)
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
