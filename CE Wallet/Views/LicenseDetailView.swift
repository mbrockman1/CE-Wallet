//
//  LicenseDetailView.swift
//  CEWallet
//

import SwiftUI
import PDFKit

struct LicenseDetailView: View {
    let entry: LicenseEntry
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
                Text("Issued: \(entry.issuanceDate, style: .date)")
                if let licenseNumber = entry.licenseNumber, !licenseNumber.isEmpty {
                    Text("Number: \(licenseNumber)")
                }
                Text("Expires: \(entry.expirationDate, style: .date)")
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
                                    let thumbnail = page.thumbnail(of: CGSize(width: 50, height: 50), for: .mediaBox)
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
                            } else if let uiImage = UIImage(data: file.fileData) {
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
        .navigationTitle(entry.title)
        .sheet(item: $selectedAttachment) { attachment in
            FullScreenAttachmentView(fileData: attachment.fileData, isPDF: attachment.isPDF)
        }
    }
}
