//
//  APICalls.swift
//  RickAndMorty
//
//  Created by Максим on 08.07.2025.
//


extension APIManager {
    
    func fetchCharacters(page: Int) async throws -> APIPage<MovieCharacter> {
        let request = APIRequest(httpType: .GET,
                                 path: "/api/character/",
                                 query: [("page", String(page))],
                                 errorTitle: "Failed to fetchCharacters",
                                 className: "Character")
        return try await makeRequest(request: request)
    }
    
    func fetchLocations(page: Int) async throws -> APIPage<MovieLocation> {
        let request = APIRequest(httpType: .GET,
                                 path: "/api/location/",
                                 query: [("page", String(page))],
                                 errorTitle: "Failed to fetchLocations",
                                 className: "MovieLocation")
        return try await makeRequest(request: request)
    }
    
}
