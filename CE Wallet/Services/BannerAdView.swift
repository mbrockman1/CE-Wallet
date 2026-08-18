//
//  BannerAdView.swift
//  CE Wallet
//
//  Created by Michael Brockman on 5/5/25.
//


import SwiftUI
import GoogleMobileAds

struct BannerAdView: UIViewControllerRepresentable {
    // Use your Ad Unit ID or the test ID for development
    private let adUnitID: String = "ca-app-pub-2182729311945385/9368818001"
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let bannerView = BannerView(adSize: AdSizeBanner) // 320x50 banner
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = viewController

        let request = Request()
        if ATTManager.shouldRequestNonPersonalizedAds {
            let extras = Extras()
            extras.additionalParameters = ["npa": "1"]
            request.register(extras)
        }
        bannerView.load(request)
        
        // Add banner to view controller's view
        viewController.view.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bannerView.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            bannerView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor),
            bannerView.widthAnchor.constraint(equalToConstant: AdSizeBanner.size.width),
            bannerView.heightAnchor.constraint(equalToConstant: AdSizeBanner.size.height)
        ])
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No updates needed for banner ad
    }
}
