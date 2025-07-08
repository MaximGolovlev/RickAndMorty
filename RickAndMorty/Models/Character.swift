//
//  Character.swift
//  RickAndMorty
//
//  Created by Максим on 08.07.2025.
//

import Foundation

struct MovieCharacter: Codable, Identifiable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let image: String
    let url: String
}
