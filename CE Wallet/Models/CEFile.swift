//
//  CEFile.swift
//  CME Wallet
//
//  Created by Michael Brockman on 4/23/25.
//


//
//  CEFile.swift
//  CEWallet
//

import Foundation
import SwiftData

@Model
final class CEFile: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var fileData: Data          // raw bytes
    var fileName: String        // keeps extension
    var parent: CEEntry?        // inverse relationship

    init(fileData: Data, fileName: String) {
        self.fileData = fileData
        self.fileName = fileName
    }

    var isPDF: Bool { fileName.lowercased().hasSuffix(".pdf") }
}