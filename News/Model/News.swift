//
//  News.swift
//  News
//
//  Created by Elmar Ibrahimli on 29.05.23.
//

import Foundation

struct News: Codable {
    let title: String
    let creator: [String]?
    let description: String
    let content: String
    let pubDate: String
    let image_url: String?
}
