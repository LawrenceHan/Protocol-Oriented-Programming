//
//  main.swift
//  POP Test
//
//  Created by Hanguang on 16/06/2017.
//  Copyright © 2017 hanguang. All rights reserved.
//

import Foundation

print("Hello, World!")

let request = UserRequest(name: "Lawrence")
request.send { (user) in
    if let user = user {
        print("\(user.message) from \(user.name)")
    }
}

