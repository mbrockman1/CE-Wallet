//
//  CEListView.swift
//  CEWallet
//

import SwiftUI
import SwiftData

struct CEListView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \CEEntry.dateCompleted, order: .reverse) private var entries: [CEEntry]
    @StateObject private var viewModel = CEListViewModel()
    @State private var searchText = "" // State for search query

    // Filtered entries based on search text
    private var filteredEntries: [CEEntry] {
        if searchText.isEmpty {
            return entries
        } else {
            return entries.filter { entry in
                entry.title.lowercased().contains(searchText.lowercased()) ||
                entry.dateCompleted.formatted().lowercased().contains(searchText.lowercased())
            }
        }
    }

    // Group by year (cached in view model)
    private var byYear: [Int: [CEEntry]] {
        viewModel.byYear
    }

    // Pre-computed sorted years to simplify type-checking
    private var sortedYears: [Int] {
        byYear.keys.sorted(by: >)
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(sortedYears, id: \.self) { year in
                    let items = byYear[year] ?? []
                    let totalCredits = items.reduce(0.0) { $0 + $1.credits }
                    Section(header: Text(String(year) + ": " + String(format: "%.1f", totalCredits) + " credits")) {
                        ForEach(items) { entry in
                            NavigationLink(value: entry) {
                                VStack(alignment: .leading) {
                                    Text(entry.title)
                                    Text(entry.dateCompleted, style: .date)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .swipeActions(allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    context.delete(entry)
                                    viewModel.updateGrouping(entries: filteredEntries)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                Button {
                                    viewModel.editingEntry = entry
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                        }
                        .onDelete { offsets in
                            let items = byYear[year] ?? []
                            for idx in offsets {
                                context.delete(items[idx])
                            }
                            viewModel.updateGrouping(entries: filteredEntries)
                        }
                    }
                }
            }
            .navigationTitle("CE Portfolio")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { viewModel.showingAdd = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search by title or date") // Add search bar
            .sheet(isPresented: $viewModel.showingAdd) {
                AddCEEntryView()
                    .onDisappear {
                        viewModel.updateGrouping(entries: filteredEntries)
                    }
            }
            .sheet(item: $viewModel.editingEntry) { entry in
                AddCEEntryView(entry: entry)
                    .onDisappear {
                        viewModel.updateGrouping(entries: filteredEntries)
                    }
            }
            .navigationDestination(for: CEEntry.self) { entry in
                CEDetailView(entry: entry)
            }
            .onAppear {
                viewModel.updateGrouping(entries: filteredEntries)
            }
            .onChange(of: entries) { oldEntries, newEntries in
                viewModel.updateGrouping(entries: filteredEntries)
            }
            .onChange(of: searchText) { oldText, newText in
                viewModel.updateGrouping(entries: filteredEntries)
            }
        }
    }
}

// View model to manage state and grouping
@MainActor
class CEListViewModel: ObservableObject {
    @Published var showingAdd = false
    @Published var editingEntry: CEEntry?
    @Published var byYear: [Int: [CEEntry]] = [:]

    func updateGrouping(entries: [CEEntry]) {
        byYear = Dictionary(grouping: entries) {
            Calendar.current.component(.year, from: $0.dateCompleted)
        }
    }
}
