//
//  LicenseView.swift
//  CE Wallet
//
//  Created by Michael Brockman on 4/26/25.
//


import SwiftUI

struct LicenseView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Effective Date: 4/26/2025")
                Text("Owner: Michael Brockman")

                Group {
                    Text("1. Grant of License")
                        .font(.headline)
                    Text("Licensor hereby grants the user (\"Licensee\") a limited, non-exclusive, non-transferable, revocable license to install and use the Software solely for personal or internal business purposes. No ownership or intellectual property rights are transferred to the Licensee. By installing and using this application, you agree to the terms of the license.")
                    
                    Text("2. Restrictions")
                        .font(.headline)
                    Text("""
Licensee may not, without the prior written consent of Licensor:
- Copy, distribute, sublicense, sell, or commercially exploit the Software.
- Modify, adapt, reverse engineer, decompile, disassemble, or create derivative works based on the Software.
- Make the Software available to any third party in any manner.
- Remove or alter any proprietary notices on the Software.
""")
                    
                    Text("3. Ownership")
                        .font(.headline)
                    Text("All title, ownership rights, and intellectual property rights in and to the Software remain with Licensor. The Software is protected by copyright laws, international treaties, and other intellectual property laws.")
                    
                    Text("4. No Warranty")
                        .font(.headline)
                    Text("The Software is provided \"as is\" without warranties of any kind, either express or implied, including but not limited to warranties of merchantability, fitness for a particular purpose, or non-infringement.")
                    
                    Text("5. Limitation of Liability")
                        .font(.headline)
                    Text("In no event shall Licensor be liable for any direct, indirect, incidental, special, or consequential damages arising out of the use or inability to use the Software, even if advised of the possibility of such damages.")
                    
                    Text("6. Termination")
                        .font(.headline)
                    Text("Licensor may terminate this license immediately if Licensee fails to comply with any term of this Agreement. Upon termination, Licensee must immediately cease all use of the Software and destroy all copies.")
                    
                    Text("7. Governing Law")
                        .font(.headline)
                    Text("This Agreement shall be governed by and construed in accordance with the laws of the State of Texas, without regard to conflict of law principles.")
                    
                    Text("8. Entire Agreement")
                        .font(.headline)
                    Text("This Agreement constitutes the entire agreement between the parties and supersedes all prior or contemporaneous understandings, representations, or agreements, whether written or oral.")
                }
                
                Text("Important Note to Users")
                    .font(.headline)
                Text("""
By using, downloading, or accessing the Software, you agree to be bound by the terms of this License Agreement.
If you do not agree, do not download, install, copy, or otherwise use the Software.
""")
                
                Text("Copyright © 2025 Michael Brockman. All rights reserved.")
                    .padding(.top)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .navigationTitle("License Agreement")
    }
}
