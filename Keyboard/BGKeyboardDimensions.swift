//
//  BGKeyboardDimensions.swift
//  Keyboard
//
//  Created by Brennan Drew on 1/19/21.
//

import CoreGraphics
import Combine
import SwiftUI
import KeyboardKit
import KeyboardKitSwiftUI

public struct BGKeyboardDimensions: KeyboardDimensions {
    
    public init() {
        self.buttonHeight = .standardKeyboardRowHeight()
        self.buttonInsets = .insets(from: .standardKeyboardRowItemInsets())
        
        self.shortButtonWidth = CGFloat.standardKeyboardRowHeight() - buttonInsets.top - buttonInsets.bottom
        self.longButtonWidth = self.shortButtonWidth * 2 + buttonInsets.leading + buttonInsets.trailing
    }
    
    public let buttonHeight: CGFloat
    public let buttonInsets: EdgeInsets
    public let longButtonWidth: CGFloat
    public let shortButtonWidth: CGFloat
    
    
    public func width(
        for action: KeyboardAction,
        keyboardWidth: CGFloat,
        context: KeyboardContext) -> CGFloat? {
        switch action {
        case .shift, .backspace: return shortButtonWidth
        //case .space: return keyboardWidth * 0.5
        case .dismissKeyboard: return
            ((self.shortButtonWidth * 3) / 2) + buttonInsets.leading + buttonInsets.trailing
        case .newLine: return longButtonWidth
        case .nextKeyboard: return shortButtonWidth
        case .keyboardType(let type): return widthKeyboardType(switchingTo: type, context: context)
        default: return nil
        }
    }
    
    func widthKeyboardType(switchingTo: KeyboardType, context: KeyboardContext) -> CGFloat? {
        let currentType = context.keyboardType
        let alphWidth: CGFloat? = context.needsInputModeSwitchKey ? shortButtonWidth : longButtonWidth
        
        switch switchingTo {
        case .numeric:
            switch currentType {
            case .symbolic: return shortButtonWidth
            case .alphabetic: return alphWidth
            default: return nil
            }
        case .symbolic:
            switch currentType {
            case .numeric: return shortButtonWidth
            default: return nil
            }
        case .alphabetic: return alphWidth
        default: return nil
        }
    }
}
