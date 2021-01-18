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
class DemoKeyboardAppearanceProvider: StandardKeyboardAppearanceProvider {
    
    override func font(for action: KeyboardAction) -> UIFont {
        switch action {
        case .space, .newLine: return .preferredFont(forTextStyle: .body)
        default: return super.font(for: action)
        }
    }
    
    override func fontWeight(for action: KeyboardAction, context: KeyboardContext) -> UIFont.Weight? {
        switch action {
        case .newLine: return .regular
        default:
            let hasImage = action.standardButtonImage(for: context) != nil
            return hasImage ? .light : nil
        }
    }
    
    override func text(for action: KeyboardAction) -> String? {
        switch action {
        case .space: return "falamh"
        case .newLine: return "tilleadh"
        //case .backspace: return "\u{232B}" //delete symbol
        default: return super.text(for: action)
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

