//
//  DemoKeyboardAppearanceProvider.swift
//  KeyboardKitDemo
//
//  Created by Daniel Saidi on 2021-01-10.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import KeyboardKit
import UIKit
import SwiftUI

/**
 This provider inherits `StandardKeyboardAppearanceProvider`
 and adds demo-specific functionality to it.
 */
class BGKeyboardAppearanceProvider: StandardKeyboardAppearance {
    
    override init(context: KeyboardContext) {
        self.context = context
        
        super.init(context: context)
    }
    private let context: KeyboardContext
    
    private var controller: KeyboardInputViewController { .shared }
    
    private var shiftState: KeyboardCasing? {
        let type = context.keyboardType
        switch type {
        case .alphabetic(let state): return state
        default: return nil
        }
    }
    
    /* override func buttonFont(for action: KeyboardAction) -> UIFont {
        switch action {
        case .space, .newLine: return .preferredFont(forTextStyle: .callout)
        case .shift: return .systemFont(ofSize: 19)
        case .backspace: return .preferredFont(forTextStyle: .title3)
        case .keyboardType: return .preferredFont(forTextStyle: .body)
        case .character(let char):
            guard (char.first ?? Character("")).isLetter else { fallthrough }
            guard let state = shiftState else { fallthrough }
            switch state {
            case .lowercased: return .systemFont(ofSize: 24)
            default: return .systemFont(ofSize: 23)
            }
        default: return super.font(for: action)
        }
    } */
    
    override func buttonFont(for action: KeyboardAction) -> Font {
        let rawFont = Font(action.standardButtonFont)
        guard let weight = fontWeight(for: action, context: context) else { return rawFont }
        return rawFont.weight(weight)
    }
    
    func fontWeight(for action: KeyboardAction, context: KeyboardContext) -> UIFont.Weight? {
        switch action {
        case .newLine: return .regular
//        case .character(let char):
//            guard !"\u{0300}’".contains(char) else { fallthrough }
//            guard let state = shiftState else { fallthrough }
//            switch state {
//            case .lowercased: return .light
//            default: return nil
//            }
        default:
            let hasImage = action.standardButtonImage != nil
            return hasImage ? .light : nil
        }
    }
    
    override func buttonText(for action: KeyboardAction) -> String? {
        switch action {
        case .space: return "falamh"
        case .newLine: return "tilleadh"
        //case .backspace: return "\u{232B}" //delete symbol
        default: return super.buttonText(for: action)
        }
    }
    
    func returnText(proxy: UITextDocumentProxy) -> String? {
        let type = proxy.returnKeyType
        switch type {
        case .go: return "dol"
        case .google: return "googleadh"
        case .join: return nil
        case .next: return "ath"
        case .route: return "rùtachadh"
        case .search: return "sireadh"
        case .send: return "cur"
        case .done: return "ullamh"
        case .`continue` : return "buanachadh"
        default: return "tilleadh"
        }
    }
}

