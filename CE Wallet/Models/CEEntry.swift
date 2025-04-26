//
//  CEEntry.swift
//  CEWallet
//

import Foundation
import SwiftData

@Model
final class CEEntry: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var title: String
    var dateCompleted: Date
    var credits: Double
    var receiptCode: String?
    var notes: String? // New optional field

    // multiple attachments
    @Relationship(deleteRule: .cascade) var files: [CEFile] = []

    init(
        title: String,
        dateCompleted: Date,
        credits: Double,
        receiptCode: String? = nil,
        notes: String? = nil,
        files: [CEFile] = []
    ) {
        self.title = title
        self.dateCompleted = dateCompleted
        self.credits = credits
        self.receiptCode = receiptCode
        self.notes = notes
        self.files = files
    }
}
