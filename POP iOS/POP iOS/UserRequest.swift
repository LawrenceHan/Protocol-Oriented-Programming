//
//  UserRequest.swift
//  POP Test
//
//  Created by Hanguang on 16/06/2017.
//  Copyright © 2017 hanguang. All rights reserved.
//

import Foundation

struct UserRequest: Request {
    let name: String
    
    let host: String = "https://api.onevcat.com"
    var path: String {
        return "/users/\(name)"
    }
    let method: HTTPMethod = .GET
    let parameter: [String: Any] = [:]
    
    typealias Response = User
    func parse(data: Data) -> User? {
        return User(data: data)
    }
}
