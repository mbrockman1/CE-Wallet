//
//  CMEWalletApp.swift
//  CEWallet
//

import SwiftUI
import SwiftData
import OSLog
import FirebaseCore
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        MobileAds.shared.start(completionHandler: nil)
        AnalyticsManager.shared.applyStoredConsent()

        return true

  }
}



@main
struct CMEWalletApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var securityManager = SecurityManager()
    @AppStorage("useFaceID") private var useFaceID = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    // Logger for debugging
    private let logger = Logger(subsystem: "org.mjbapps.CEWallet", category: "AppLifecycle")

    // SwiftData schema versioning
    enum AppSchemaV1: VersionedSchema {
        static var versionIdentifier: Schema.Version = .init(1, 0, 0)
        static var models: [any PersistentModel.Type] {
            [CEEntry.self, CEFile.self, LicenseEntry.self, LicenseFile.self]
        }
    }

    struct AppMigrationPlan: SchemaMigrationPlan {
        static var schemas: [any VersionedSchema.Type] {
            [AppSchemaV1.self]
        }
        static var stages: [MigrationStage] {
            [MigrationStage.lightweight(fromVersion: AppSchemaV1.self, toVersion: AppSchemaV1.self)]
        }
    }

    // SwiftData ModelContainer with migration and backup
    let modelContainer: ModelContainer = {
        let containerConfig = ModelConfiguration(
            "CEWallet",
            url: FileManager.default
                .urls(for: .applicationSupportDirectory, in: .userDomainMask)
                .first!
                .appendingPathComponent("CEWallet.store")
        )
        do {
            let schema = Schema(AppSchemaV1.models)
            let container = try ModelContainer(
                for: schema,
                migrationPlan: AppMigrationPlan.self,
                configurations: containerConfig
            )
            // Ensure iCloud Backup inclusion
            var resourceValues = URLResourceValues()
            resourceValues.isExcludedFromBackup = false
            var storeURL = containerConfig.url
            try storeURL.setResourceValues(resourceValues)
            return container
        } catch {
            let logger = Logger(subsystem: "org.mjbapps.CEWallet", category: "SwiftData")
            logger.error("Failed to initialize ModelContainer: \(error.localizedDescription)")
            
            // Backup existing store
            let appSupport = FileManager.default
                .urls(for: .applicationSupportDirectory, in: .userDomainMask)
                .first!
            let storeURL = appSupport.appendingPathComponent("CEWallet.store")
            let backupURL = appSupport.appendingPathComponent(
                "CEWallet_backup_\(Date().formatted(.iso8601)).store"
            )
            
            if FileManager.default.fileExists(atPath: storeURL.path) {
                do {
                    try FileManager.default.copyItem(at: storeURL, to: backupURL)
                    logger.info("Backed up store to \(backupURL.path)")
                } catch {
                    logger.error("Failed to backup store: \(error.localizedDescription)")
                }
            }
            
            // Attempt recovery by deleting corrupted store and retrying
            try? FileManager.default.removeItem(at: storeURL)
            do {
                let schema = Schema(AppSchemaV1.models)
                let newContainer = try ModelContainer(
                    for: schema,
                    migrationPlan: AppMigrationPlan.self,
                    configurations: containerConfig
                )
                logger.info("Successfully initialized new ModelContainer after recovery")
                return newContainer
            } catch {
                logger.critical("Failed to recover ModelContainer: \(error.localizedDescription)")
                fatalError("Unable to initialize SwiftData store. Please contact support.")
            }
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
                .environmentObject(securityManager)
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                if useFaceID && !securityManager.isUnlocked {
                    securityManager.authenticate()
                }
            } else if newPhase == .background && useFaceID {
                securityManager.isUnlocked = false
            }
        }
    }
}
