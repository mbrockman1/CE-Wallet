//
//  PDFKitView.swift
//  CEWallet
//
//  Created by Michael Brockman on 4/23/25.
//

import SwiftUI
import PDFKit

struct PDFKitView: UIViewRepresentable {
    let data: Data

    func makeUIView(context: Context) -> PDFView {
        let view = PDFView()
        view.autoScales = true
        view.displayMode = .singlePageContinuous
        view.displayDirection = .vertical
        view.usePageViewController(true, withViewOptions: nil)
        view.document = PDFDocument(data: data)
        return view
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        // no-op
    }
}
