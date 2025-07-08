//
//  LocationsView.swift
//  RickAndMorty
//
//  Created by Максим on 08.07.2025.
//

import SwiftUI

struct LocationsView: View {
    
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        NavigationStack {
            tableView
            .alert(vm.errorMessage, isPresented: $vm.showingAlert) {
                Button("OK", role: .cancel) { }
            }
            .toolbar {
                ToolbarItem() {
                    Button {
                        vm.refetchCharacters()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .navigationTitle("Characters \(vm.currPage)")
            .task {
                vm.fetchCharacters()
            }
            .overlay {
                if vm.isLoading {
                    ProgressView()
                }
            }
        }
    }
    
    var tableView: some View {
        ScrollView {
            LazyVStack {
                ForEach(vm.locations) { item in
                    NavigationLink {
                        DetailView(item: item)
                    } label: {
                        Text(item.name)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                }
            }
            .scrollTargetLayout()
        }
        .onScrollTargetVisibilityChange(idType: MovieCharacter.ID.self, threshold: 0.3) { set in
            if set.contains(where: { vm.locations.last?.id == $0 }) {
                if vm.canLoadMore {
                    vm.currPage += 1
                    vm.fetchCharacters()
                }
            }
        }
    }
    
    struct DetailView: View {
        
        @State var item: MovieLocation
        
        var body: some View {
            VStack() {
                Text(item.name)
                    .padding()
                Group {
                    Text("Type: " + item.type)
                    Text("Dimension: " + item.dimension)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    let am = APIManager.shared
    let vm = LocationsView.ViewModel(apiManager: am)
    return LocationsView(vm: vm)
}

extension LocationsView {
    
    class ViewModel: ObservableObject {
        
        var errorMessage = ""
        @Published var isLoading = false
        @Published var showingAlert = false
        @Published var locations = [MovieLocation]()
        @Published var currPage = 1
        var canLoadMore: Bool = true
        private var page = APIPage<MovieLocation>()
        private var apiManager: APIManager
        
        init(apiManager: APIManager) {
            self.apiManager = apiManager
        }
        
        func refetchCharacters() {
            currPage = 1
            locations.removeAll()
            fetchCharacters()
        }
        
        func fetchCharacters() {
            Task { @MainActor in
                do {
                    isLoading = true
                    page = try await apiManager.fetchLocations(page: currPage)
                    canLoadMore = page.info.next != nil
                    locations.append(contentsOf: page.results)
                    isLoading = false
                } catch {
                    errorMessage = error.localizedDescription
                    showingAlert = true
                    isLoading = false
                }
            }
        }
    }
    
}
