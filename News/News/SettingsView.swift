//
//  SettingsView.swift
//  News
//
//  Created by Rodrigo Brauwers on 03/01/24.
//

import Foundation
import SwiftUI
import NACommon
import NAModels
import LocalAuthentication

struct SettingsView : View {
        
    var body: some View {
        SettingsViewContent()
            .backport.toolbarTitle("Settings")
            .environmentObject(
                globalContainer.resolve(SettingsViewModel.self)!
            )
    }
   
}

private struct SettingsViewContent: View {
    
    @EnvironmentObject private var viewModel: SettingsViewModel
    @State private var biometricStatus: BiometricStatus = .notRequested
    @State private var showingSheet = false
    
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
            
            if #available(iOS 17.0, *) {
                NavigationLink(destination: VideosList()) {
                    Button {

                    } label: {
                        Text("Videos list")
                    }
                }
            }
            
            HStack {
                Text("Likes count: \(viewModel.uiState.likedArticlesCount)")
                Spacer()
                Button {
                    showingSheet.toggle()
                } label: {
                    Text("SEE ALL")
                }.sheet(isPresented: $showingSheet) {
                    LikesSheet(articles: viewModel.uiState.likedArticles ?? [])
                }
            }
            
        }
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

private struct LikesSheet : View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var viewModel: SettingsViewModel
    @State var articles: [LikedArticleUi]
    
    var body: some View {
        VStack {
            Spacer(minLength: 20)
            
            Text("Liked articles")
                .font(.title)
            
            List($articles, id: \.id) { (article : Binding<LikedArticleUi>) in
                HStack(alignment: .center, spacing: 4.0) {
                    Text(article.wrappedValue.title)
                        .font(.caption)
                    
                    Spacer()
                    
                    Toggle(isOn: article.isSelected) {
                    }
                    .backport.checkboxToggleStyle()
                }
                .frame(height: 50)
                .fixedSize(horizontal: false, vertical: true)
            }
            
            Button {
                presentationMode.wrappedValue.dismiss()
                viewModel.removeLikes(from: articles)
            } label: {
                Text("REMOVE")
            }
            .disabled(!articles.contains { $0.isSelected })
            
            Spacer(minLength: 4)
            
        }
    }
    
}

#Preview {
    return SettingsView()
}

private enum BiometricStatus {
    case notRequested
    case notAvailable
    case error(error: Error?)
    case success
}

