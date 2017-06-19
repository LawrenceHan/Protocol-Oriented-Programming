//
//  Client.swift
//  POP iOS
//
//  Created by Hanguang on 19/06/2017.
//  Copyright © 2017 hanguang. All rights reserved.
//

import Foundation

protocol Client {
    func send<T: Request>(_ r: T, handler: @escaping (T.Response?) -> Void)
    
    var host: String { get }
}

struct URLSessionClient: Client {
    let host = "https://api.onevcat.com"
    
    func send<T: Request>(_ r: T, handler: @escaping (T.Response?) -> Void) {
        let url = URL(string: host.appending(r.path))!
        var request = URLRequest(url: url)
        request.httpMethod = r.method.rawValue
        
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            let dict = ["name": url.lastPathComponent, "message": "Hello!"]
            let d = try! JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            if let res = T.Response.parse(data: d) {
                DispatchQueue.main.async { handler(res) }
            } else {
                DispatchQueue.main.async { handler(nil) }
            }
        }
        task.resume()
    }
}
