//
//  AppState.swift
//  NAModels
//
//  Created by Rodrigo Brauwers on 28/11/23.
//

import Foundation
import SwiftUI

public class AppState : ObservableObject {
    
    @Published public var user: User
    
    public init(user: User) {
        self.user = user
    }
    
}
