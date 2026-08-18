import SwiftUI
import GoogleMobileAds

struct BannerAdView: UIViewControllerRepresentable {
    // Use your Ad Unit ID or the test ID for development
    private let adUnitID: String = "ca-app-pub-3940256099942544/2934735716"
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let bannerView = GADBannerView(adSize: GADAdSizeBanner) // 320x50 banner
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = viewController
        bannerView.load(GADRequest())
        
        // Add banner to view controller's view
        viewController.view.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bannerView.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            bannerView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor),
            bannerView.widthAnchor.constraint(equalToConstant: GADAdSizeBanner.size.width),
            bannerView.heightAnchor.constraint(equalToConstant: GADAdSizeBanner.size.height)
        ])
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No updates needed for banner ad
    }
}