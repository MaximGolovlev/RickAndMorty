//
//  RickAndMortyTests.swift
//  RickAndMortyTests
//
//  Created by Максим on 08.07.2025.
//

import Testing
@testable import RickAndMorty

struct RickAndMortyTests {

    @Test("Check character's pagination", arguments: [1,2,3,4])
    func checkCharacters(page: Int) async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        
        let chars = try await APIManager.shared.fetchCharacters(page: page)
        
        #expect(chars.results.count > 0)
        
        if page == 1 {
            #expect(chars.results[0].name == "Rick Sanchez")
        }
        
        if page == 2 {
            #expect(chars.results[0].name == "Aqua Morty")
        }
        
        if page == 3 {
            #expect(chars.results[0].name == "Big Boobed Waitress")
        }
        
        if page == 4 {
            #expect(chars.results[0].name == "Campaign Manager Morty")
        }
        
    }

}
