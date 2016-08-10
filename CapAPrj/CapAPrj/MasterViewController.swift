//
//  MasterViewController.swift
//  CapAPrj
//
//  Created by Ting on 16/7/13.
//  Copyright © 2016年 Ting. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [[String:String]]()
    var responseStatusCode = [String:String]()
    //var urlString:String = ""
    var urlString = [String]()
    var urlObj:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "fishing")
        self.refreshControl!.addTarget(self, action: #selector(MasterViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let delegateObj = delegate.objects
        if !delegateObj.isEmpty{
            showInput(delegateObj)
        }else{
            showRawData()
        }
        // 03.08.16
        
    }
    
    func showInput(delegateObj:[String:String]){
 
        if let vin = delegateObj["vin"]{
            if let time = delegateObj["time"]{
                let date = (time as NSString).substringToIndex(10)
                if let respC = delegateObj["responsecode"]{
                    if navigationController?.tabBarItem.tag == 0{
                        let obj = ["key":respC, "date":date, "URL":"", "mode":"responsecode"]
                        objects.append(obj)
                    }else if navigationController?.tabBarItem.tag == 1{
                        let obj = ["key":vin, "date":date, "URL":"", "mode":"vin"]
                        objects.append(obj)
                    }else{
                        let obj = ["key":time, "date":date, "URL":"", "mode":"time"]
                        objects.append(obj)
                    }
                        
                }
            }
        }
        tableView.reloadData()
    }
    
    func showRawData(){
        let calendar = NSCalendar.autoupdatingCurrentCalendar()
        let mm = calendar.dateByAddingUnit(.Year, value: 0, toDate: NSDate(), options: [])
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.stringFromDate(mm!)
        
        //let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString.append("http://192.168.99.100:32768/json/responsecode" + date)
            urlObj = urlString[0]
            loaddata(urlObj)
        } else if navigationController?.tabBarItem.tag == 1 {
            urlString.append("http://192.168.99.100:32768/json/vin" + date)
            urlObj = urlString[0]
            loaddata(urlObj)
        }else {
            for i in 0..<10 {
                let calendar = NSCalendar.autoupdatingCurrentCalendar()
                let mm = calendar.dateByAddingUnit(.Day, value: -i, toDate: NSDate(), options: [])
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = dateFormatter.stringFromDate(mm!)
                urlString.append("http://192.168.99.100:32768/json/time" + date)
                urlObj = urlString[i]
                loaddata(urlObj)
            }
        }
    }
    
    func refresh(sender: AnyObject){
        objects.removeAll()
        for i in 0..<urlString.count{
            urlObj = urlString[i]
            loaddata(urlString[i])
        }
        self.refreshControl!.endRefreshing()
    }
    
    func loaddata(urlString: String){
        if let url = NSURL(string: urlString){
            if let data = try? NSData(contentsOfURL: url, options: []){
                let json = JSON(data: data)
                
                parseJSON(json)
                
            }
        }
    }
    
    func parseJSON(json: JSON) {
        
        for uniqueValue in json["results"]["unique value"].arrayValue{
            //print(uniqueValue)
            let date = json["results"]["date"].stringValue
            let mode = json["results"]["mode"].stringValue
            let obj = ["key": String(uniqueValue), "date": date, "URL": urlObj, "mode": mode]
            objects.append(obj)
        }
        
        tableView.reloadData()
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                //print(object)
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //if !delegate.objects.isEmpty{
            //let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
           // let object = delegate.objects
           // cell.textLabel!.text = object["vin"]
            //print("hello")
            //print(delegate.objects)
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let object = objects[indexPath.row]
        cell.textLabel!.text = object["key"]
        cell.detailTextLabel!.text = object["date"]
        
        
        return cell
    }

}

