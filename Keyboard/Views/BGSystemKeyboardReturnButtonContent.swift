//
//  BGKeyboardReturnButtonContent.swift
//  Keyboard
//
//  Created by Brennan Drew on 1/17/21.
//

import UIKit
import KeyboardKit
import SwiftUI

/**
 This view resolves the correct content for a certain action,
 given a custom text and image, which overrides the standard
 behaviors for the provided action.
 */
public struct BGSystemKeyboardReturnButtonContent: View {
    
    var appearance: KeyboardAppearance
    
    private var action: KeyboardAction { .newLine }
    
    @EnvironmentObject var context: ObservableKeyboardContext
    
    @ViewBuilder
    public var body: some View {
        Text(buttonText ?? "tilleadh")
            .minimumScaleFactor(0.1)
            .lineLimit(1)
    }
}

private extension BGSystemKeyboardReturnButtonContent {
    
    var buttonText: String? {
        if let appearance = appearance as? BGKeyboardAppearanceProvider {
            return appearance.returnText(proxy: context.textDocumentProxy) ?? "tilleadh"
        }
        return appearance.buttonText(for: action)
    }
}
