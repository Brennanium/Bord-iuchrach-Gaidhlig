//
//  KeyboardView+Keyboards.swift
//  KeyboardKitDemo
//
//  Created by Daniel Saidi on 2021-01-09.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import KeyboardKit
import KeyboardKitSwiftUI
import SwiftUI

extension BGKeyboardView {
    
    var emojiKeyboard: some View {
        Text("Emoji")
            .padding()
    }
    
    var imageKeyboard: some View {
        Text("Image")
            .padding()
    }
    
    var systemKeyboard: some View {
        VStack(spacing: 0) {
            AutocompleteToolbar(buttonBuilder: autocompleteButtonBuilder).frame(height: 50)
            Keyboard(layout: systemKeyboardLayout, buttonBuilder: buttonBuilder)
        }
    }
    
    var systemKeyboardLayout: KeyboardLayout {
        context.keyboardLayoutProvider.keyboardLayout(for: context)
    }
    
    var toastBackground: some View {
        Color.white
            .cornerRadius(3)
            .shadow(color: Color.black.opacity(0.3), radius: 2, x: 1, y: 1)
    }
}

private extension BGKeyboardView {
    
    func autocompleteButtonBuilder(suggestion: AutocompleteSuggestion) -> AnyView {
        guard let subtitle = suggestion.subtitle else { return AutocompleteToolbar.standardButton(for: suggestion) }
        return AnyView(VStack(spacing: 0) {
            Text(suggestion.title).font(.callout)
            Text(subtitle).font(.footnote)
        }.frame(maxWidth: .infinity))
    }
    
    func buttonBuilder(action: KeyboardAction, size: CGSize) -> AnyView {
        switch action {
        case .space: return AnyView(SystemKeyboardSpaceButtonContent(localeText: "Gàidhlig", spaceText: "falamh"))
//        case .newLine: return AnyView(
//            SystemKeyboardButtonContent(action: .newLine, text: "tilleadh")
//                .standardButtonStyle(for: .space, context: context)
//                .keyboardAction(.newLine, context: context))
        default: return SystemKeyboard.standardButtonBuilder(action: action, keyboardSize: size)
        }
    }
}

