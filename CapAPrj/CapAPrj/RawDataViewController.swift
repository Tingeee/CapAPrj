//
//  RawDataViewController.swift
//  CapAPrj
//
//  Created by Ting on 16/7/24.
//  Copyright © 2016年 Ting. All rights reserved.
//

import UIKit
import WebKit

class RawDataViewController: UIViewController {

    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem
        
        if let url = NSURL(string: "http://192.168.99.100:32768/json/cep_access_log") {
            do {
                let contents = try String(contentsOfURL: url, usedEncoding: nil)
                var html = "<html>"
                html += "<head1>"
                html += "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">"
                html += "<style> table { font-size: 100%; } </style>"
                html += "</head1>"
                html += "<body>"
                html += "<table>"
                for s in contents.componentsSeparatedByString("\n"){
                    html += "<tr><td>"+s+"</td></tr>"
                }
                html += "</table>"
                html += "</body>"
                html += "</html>"
                webView.loadHTMLString(html, baseURL: nil)
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad!
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        navigationController?.popViewControllerAnimated(true)
    }

}
