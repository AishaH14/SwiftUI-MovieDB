//
//  AuthButtonStyle.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 23/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//
import SwiftUI

struct AuthButtonStyle: ButtonStyle {

    enum Kind {
        case primary
        case secondary
    }

    let kind: Kind

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(background)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .opacity(configuration.isPressed ? 0.8 : 1)
    }

    private var background: Color {
        switch kind {
        case .primary:   .blue
        case .secondary: .white.opacity(0.12)
        }
    }
}
