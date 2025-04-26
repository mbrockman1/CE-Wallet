//
//  LicenseEntry.swift
//  CEWallet
//

import Foundation
import SwiftData

@Model final class LicenseEntry: Identifiable {
    @Attribute(.unique) var id: UUID
    var title: String
    var issuanceDate: Date
    var licenseNumber: String?
    var expirationDate: Date
    var notes: String? // New optional field
    
    @Relationship(deleteRule: .cascade) var files: [LicenseFile] = []

    init(
        title: String,
        issuanceDate: Date,
        licenseNumber: String?,
        expirationDate: Date,
        notes: String? = nil,
        files: [LicenseFile] = []
    ) {
        self.id = UUID()
        self.title = title
        self.issuanceDate = issuanceDate
        self.licenseNumber = licenseNumber
        self.expirationDate = expirationDate
        self.notes = notes
        self.files = files
    }
}
