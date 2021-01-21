//
//  DemoAutocompleteSuggestionProvider.swift
//  KeyboardKitDemo
//
//  Created by Daniel Saidi on 2019-07-05.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import KeyboardKit
import KeyboardKitSwiftUI
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
    
    public init(
        inputViewController: BGKeyboardViewController,
        toastContext: KeyboardToastContext) {
        self.toastContext = toastContext
        super.init(inputViewController: inputViewController)
    }
    
    
    private let toastContext: KeyboardToastContext
    
    override func handle(_ gesture: KeyboardGesture, on action: KeyboardAction, sender: Any?) {
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
    }
    
    override func longPressAction(for action: KeyboardAction, sender: Any?) -> GestureAction? {
        switch action {
        case .image(_, _, let imageName): return { [weak self] in self?.saveImage(UIImage(named: imageName)!) }
        default: return super.longPressAction(for: action, sender: sender)
        }
    }
    
    override func tapAction(for action: KeyboardAction, sender: Any?) -> GestureAction? {
        switch action {
        case .image(_, _, let imageName): return { [weak self] in self?.copyImage(UIImage(named: imageName)!) }
        case .character(let char):
            guard char == "\u{0300}" else { fallthrough }
            return { [weak self] in
                let proxy = self?.inputViewController?.textDocumentProxy
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
        default: return super.tapAction(for: action, sender: sender)
        }
    }
    
    private func refreshView(for action: KeyboardAction) {
        guard !action.isShift else { return }
        guard let keyboardType = inputViewController?.context.keyboardType else { return }
        
        switch keyboardType {
        case .alphabetic(let state):
            KeyboardAction.shift(currentState: state).standardTapActionForController?(inputViewController)
        default: break
        }
        
    }
    
    // MARK: - Functions
    
    /**
     Override this function to implement a way to alert text
     messages in the keyboard extension. You can't use logic
     that you use in real apps, e.g. `UIAlertController`.
     */
    func alert(_ message: String) {
        toastContext.present(message)
    }
    
    func copyImage(_ image: UIImage) {
        guard let input = inputViewController else { return }
        guard input.hasFullAccess else { return alert("You must enable full access to copy images.") }
        guard image.copyToPasteboard() else { return alert("The image could not be copied.") }
        alert("Copied to pasteboard!")
    }
    
    func saveImage(_ image: UIImage) {
        guard let input = inputViewController else { return }
        guard input.hasFullAccess else { return alert("You must enable full access to save images.") }
        let saveCompletion = #selector(handleImage(_:didFinishSavingWithError:contextInfo:))
        image.saveToPhotos(completionTarget: self, completionSelector: saveCompletion)
    }


    // MARK: - Image Functions

    @objc func handleImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error == nil { alert("Saved!") }
        else { alert("Failed!") }
    }
}
