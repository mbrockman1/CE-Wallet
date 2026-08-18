//
//  LicenseFile.swift
//  CEWallet
//

import Foundation
import SwiftData

@Model
final class LicenseFile: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var fileData: Data
    var fileName: String
    var parent: LicenseEntry?

    init(fileData: Data, fileName: String) {
        self.fileData = fileData
        self.fileName = fileName
    }

    var isPDF: Bool { fileName.lowercased().hasSuffix(".pdf") }
}