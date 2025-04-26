//
//  AddCEEntryView.swift
//  CEWallet
//

import SwiftUI
import SwiftData
import PhotosUI
import UniformTypeIdentifiers

struct AddCEEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    let entry: CEEntry?

    @State private var title: String
    @State private var dateCompleted: Date
    @State private var creditsText: String
    @State private var receiptCode: String
    @State private var notes: String // New state for notes
    @State private var pickedImages: [PhotosPickerItem] = []
    @State private var tempFiles: [CEFile] = []

    init(entry: CEEntry? = nil) {
        self.entry = entry
        _title         = State(initialValue: entry?.title ?? "")
        _dateCompleted = State(initialValue: entry?.dateCompleted ?? Date())
        _creditsText   = State(initialValue: entry.map { String($0.credits) } ?? "")
        _receiptCode   = State(initialValue: entry?.receiptCode ?? "")
        _notes         = State(initialValue: entry?.notes ?? "") // Initialize notes
    }

    var body: some View {
        NavigationView {
            Form {
                Section("Details") {
                    TextField("Title", text: $title)
                    DatePicker("Date Completed", selection: $dateCompleted, displayedComponents: .date)
                    TextField("Credits", text: $creditsText)
                        .keyboardType(.decimalPad)
                    TextField("Receipt / Confirmation Code", text: $receiptCode)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                }

                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                }

                Section("Attachments") {
                    PhotosPicker(
                        selection: $pickedImages,
                        maxSelectionCount: 0,
                        matching: .images
                    ) {
                        Label("Add Images", systemImage: "photo.on.rectangle")
                    }
                    Button {
                        showPDFPicker = true
                    } label: {
                        Label("Add PDFs", systemImage: "doc")
                    }
                    ForEach(allFiles, id: \.id) { file in
                        AttachmentRow(file: file)
                    }
                    .onDelete(perform: deleteFiles)
                }
            }
            .navigationTitle(entry == nil ? "Add CE" : "Edit CE")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: { dismiss() })
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveEntry()
                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
            .fileImporter(
                isPresented: $showPDFPicker,
                allowedContentTypes: [.pdf],
                allowsMultipleSelection: true
            ) { result in
                if case .success(let urls) = result {
                    for url in urls {
                        if url.startAccessingSecurityScopedResource() {
                            defer { url.stopAccessingSecurityScopedResource() }
                            let coordinator = NSFileCoordinator()
                            var coordError: NSError?
                            coordinator.coordinate(readingItemAt: url, options: [], error: &coordError) { securedURL in
                                if let data = try? Data(contentsOf: securedURL) {
                                    let file = CEFile(
                                        fileData: data,
                                        fileName: securedURL.lastPathComponent
                                    )
                                    tempFiles.append(file)
                                }
                            }
                            if let coordError { print("File coordination error:", coordError) }
                        } else {
                            print("Could not access PDF at \(url)")
                        }
                    }
                }
            }
            .onChange(of: pickedImages) { _, newItems in
                loadImages(newItems)
            }        }
    }

    @State private var showPDFPicker = false

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        Double(creditsText) != nil
    }

    private var allFiles: [CEFile] {
        (entry?.files ?? []) + tempFiles
    }

    private func loadImages(_ items: [PhotosPickerItem]) {
        for item in items {
            item.loadTransferable(type: Data.self) { result in
                if case .success(let data?) = result {
                    let file = CEFile(fileData: data, fileName: "img_\(UUID()).jpg")
                    tempFiles.append(file)
                }
            }
        }
        pickedImages.removeAll()
    }

    private func deleteFiles(at offsets: IndexSet) {
        guard let entry = entry else {
            tempFiles.remove(atOffsets: offsets)
            return
        }
        for idx in offsets {
            context.delete(entry.files[idx])
        }
    }

    private func saveEntry() {
        let credits = Double(creditsText) ?? 0
        if let existing = entry {
            existing.title         = title
            existing.dateCompleted = dateCompleted
            existing.credits       = credits
            existing.receiptCode   = receiptCode.isEmpty ? nil : receiptCode
            existing.notes         = notes.isEmpty ? nil : notes // Handle empty notes
            tempFiles.forEach { existing.files.append($0) }
        } else {
            let newEntry = CEEntry(
                title: title,
                dateCompleted: dateCompleted,
                credits: credits,
                receiptCode: receiptCode.isEmpty ? nil : receiptCode,
                notes: notes.isEmpty ? nil : notes, // Handle empty notes
                files: tempFiles
            )
            context.insert(newEntry)
        }
    }
}

struct AttachmentRow: View {
    let file: CEFile
    var body: some View {
        HStack {
            if file.isPDF {
                Image(systemName: "doc.fill")
            } else if let img = UIImage(data: file.fileData) {
                Image(uiImage: img)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
            }
            Text(file.fileName)
                .lineLimit(1)
        }
    }
}
