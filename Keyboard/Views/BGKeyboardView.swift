//
//  KeyboardView.swift
//  KeyboardKitDemo
//
//  Created by Daniel Saidi on 2020-06-10.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import SwiftUI
import KeyboardKit
import KeyboardKitSwiftUI

/**
 This view is the main view that is used by the extension by
 calling `setup(with:)` in `KeyboardViewController`.
 */
struct BGKeyboardView: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var context: ObservableKeyboardContext
    @EnvironmentObject var toastContext: KeyboardToastContext
    
    var body: some View {
        keyboardView
            .keyboardToast(isActive: $toastContext.isActive, content: toastContext.content, background: toastBackground)
    }
    
    @ViewBuilder
    var keyboardView: some View {
        switch context.keyboardType {
        case .alphabetic, .numeric, .symbolic: systemKeyboard
        default: Button("???", action: switchToDefaultKeyboard)
        }
    }
    
    
    var systemKeyboard: some View {
        VStack(spacing: 0) {
            AutocompleteToolbar(
                buttonBuilder: autocompleteButtonBuilder,
                replacementAction: autocompleteReplacementAction)
                .frame(height: 50)
            KeyboardContent(layout: systemKeyboardLayout, buttonBuilder: buttonBuilder)
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


// MARK: - Functions

private extension BGKeyboardView {
    
    func switchToDefaultKeyboard() {
        context.actionHandler
            .handle(.tap, on: .keyboardType(.alphabetic(.lowercased)))
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
        case .newLine: return AnyView(BGSystemKeyboardReturnButtonContent())
        default: return SystemKeyboard.standardButtonBuilder(action: action, keyboardSize: size)
        }
    }
    
    func autocompleteReplacementAction(for suggestion: AutocompleteSuggestion, context: KeyboardContext) {
        let proxy = context.textDocumentProxy
        let replacement = AutocompleteToolbar.standardReplacement(for: suggestion, context: context)
        if proxy.currentWord != nil {
            proxy.replaceCurrentWord(with: replacement)
        } else {
            proxy.insertText(replacement)
        }
        context.actionHandler.handle(.tap, on: .character(""))
    }
}



struct KeyboardView_Previews: PreviewProvider {
    static var previews: some View {
        BGKeyboardView()
    }
}



