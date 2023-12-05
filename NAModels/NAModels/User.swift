//
//  User.swift
//  NAModels
//
//  Created by Rodrigo Brauwers on 28/11/23.
//

import Foundation
import Combine
import SwiftUI

public class User {
    public var name: String
    
    public init(name: String) {
        self.name = name
    }
    
    public init(user: User) {
        self.name = user.name
    }
    
}
