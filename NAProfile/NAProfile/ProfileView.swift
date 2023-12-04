//
//  ProfileView.swift
//  NAProfile
//
//  Created by Rodrigo Brauwers on 28/11/23.
//

import Foundation
import SwiftUI
import NAModels

public struct ProfileView : View {
    @EnvironmentObject private var appState: AppState
    
    public init() {}
    
    public var body: some View {
        if #available(iOS 14, *) {
            return ProfileViewContent()
        } else {
            return ProfileViewLegacyContent()
        }
    }
    
}

@available(iOS 14.0, *)
struct ProfileViewContent : View {
    @State private var draftUser: User = User(name: "")
    @State private var infoViewIsActive: Bool = false
    @EnvironmentObject private var appState: AppState
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        VStack {
            List {
                VStack {
                    Text("Username")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)

                    TextField("Username", text: $draftUser.name)
                    
                    Button("Info", systemImage: "info.circle") {
                        infoViewIsActive.toggle()
                    }.sheet(isPresented: $infoViewIsActive) {
                        InfoView(infoViewIsActive: $infoViewIsActive)
                    }
                }
            }

            Button("Save") {
                appState.user = draftUser
                presentationMode.wrappedValue.dismiss()
            }
        }.toolbar {
            ToolbarItem(placement: .principal) {
                Text("Profile").font(.largeTitle)
            }
        }.onAppear {
            draftUser = User(user: appState.user)
        }
    }
    
}


struct ProfileViewLegacyContent : View {
    
    var body: some View {
        Text("ProfileViewContentLegacy")
    }
    
}

@available(iOS 14.0, *)
private struct InfoView : View {
    @Binding var infoViewIsActive: Bool
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    Text("Liked articles:")
                    Text("0")
                }
            }.toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        infoViewIsActive = false
                    }, label: {
                        Image(systemName: "xmark")
                    })
                }
            }
        }
    }
    
}

#Preview("Profile view content") {
    if #available(iOS 14.0, *) {
        return ProfileViewContent()
            .environmentObject(AppState(user: User(name: "Bob")))
    } else {
        return ProfileViewLegacyContent()
    }
}

#Preview("Info view") {
    @State var infoViewIsActive: Bool = false
    
    if #available(iOS 14.0, *) {
        return InfoView(infoViewIsActive: $infoViewIsActive)
    } else {
        return Text("Not available")
    }
}
