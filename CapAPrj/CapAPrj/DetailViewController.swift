import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var objects = [String]()
    var detailItem: [String: String]!
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard detailItem != nil else { return }
        if let urlString = detailItem["URL"]{
            if urlString.isEmpty{
                if let mode = detailItem["mode"]{
                    if let date = detailItem["date"]{
                        parseInput(mode)
                        htmlmodel(date)
                    }
                }
            }
            else{
                if let url = NSURL(string: urlString){
                    if let data = try? NSData(contentsOfURL: url, options: []){
                        let json = JSON(data: data)
                        if let key = detailItem["key"]{
                            if let date = detailItem["date"]{
                                if let mode = detailItem["mode"]{
                                    parseJSON(json,key: key,mode: mode)
                                    htmlmodel(date)
                                }
                            }
                        }
                    
                    }
                }
            }
        }
    }
    
    func htmlmodel(date: String){
        var html = "<html>"
        html += "<head1>"
        html += "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">"
        html += "<style> table.one,tr{ font-size: \"lem\"; font-family:\"Trebuchet MS\";  border-spacing: 5px; padding: 5px; border-bottom:0.5px solid black}  table.two,td { font-size: 110%; font-family:\"Trebuchet MS\"; border-spacing: 5px; padding: 5px;}</style>"
        html += "</head1>"
        html += "<body>"
        html += "<table class = \"one\">"
        html += "<tr><td>"+date+"</td></tr>"
        html += "</table>"
        html += "<table class = \"two\">"
        for obj in objects.reverse(){
            html += obj
        }
        html += "</table>"
        html += "</body>"
        html += "</html>"
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    func parseInput(mode:String){
        var key1: String
        var key2: String
        var key3: String
        var key4: String
        
        if mode == "responsecode"{
            key1 = "url"
            key2 = "vin"
            key3 = "time"
            key4 = "none"
        } else if mode == "vin" {
            key1 = "url"
            key2 = "responsecode"
            key3 = "time"
            key4 = "none"
        }else{
            key1 = "responsecode"
            key2 = "vin"
            key3 = "time"
            key4 = "url"
        }
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let delegateObj = delegate.objects
        if let para1 = delegateObj[key1]{
            if let para2 = delegateObj[key2]{
                if let para3 = delegateObj[key3]{
                    if let para4 = delegateObj[key4]{
                        let obj = "<tr><td>"+para3+"</td><td>"+para2+"</td><td>"+para1+"</td><td>"+para4+"</td></tr>"
                        objects.append(obj)
                    }
                }
            }
        }
    }
    
    func parseJSON(json: JSON, key: String, mode:String){
        var key1: String
        var key2: String
        var key3: String
        var key4: String
        
        if mode == "responsecode"{
            key1 = "url"
            key2 = "vin"
            key3 = "time"
            key4 = ""
        } else if mode == "vin" {
            key1 = "url"
            key2 = "response code"
            key3 = "time"
            key4 = ""
        }else{
            key1 = "response code"
            key2 = "vin"
            key3 = "time"
            key4 = "url"
        }
        
        for  data in json["results"][mode][key].arrayValue{
            let para1 = data[key1].stringValue
            let para2 = data[key2].stringValue
            let para3 = data[key3].stringValue
            let para4 = data[key4].stringValue
            //print (para4)
            let obj = "<tr><td>"+para3+"</td><td>"+para2+"</td><td>"+para1+"</td><td>"+para4+"</td></tr>"
            //print(obj)
            objects.append(obj)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "show" {
            
        }
    }
    
    @IBAction func delegateObjRmove(sender: AnyObject) {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.objects.removeAll()
        //print(delegate.objects)
        
    }
    
}
