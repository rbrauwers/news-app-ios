//
//  CheckboxToggleStyle.swift
//  NACommon
//
//  Created by Rodrigo Brauwers on 11/01/24.
//

import Foundation
import SwiftUI

@available(iOS 15.0, *)
struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 5.0)
                .stroke(lineWidth: 2)
                .frame(width: 20, height: 20)
                .cornerRadius(5.0)
                .overlay {
                    if configuration.isOn {
                        Image(systemName: "checkmark")
                            .resizable()
                            .frame(width: 10, height: 10)
                    }
                }
                .onTapGesture {
                    withAnimation(.linear) {
                        configuration.isOn.toggle()
                    }
                }
 
            configuration.label
        }
    }
}
