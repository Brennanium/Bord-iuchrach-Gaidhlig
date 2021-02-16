//
//  DemoAutocompleteSuggestionProvider.swift
//  KeyboardKitDemo
//
//  Created by Daniel Saidi on 2019-07-05.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import KeyboardKit
import UIKit

/**
 This action handler inherits `StandardKeyboardActionHandler`
 and adds demo-specific base functionality to it.
 
 The class is shared between all keyboards. Each demo action
 handler inherit this class and adds functionality on top of
 the base functionality.
 */
class BGKeyboardActionHandler: StandardKeyboardActionHandler {
    
    
    // MARK: - Initialization
    private var keyboardInputViewController: KeyboardInputViewController { .shared }
    
    public init(
        inputViewController: BGKeyboardViewController,
        toastContext: KeyboardToastContext) {
        self.toastContext = toastContext
        super.init(inputViewController: inputViewController)
    }
    
    
    private let toastContext: KeyboardToastContext
    
    /*override func handle(_ gesture: KeyboardGesture, on action: KeyboardAction, sender: Any?) {
        guard let gestureAction = self.action(for: gesture, on: action, sender: sender) else { return }
        gestureAction()
        refreshView(for: action)
        triggerAnimation(for: gesture, on: action, sender: sender)
        triggerAudioFeedback(for: gesture, on: action, sender: sender)
        triggerHapticFeedback(for: gesture, on: action, sender: sender)
        tryEndSentence(after: gesture, on: action)
        tryChangeKeyboardType(after: gesture, on: action)
        tryRegisterEmoji(after: gesture, on: action)
        triggerAutocomplete() //switched tryEndSentence and triggerAutocomplete, then put at end
    }*/
    
    override func handle(_ gesture: KeyboardGesture, on action: KeyboardAction, sender: Any?) {
        guard let gestureAction = self.action(for: gesture, on: action) else { return }
        gestureAction(keyboardInputViewController)
        triggerAudioFeedback(for: gesture, on: action, sender: sender)
        triggerHapticFeedback(for: gesture, on: action, sender: sender)
        tryEndSentence(after: gesture, on: action)
        tryChangeKeyboardType(after: gesture, on: action)
        tryRegisterEmoji(after: gesture, on: action)
        autocompleteAction()
    }
    
    
    override func action(for gesture: KeyboardGesture, on action: KeyboardAction) -> KeyboardAction.GestureAction? {
        switch gesture {
        case .doubleTap: return action.standardDoubleTapAction
        case .longPress: return action.standardLongPressAction
        case .repeatPress: return action.standardRepeatAction
        case .tap: return tapAction(for: gesture, on: action)
        }
    }
    
    func tapAction(for gesture: KeyboardGesture, on action: KeyboardAction) -> GestureAction? {
        switch action {
        case .character(let char):
            guard char == "\u{0300}" else { fallthrough }
            return { keyboardInputViewController in
                let proxy = keyboardInputViewController?.textDocumentProxy
                let substring = proxy?.documentContextBeforeInput?.suffix(1)
                if let substring = substring {
                    var letter = String(substring)
                    
                    let uppercased = Character(letter).isUppercase
                    switch letter.lowercased() {
                    case "a": letter = "à"
                    case "e": letter = "è"
                    case "i": letter = "ì"
                    case "o": letter = "ò"
                    case "u": letter = "ù"
                    default: return
                    }
                    if uppercased { letter = letter.uppercased() }
                    proxy?.deleteBackward(times: 1)
                    proxy?.insertText(letter)
                }
                
            }
        default: return action.standardTapAction
        }
    }
}
