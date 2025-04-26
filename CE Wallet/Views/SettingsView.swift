//
//  SettingsView.swift
//  CEWallet
//
//  Created by Michael Brockman on 4/23/25.
//

import SwiftUI
import SwiftData
import UserNotifications

struct SettingsView: View {
    @AppStorage("useFaceID") private var useFaceID = false
    @Environment(\.modelContext) private var context
    @State private var notifEnabled = false
    @State private var showCEAlert = false
    @State private var showLicAlert = false
    @State private var pdfData: Data? // Store PDF data for sharing
    @State private var pdfFileName: String? // Store file name for sharing

    var body: some View {
        NavigationView {
            Form {
                Section("Security") {
                    Toggle("Lock with Face ID", isOn: $useFaceID)
                }
                Section("Notifications") {
                    HStack {
                        Text("Status:")
                        Spacer()
                        Text(notifEnabled ? "✅" : "❌")
                            .foregroundColor(.secondary)
                    }
                    .onAppear { checkNotif() }
                    
                    if !notifEnabled {
                        Button("Enable Notifications") {
                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
                                DispatchQueue.main.async {
                                    notifEnabled = granted
                                }
                            }
                        }

                        Button("Open Notification Settings") {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                }
                
                Section("Export") {
                    Button("Export CE to PDF") {
                        if let data = PDFExporter.exportCE(context: context) {
                            pdfData = data
                            pdfFileName = "CE_Summary.pdf"
                            showCEAlert = true
                        } else {
                            print("Failed to generate CE PDF")
                        }
                    }
                    Button("Export Licenses to PDF") {
                        if let data = PDFExporter.exportLicenses(context: context) {
                            pdfData = data
                            pdfFileName = "License_Summary.pdf"
                            showLicAlert = true
                        } else {
                            print("Failed to generate License PDF")
                        }
                    }
                }
                Section(header: Text("Legal")){
                    NavigationLink("Disclaimer", destination: DisclaimerView())
                    NavigationLink("About Me", destination: AboutMeView())
                    NavigationLink("License", destination: LicenseView())
                }
            }
            .navigationTitle("Settings")
            .alert("PDF Exporting...", isPresented: $showCEAlert) {
                Button("OK", role: .cancel) { pdfData = nil; pdfFileName = nil }
            }
            .alert("PDF Exporting...", isPresented: $showLicAlert) {
                Button("OK", role: .cancel) { pdfData = nil; pdfFileName = nil }
            }
            .sheet(item: Binding(
                get: { pdfData != nil && pdfFileName != nil ? PDFShareItem(data: pdfData!, fileName: pdfFileName!) : nil },
                set: { _ in pdfData = nil; pdfFileName = nil }
            )) { item in
                ActivityView(data: item.data, fileName: item.fileName)
            }

        }
    }

    private func checkNotif() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                notifEnabled = settings.authorizationStatus == .authorized
            }
        }
    }
}

// Identifiable struct for sheet binding
struct PDFShareItem: Identifiable {
    let id = UUID()
    let data: Data
    let fileName: String
}

// UIViewControllerRepresentable for UIActivityViewController
struct ActivityView: UIViewControllerRepresentable {
    let data: Data
    let fileName: String

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        do {
            try data.write(to: url)
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            return activityVC
        } catch {
            print("Failed to write PDF to temporary file: \(error)")
            return UIActivityViewController(activityItems: [], applicationActivities: nil)
        }
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
