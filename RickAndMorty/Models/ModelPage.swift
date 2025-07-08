//
//  ModelPage.swift
//  RickAndMorty
//
//  Created by Максим on 08.07.2025.
//


struct APIPage<T: Codable>: Codable {
    var info = PageInfo()
    var results: [T] = []
}


struct PageInfo: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
    
    init() {
        self.count = 0
        self.pages = 0
        self.next = nil
        self.prev = nil
    }
}
