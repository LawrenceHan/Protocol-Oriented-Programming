//
//  User.swift
//  POP Test
//
//  Created by Hanguang on 16/06/2017.
//  Copyright © 2017 hanguang. All rights reserved.
//

import Foundation

struct User {
    let name: String
    let message: String
    
    init?(data: Data) {
        guard let obj = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return nil
        }
        
        guard let name = obj?["name"] as? String else {
            return nil
        }
        
        guard let message = obj?["message"] as? String else {
            return nil
        }
        
        self.name = name
        self.message = message
    }
}
