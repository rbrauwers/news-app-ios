//
//  SettingsView.swift
//  News
//
//  Created by Rodrigo Brauwers on 03/01/24.
//

import Foundation
import SwiftUI
import NACommon
import LocalAuthentication

struct SettingsView : View {
    
    @State private var biometricStatus: BiometricStatus = .notRequested
    
    var body: some View {
        Form {
            switch biometricStatus {
            case .notRequested:
                Button {
                    authenticate()
                } label: {
                    Text("Access sensitive data")
                }
            case .notAvailable:
                Text("Biometrics not available")
            case .error(let error):
                Text("Biometrics error: \(error?.localizedDescription ?? "")")
            case .success:
                Text("Biometrics success")
            }
            

        }.backport.toolbarTitle("Settings")
    }
    
    private func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            biometricStatus = .notAvailable
            return
        }

        let reason = "We need to unlock your data."

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in

            if success {
                biometricStatus = .success
            } else {
                biometricStatus = .error(error: error)
            }
        }
    }
   
}

private enum BiometricStatus {
    case notRequested
    case notAvailable
    case error(error: Error?)
    case success
}
