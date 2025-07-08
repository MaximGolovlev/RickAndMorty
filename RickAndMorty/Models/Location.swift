//
//  Location.swift
//  RickAndMorty
//
//  Created by Максим on 08.07.2025.
//

struct MovieLocation: Codable, Identifiable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
}
