//
//  SwiftUIView.swift
//  RickAndMorty
//
//  Created by Максим on 08.07.2025.
//

import SwiftUI
import NetworkService

struct MainView: View {
    var body: some View {
        TabView {
            Tab("Characters", systemImage: "list.dash") {
                let am = APIManager.shared
                let vm = CharactersView.ViewModel(apiManager: am)
                CharactersView(vm: vm)
            }
            Tab("Locations", systemImage: "list.dash") {
                let am = APIManager.shared
                let vm = LocationsView.ViewModel(apiManager: am)
                LocationsView(vm: vm)
            }
        }
    }
}

#Preview {
    MainView()
}

