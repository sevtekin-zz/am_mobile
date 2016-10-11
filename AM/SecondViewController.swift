//
//  SecondViewController.swift
//  AMMAC
//
//  Created by Sefa Sevtekin on 3/15/16.
//  Copyright © 2016 Sefa Sevtekin. All rights reserved.
//

import UIKit
import Alamofire

class SecondViewController: UIViewController, NSURLConnectionDelegate, UITableViewDelegate, UITableViewDataSource {
    
   
    var accounts: [Account] = []
    var currencyFormatter = NumberFormatter()
    struct Account {
        var name: String
        var amount: Double
    }
    
    @IBOutlet weak var accountSumsTable: UITableView!
   
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let defaultManager: Alamofire.SessionManager = {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "macsevtekin.ddns.net": .disableEvaluation
            //"172.16.120.10": .DisableEvaluation
        ]
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        
        return Alamofire.SessionManager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.accountSumsTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        activityIndicator.stopAnimating()
        grabData()
    }
    
    func grabData(){
        

 
            defaultManager.request("https://macsevtekin.ddns.net:8443/amservice/v2/reports/sumbyowner", method: .get).responseJSON{response in

                //print(response)
                self.accounts = []
                do {
                    if let json = response.result.value as? [String: Any] {
                    let entries = json["entries"] as? [[String: AnyObject]]
                    var account = Account(name: "default",amount: 0.00)
                    var total = 0.00
                        for entry in entries! {
                            account.name = entry["account"] as! String
                            account.amount=entry["amount"] as! Double
                            self.accounts.append(account)
                            total+=account.amount
                            print("added " , account.name , " | " , account.amount , " | " , self.accounts.count)
                        }
                        print(total)
                        let tmp:NSNumber? = total as NSNumber?
                        self.totalLabel.text="TOTAL           " + self.currencyFormatter.string(from: tmp!)!
                        //self.totalLabel.text="TOTAL           " + self.currencyFormatter.stringFromNumber(NSNumber(total))!
                    }
                    
                }catch {
                    print("error serializing JSON: \(error)")
                }
                self.accountSumsTable.reloadData()
        }

        print("Data reloaded")

    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accounts.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        activityIndicator.stopAnimating()
        let cell:UITableViewCell = self.accountSumsTable.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        //print("Adding cell")
       //let tmpStr:String = self.accounts[(indexPath as NSIndexPath).row].name + "       " + currencyFormatter.string(from: NSNumber(self.accounts[(indexPath as NSIndexPath).row].amount))!
        //cell.textLabel!.text = tmpStr
        let tmp:NSNumber? = accounts[(indexPath as NSIndexPath).row].amount as NSNumber?
        cell.textLabel?.text =  currencyFormatter.string(from: tmp!)
        return cell
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\((indexPath as NSIndexPath).row)!")
        
    }
   
    @IBAction func reloadTable(_ sender: AnyObject) {
        grabData()
    }

}

