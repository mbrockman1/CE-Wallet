//
//  PDFExporter.swift
//  CEWallet
//
//  Created by Michael Brockman on 4/23/25.
//

import UIKit
import SwiftData

struct PDFExporter {

    static func exportCE(context: ModelContext) -> Data? {
        // Fetch entries sorted by dateCompleted
        let entries = (try? context.fetch(
            FetchDescriptor<CEEntry>(
                sortBy: [SortDescriptor(\.dateCompleted)]
            )
        )) ?? []

        // Prepare table data
        let columns = ["Title", "Completed", "Credits", "Receipt Code"]
        let rows: [[String?]] = entries.map { entry in
            [
                entry.title,
                DateFormatter.localizedString(
                    from: entry.dateCompleted,
                    dateStyle: .medium,
                    timeStyle: .none
                ),
                String(format: "%.1f", entry.credits),
                entry.receiptCode
            ]
        }

        // PDF page setup
        let pageWidth: CGFloat = 612
        let pageHeight: CGFloat = 792
        let margin: CGFloat = 20

        // PDF metadata
        let pdfMetaData: [String: Any] = [
            kCGPDFContextCreator as String: "CE Wallet",
            kCGPDFContextAuthor as String: "CE Wallet"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData

        let renderer = UIGraphicsPDFRenderer(
            bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight),
            format: format
        )

        let data = renderer.pdfData { pdfContext in
            pdfContext.beginPage()

            // Draw app icon
            let iconImage = UIImage(named: "AppIcon") ?? UIImage()
            let iconRect = CGRect(x: margin, y: margin, width: 40, height: 40)
            iconImage.draw(in: iconRect)

            // Draw “Made by CE Wallet”
            let madeBy = "Made by CE Wallet"
            let madeByAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 10)
            ]
            madeBy.draw(
                at: CGPoint(x: margin, y: margin + 45),
                withAttributes: madeByAttrs
            )

            // Draw header title
            let titleText = "CE Summary"
            let headerY = margin + 60
            let headerAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 18)
            ]
            let headerSize = titleText.size(withAttributes: headerAttrs)
            let headerX = (pageWidth - headerSize.width) / 2
            titleText.draw(
                at: CGPoint(x: headerX, y: headerY),
                withAttributes: headerAttrs
            )

            // Draw table
            let startY = headerY + headerSize.height + 20
            let columnWidth = (pageWidth - 2 * margin) / CGFloat(columns.count)
            let headerFont = UIFont.boldSystemFont(ofSize: 12)
            let cellFont = UIFont.systemFont(ofSize: 12)
            var yPosition = startY

            // Column headers
            for (i, col) in columns.enumerated() {
                let x = margin + CGFloat(i) * columnWidth
                let attrs: [NSAttributedString.Key: Any] = [.font: headerFont]
                col.draw(at: CGPoint(x: x, y: yPosition), withAttributes: attrs)
            }
            yPosition += 20

            // Rows
            for row in rows {
                for (i, value) in row.enumerated() {
                    let x = margin + CGFloat(i) * columnWidth
                    let attrs: [NSAttributedString.Key: Any] = [.font: cellFont]
                    let text = value ?? "-"
                    text.draw(at: CGPoint(x: x, y: yPosition), withAttributes: attrs)
                }
                yPosition += 18
                if yPosition > pageHeight - margin {
                    pdfContext.beginPage()
                    yPosition = margin
                }
            }
        }

        return data.isEmpty ? nil : data
    }

    static func exportLicenses(context: ModelContext) -> Data? {
        // Fetch entries sorted by issuanceDate
        let entries = (try? context.fetch(
            FetchDescriptor<LicenseEntry>(
                sortBy: [SortDescriptor(\.issuanceDate)]
            )
        )) ?? []

        // Prepare table data
        let columns = ["Title", "Issued", "Number", "Expires"]
        let rows: [[String?]] = entries.map { entry in
            [
                entry.title,
                DateFormatter.localizedString(
                    from: entry.issuanceDate,
                    dateStyle: .medium,
                    timeStyle: .none
                ),
                entry.licenseNumber,
                DateFormatter.localizedString(
                    from: entry.expirationDate,
                    dateStyle: .medium,
                    timeStyle: .none
                )
            ]
        }

        // PDF page setup
        let pageWidth: CGFloat = 612
        let pageHeight: CGFloat = 792
        let margin: CGFloat = 20

        // PDF metadata
        let pdfMetaData: [String: Any] = [
            kCGPDFContextCreator as String: "CE Wallet",
            kCGPDFContextAuthor as String: "CE Wallet"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData

        let renderer = UIGraphicsPDFRenderer(
            bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight),
            format: format
        )

        let data = renderer.pdfData { pdfContext in
            pdfContext.beginPage()

            // Draw app icon
            let iconImage = UIImage(named: "AppIcon") ?? UIImage()
            let iconRect = CGRect(x: margin, y: margin, width: 40, height: 40)
            iconImage.draw(in: iconRect)

            // Draw “Made by CE Wallet”
            let madeBy = "Made by CE Wallet"
            let madeByAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 10)
            ]
            madeBy.draw(
                at: CGPoint(x: margin, y: margin + 45),
                withAttributes: madeByAttrs
            )

            // Draw header title
            let titleText = "License Summary"
            let headerY = margin + 60
            let headerAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 18)
            ]
            let headerSize = titleText.size(withAttributes: headerAttrs)
            let headerX = (pageWidth - headerSize.width) / 2
            titleText.draw(
                at: CGPoint(x: headerX, y: headerY),
                withAttributes: headerAttrs
            )

            // Draw table
            let startY = headerY + headerSize.height + 20
            let columnWidth = (pageWidth - 2 * margin) / CGFloat(columns.count)
            let headerFont = UIFont.boldSystemFont(ofSize: 12)
            let cellFont = UIFont.systemFont(ofSize: 12)
            var yPosition = startY

            // Column headers
            for (i, col) in columns.enumerated() {
                let x = margin + CGFloat(i) * columnWidth
                let attrs: [NSAttributedString.Key: Any] = [.font: headerFont]
                col.draw(at: CGPoint(x: x, y: yPosition), withAttributes: attrs)
            }
            yPosition += 20

            // Rows
            for row in rows {
                for (i, value) in row.enumerated() {
                    let x = margin + CGFloat(i) * columnWidth
                    let attrs: [NSAttributedString.Key: Any] = [.font: cellFont]
                    let text = value ?? "-"
                    text.draw(at: CGPoint(x: x, y: yPosition), withAttributes: attrs)
                }
                yPosition += 18
                if yPosition > pageHeight - margin {
                    pdfContext.beginPage()
                    yPosition = margin
                }
            }
        }

        return data.isEmpty ? nil : data
    }
}
