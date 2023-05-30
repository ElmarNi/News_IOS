//
//  NewsResponse.swift
//  News
//
//  Created by Elmar Ibrahimli on 29.05.23.
//

import Foundation

struct NewsResponse: Codable {
    let status: String
    let results: [News]
    let nextPage: String?
}
