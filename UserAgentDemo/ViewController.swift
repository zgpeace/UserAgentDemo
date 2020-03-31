//
//  ViewController.swift
//  UserAgentDemo
//
//  Created by zgpeace on 2020/3/27.
//  Copyright © 2020 zgpeace. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    let urlSessionButton: UIButton = UIButton()
    let webViewButton: UIButton = UIButton()
    let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        addSubView()
    }
    
    func addSubView() {
        urlSessionButton.frame = CGRect(x: 100, y: 200, width: 200, height: 50)
        urlSessionButton.setTitle("urlSessionAgent", for: .normal)
        urlSessionButton.setTitleColor(.orange, for: .normal)
        self.view.addSubview(urlSessionButton)
        urlSessionButton.addTarget(self, action: #selector(requestUrlSessionAgent), for: .touchUpInside)
        
        webViewButton.frame = CGRect(x: 100, y: 350, width: 200, height: 50)
        webViewButton.setTitle("webViewUserAgent", for: .normal)
        webViewButton.setTitleColor(.orange, for: .normal)
        self.view.addSubview(webViewButton)
        webViewButton.addTarget(self, action: #selector(requestWebViewAgent), for: .touchUpInside)
        
    }

    @objc func requestUrlSessionAgent() {
        print("requestUrlSessionAgent")
//        let url = URL(string: "https://stackoverflow.com")
//        let url = URL(string: "https://user-agent.me")
        
        let config = URLSessionConfiguration.default
        // default User-Agent: "User-Agent" = "UserAgentDemo/1 CFNetwork/1121.2.1 Darwin/19.2.0";
        // custom User-Agent
        config.httpAdditionalHeaders = ["User-Agent": "zgpeace User-Agent"]
        let session = URLSession(configuration: config)

        let url = URL(string: "https://httpbin.org/anything")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: url) { data, response, error in

            // ensure there is no error for this HTTP response
            guard error == nil else {
                print ("error: \(error!)")
                return
            }
            
            // ensure there is data returned from this HTTP response
            guard let content = data else {
                print("No data")
                return
            }
            
            // serialise the data / NSData object into Dictionary [String : Any]
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                print("Not containing JSON")
                return
            }
            
            print("gotten json response dictionary is \n \(json)")
            // update UI using the response here
        }

        // execute the HTTP request
        task.resume()
        
    }
    
    
    @objc func requestWebViewAgent() {
        print("requestWebViewAgent")
        
        webView.evaluateJavaScript("navigator.userAgent") { (userAgent, error) in
            if let ua = userAgent {
                print("default WebView User-Agent > \(ua)")
            }
            
            // customize User-Agent
            self.webView.customUserAgent = "zgpeace User-Agent"
        }
    }

}

