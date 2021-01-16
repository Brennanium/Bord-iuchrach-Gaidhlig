//
//  TestObservableKeyboardContext.swift
//  Bord-iuchrach Gaidhlig
//
//  Created by Brennan Drew on 1/13/21.
//

import SwiftUI
import KeyboardKit
import KeyboardKitSwiftUI

public class TestObservableKeyboardContext: KeyboardContext, ObservableObject {
    
    
    public init(from context: KeyboardContext) {
        controller = context.controller
        
        actionHandler = context.actionHandler
        keyboardAppearanceProvider = context.keyboardAppearanceProvider
        keyboardBehavior = context.keyboardBehavior
        keyboardInputSetProvider = context.keyboardInputSetProvider
        keyboardLayoutProvider = context.keyboardLayoutProvider
        secondaryCalloutActionProvider = context.secondaryCalloutActionProvider
        
        device = context.device
        deviceOrientation = context.deviceOrientation
        emojiCategory = context.emojiCategory
        hasDictationKey = context.hasDictationKey
        hasFullAccess = context.hasFullAccess
        keyboardType = context.keyboardType
        locale = context.locale
        needsInputModeSwitchKey = context.needsInputModeSwitchKey
        primaryLanguage = context.primaryLanguage
        textDocumentProxy = context.textDocumentProxy
        textInputMode = context.textInputMode
        traitCollection = context.traitCollection
        
        SecondaryInputCalloutContext.shared = SecondaryInputCalloutContext(
            actionProvider: context.secondaryCalloutActionProvider,
            context: self)
    }
    
    unowned public var controller: KeyboardInputViewController
    
    public let device: UIDevice
    
    @Published public var actionHandler: KeyboardActionHandler
    @Published public var emojiCategory: EmojiCategory
    @Published public var keyboardAppearanceProvider: KeyboardAppearanceProvider
    @Published public var keyboardBehavior: KeyboardBehavior
    @Published public var keyboardInputSetProvider: KeyboardInputSetProvider
    @Published public var keyboardLayoutProvider: KeyboardLayoutProvider
    @Published public var keyboardType: KeyboardType
    @Published public var secondaryCalloutActionProvider: SecondaryCalloutActionProvider {
        didSet {
            SecondaryInputCalloutContext.shared = SecondaryInputCalloutContext(
                actionProvider: secondaryCalloutActionProvider,
                context: self)
        }
    }
    
    @Published public var deviceOrientation: UIInterfaceOrientation
    @Published public var hasDictationKey: Bool
    @Published public var hasFullAccess: Bool
    @Published public var locale: Locale
    @Published public var needsInputModeSwitchKey: Bool
    @Published public var primaryLanguage: String?
    @Published public var textDocumentProxy: UITextDocumentProxy
    @Published public var textInputMode: UITextInputMode?
    @Published public var traitCollection: UITraitCollection
}
