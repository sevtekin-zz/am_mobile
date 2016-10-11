
import Foundation
import UIKit
import Alamofire
class VelocityView: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
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
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders;
        
        return Alamofire.SessionManager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
    }()
    
    var progressView: UIProgressView?
    var progressLabel: UILabel?
    var timer: Timer?
    var period = "monthly"
    
    
    @IBOutlet weak var resultView: UITableView!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addControls()
        
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(VelocityView.handleSwipes(_:)))
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(VelocityView.handleSwipes(_:)))
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VelocityCustomCell
        cell.nameLabel.text = entries[(indexPath as NSIndexPath).row].name
        //cell.amountLabel.text =  currencyFormatter.string(from: NSNumber(entries[(indexPath as NSIndexPath).row].amount))
        //cell.amountLabel.text = "BOGUS4"
        let tmp:NSNumber? = entries[(indexPath as NSIndexPath).row].amount as NSNumber?
        cell.amountLabel.text =  currencyFormatter.string(from: tmp!)
        return cell
    }
    
    
    func grabData(){

        startProgress()
        let urlStr = "https://macsevtekin.ddns.net:8443/amservice/v2/reports/velocity/" + period
        defaultManager.request(urlStr, method: .get).responseJSON{response in
            //print(response , " | " , data)
            self.entries = []
            do {
                if let json = response.result.value as? [String: Any] {
                    let es = json["entries"] as? [[String: AnyObject]]
                    var entry = Entry(name: "default",amount: 0.00)
                    var total = 0.00
                        for e in es! {
                            entry.name = e["name"] as! String
                            entry.amount = e["value"] as! Double
                            self.entries.append(entry)
                            total+=entry.amount
                            print("added " , entry.name , " | " , entry.amount , " | " , self.entries.count)
                        }
                        self.resultView.reloadData()
                        print("Data reloaded")
                        self.endProgress()
                    }
                    
                } catch {
                    print("error serializing JSON: \(error)")
                }
        }
        
    }
    
    //Added functions
    
    func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        
        if sender.direction == .right {
            print("RIGHT")
        }
        
        if sender.direction == .left {
            print("LEFT")
            performSegue(withIdentifier: "goToAccounts", sender: self)
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
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(VelocityView.updateProgress), userInfo: nil, repeats: true)
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
        progressView?.progress += 0.07
        let progressValue = self.progressView?.progress
        progressLabel?.text = "\(progressValue! * 100) %"
    }
    
    @IBAction func periodChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            period = "monthly"
        } else {
            period="annual"
        }
        grabData()
    }
    
}


