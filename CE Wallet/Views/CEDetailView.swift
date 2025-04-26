//
//  CEDetailView.swift
//  CEWallet
//

import SwiftUI
import PDFKit

struct CEDetailView: View {
    let entry: CEEntry
    @State private var selectedAttachment: Attachment?

    private struct Attachment: Identifiable {
        let id = UUID()
        let fileData: Data
        let isPDF: Bool
    }

    var body: some View {
        List {
            Section("Details") {
                Text(entry.title)
                Text(entry.dateCompleted, style: .date)
                Text("\(String(format: "%.1f", entry.credits)) credits")
                if let code = entry.receiptCode, !code.isEmpty {
                    Text("Confirmation Code: \(code)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            if let notes = entry.notes, !notes.isEmpty {
                Section("Notes") {
                    Text(notes)
                        .font(.body)
                        .foregroundColor(.primary)
                }
            }

            Section("Attachments") {
                ForEach(Array(entry.files.enumerated()), id: \.element.id) { index, file in
                    Button(action: {
                        selectedAttachment = Attachment(fileData: file.fileData, isPDF: file.isPDF)
                    }) {
                        HStack {
                            Text("Item \(index + 1)")
                                .foregroundColor(.primary)
                            Spacer()
                            if file.isPDF {
                                if let pdfDoc = PDFDocument(data: file.fileData),
                                   let page = pdfDoc.page(at: 0) {
                                    let thumbnail = page.thumbnail(
                                        of: CGSize(width: 50, height: 50),
                                        for: .mediaBox
                                    )
                                    Image(uiImage: thumbnail)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .padding(.vertical, 4)
                                } else {
                                    Image(systemName: "exclamationmark.triangle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.red)
                                        .padding(.vertical, 4)
                                }
                            } else {
                                if let uiImage = UIImage(data: file.fileData),
                                   uiImage.size != .zero {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .padding(.vertical, 4)
                                } else {
                                    Image(systemName: "exclamationmark.triangle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.red)
                                        .padding(.vertical, 4)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("CE Entry")
        .sheet(item: $selectedAttachment) { attachment in
            FullScreenAttachmentView(fileData: attachment.fileData, isPDF: attachment.isPDF)
        }
    }
}

// Full-screen attachment view for images and PDFs
struct FullScreenAttachmentView: View {
    let fileData: Data
    let isPDF: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var showShareSheet = false

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            if isPDF {
                PDFKitView(data: fileData)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
            } else if let uiImage = UIImage(data: fileData), uiImage.size != .zero {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Image(systemName: "exclamationmark.triangle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
            }

            // Buttons
            VStack {
                HStack {
                    // Share button
                    Button(action: {
                        showShareSheet = true
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                    
                    Spacer()
                    
                    // Close button
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                }
                Spacer()
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.height > 100 {
                        dismiss()
                    }
                }
        )
        .sheet(isPresented: $showShareSheet) {
            if isPDF {
                ShareSheet(activityItems: [fileData])
            } else if let uiImage = UIImage(data: fileData) {
                ShareSheet(activityItems: [uiImage])
            }
        }
    }
}

// Share sheet wrapper
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
