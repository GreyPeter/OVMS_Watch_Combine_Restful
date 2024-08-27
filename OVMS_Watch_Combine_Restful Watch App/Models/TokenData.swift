//
//  TokenData.swift
//  OV-Watch-Combine Watch App
//
//  Created by Peter Harry on 10/9/2022.
//

import Foundation

struct Token: Decodable {
    var application: String
    var owner: String
    var permit: String
    var purpose: String
    var token: String

    static let initial: Token = Token(application: "", owner: "", permit: "", purpose: "", token: "")
}

struct TokenDel: Decodable {
    var owner: String
    var token: String
}
