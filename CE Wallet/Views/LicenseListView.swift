//
//  LicenseListView.swift
//  CEWallet
//

import SwiftUI
import SwiftData

// File-level sort descriptor
private let licenseIssuanceSort: [SortDescriptor<LicenseEntry>] = [
    SortDescriptor(\LicenseEntry.issuanceDate, order: .reverse)
]

struct LicenseListView: View {
    @Environment(\.modelContext) private var context

    // Query with sort; no filter
    @Query(filter: nil, sort: licenseIssuanceSort) private var licenses: [LicenseEntry]

    @StateObject private var viewModel = LicenseListViewModel()

    init() {
        // Initialize the @Query property
        _licenses = Query(filter: nil, sort: licenseIssuanceSort)
    }

    var body: some View {
        NavigationStack {
            List {
                if viewModel.filteredLicenses.isEmpty {
                    ContentUnavailableView(
                        licenses.isEmpty ? "No Licenses Yet" : "No Matches",
                        systemImage: "doc.text",
                        description: Text(licenses.isEmpty ? "Tap + to add your first license." : "Try a different search.")
                    )
                    .listRowSeparator(.hidden)
                }
                ForEach(viewModel.filteredLicenses) { entry in
                    NavigationLink {
                        LicenseDetailView(entry: entry)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(entry.title)
                            Text("Expires: \(entry.expirationDate, style: .date)")
                                .foregroundColor(viewModel.isExpiringSoon(entry) ? .red : .secondary)
                        }
                    }
                    .swipeActions(allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            NotificationManager.shared.cancelNotification(for: entry)
                            context.delete(entry)
                            viewModel.updateFilteredLicenses(licenses: licenses)
                            AnalyticsManager.shared.logEvent(AnalyticsEvent.licenseDeleted)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        Button {
                            viewModel.editingLicense = entry
                            viewModel.showEditSheet = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
                }
                .onDelete { offsets in
                    offsets.map { viewModel.filteredLicenses[$0] }.forEach {
                        NotificationManager.shared.cancelNotification(for: $0)
                        context.delete($0)
                        AnalyticsManager.shared.logEvent(AnalyticsEvent.licenseDeleted)
                    }
                    viewModel.updateFilteredLicenses(licenses: licenses)
                }
            }
            .navigationTitle("Licenses")
            .searchable(text: $viewModel.searchText)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.isAdding = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            // Add sheet for new entry
            .sheet(isPresented: $viewModel.isAdding) {
                AddLicenseEntryView()
                    .onDisappear {
                        viewModel.updateFilteredLicenses(licenses: licenses)
                    }
            }
            // Sheet for editing
            .sheet(isPresented: $viewModel.showEditSheet) {
                AddLicenseEntryView(entry: viewModel.editingLicense)
                    .onDisappear {
                        viewModel.updateFilteredLicenses(licenses: licenses)
                    }
            }
            // Update filtered list when searchText changes
            .onChange(of: viewModel.searchText) { _, _ in
                viewModel.updateFilteredLicenses(licenses: licenses)
            }
            // Initial populate when view appears
            .onAppear {
                viewModel.updateFilteredLicenses(licenses: licenses)
                AnalyticsManager.shared.logScreenView("License List")
            }
            // Re-populate whenever the data changes
            .onChange(of: licenses) { _, newLicenses in
                viewModel.updateFilteredLicenses(licenses: newLicenses)
            }
        }
    }
}

// View model to manage state and search
@MainActor
class LicenseListViewModel: ObservableObject {
    @Published var isAdding = false
    @Published var showEditSheet = false
    @Published var editingLicense: LicenseEntry?
    @Published var searchText = ""
    @Published var filteredLicenses: [LicenseEntry] = []

    func updateFilteredLicenses(licenses: [LicenseEntry]) {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            filteredLicenses = licenses
        } else {
            let query = searchText.lowercased()
            filteredLicenses = licenses.filter {
                $0.title.lowercased().contains(query)
            }
        }
    }

    func isExpiringSoon(_ entry: LicenseEntry) -> Bool {
        let days = Calendar.current.dateComponents([.day], from: Date(), to: entry.expirationDate).day ?? 365
        return days <= 30
    }
}
