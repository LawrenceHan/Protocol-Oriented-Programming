//
//  Decodable.swift
//  POP iOS
//
//  Created by Hanguang on 19/06/2017.
//  Copyright © 2017 hanguang. All rights reserved.
//

import Foundation

protocol Decodable {
    static func parse(data: Data) -> Self?
}
