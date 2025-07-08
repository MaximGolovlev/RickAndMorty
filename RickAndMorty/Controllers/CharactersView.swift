//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Максим on 08.07.2025.
//

import SwiftUI
import SwiftData

struct CharactersView: View {

    @ObservedObject var vm: CharactersView.ViewModel
    
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
                ForEach(vm.characters) { item in
                    NavigationLink {
                        DetailView(item: item)
                    } label: {
                        AsyncImage(url: URL(string: item.image)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 80, height: 80)
                        .clipShape(.rect(cornerRadius: 8))
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
            if set.contains(where: { vm.characters.last?.id == $0 }) {
                if vm.canLoadMore {
                    vm.currPage += 1
                    vm.fetchCharacters()
                }
            }
        }
    }
    
    struct DetailView: View {
        
        @State var item: MovieCharacter
        
        var body: some View {
            VStack() {
                Text(item.name)
                AsyncImage(url: URL(string: item.image)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 300, height: 300)
                .padding(20)
                Group {
                    Text("Status: " + item.status)
                    Text("Species: " + item.species)
                    Text("Gender: " + item.gender)
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
    let vm = CharactersView.ViewModel(apiManager: am)
    return CharactersView(vm: vm)
        .modelContainer(for: Item.self, inMemory: true)
}

extension CharactersView {
    
    class ViewModel: ObservableObject {
        
        var errorMessage = ""
        @Published var isLoading = false
        @Published var showingAlert = false
        @Published var characters = [MovieCharacter]()
        @Published var currPage = 1
        var canLoadMore: Bool = true
        private var page = APIPage<MovieCharacter>()
        private var apiManager: APIManager
        
        init(apiManager: APIManager) {
            self.apiManager = apiManager
        }
        
        func refetchCharacters() {
            currPage = 1
            characters.removeAll()
            fetchCharacters()
        }
        
        func fetchCharacters() {
            Task { @MainActor in
                do {
                    isLoading = true
                    page = try await apiManager.fetchCharacters(page: currPage)
                    canLoadMore = page.info.next != nil
                    characters.append(contentsOf: page.results)
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
