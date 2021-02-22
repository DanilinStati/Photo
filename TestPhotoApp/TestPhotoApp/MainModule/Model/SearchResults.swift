//
//  SearchResults.swift
//  TestPhotoApp
//
//  Created by Даниил Статиев on 15.02.2021.
//

import Foundation

struct SearchResults: Decodable {
    
    let total: Int
    let results: [UnsplashPhoto]
    
}

struct UnsplashPhoto: Decodable {
    let created_at: Date?
    let width: Int
    let height: Int
    let description: String?
    let likes: Int?
    let urls: [URLKind.RawValue: String]
    
    enum URLKind: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
    
}

