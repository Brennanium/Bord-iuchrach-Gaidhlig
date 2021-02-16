//
//  BGKeyboardViewController.swift
//  Keyboard
//
//  Created by Brennan Drew on 1/11/21.
//

import UIKit
import KeyboardKit
import SwiftUI
import Combine

class BGKeyboardViewController: KeyboardInputViewController {

    // MARK: - View Controller Lifecycle
    
    /* override func viewDidLoad() {
        super.viewDidLoad()
        primaryLanguage = "gd"
        
        setup(with: keyboardView)
        //context = BGObservableKeyboardContext(from: context)
        context.actionHandler = BGKeyboardActionHandler(
            inputViewController: self,
            toastContext: toastContext)
        context.keyboardAppearanceProvider = BGKeyboardAppearanceProvider(for: self)
        
        context.keyboardInputSetProvider = BGKeyboardInputSetProvider()
        
        SecondaryInputCalloutContext.shared = SecondaryInputCalloutContext(
            actionProvider: BGSecondaryCalloutActionProvider(),
            context: context)
        
        performAutocomplete()
    } */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        primaryLanguage = "gd"
        
        keyboardActionHandler = BGKeyboardActionHandler(
            inputViewController: self,
            toastContext: toastContext)
        keyboardInputSetProvider = BGKeyboardInputSetProvider()
        keyboardLayoutProvider = StandardKeyboardLayoutProvider(
            inputSetProvider: keyboardInputSetProvider,
            dictationReplacement: .keyboardType(.emojis))
        keyboardSecondaryCalloutActionProvider = BGSecondaryCalloutActionProvider()
        setup(with: keyboardView)
        
        performAutocomplete()
    }
    
    
    // MARK: - Properties
    
    private var cancellables = [AnyCancellable]()
    
    private let toastContext = KeyboardToastContext()
    
    private var keyboardView: some View {
        BGKeyboardView(
            actionHandler: keyboardActionHandler,
            appearance: keyboardAppearance,
            layoutProvider: keyboardLayoutProvider)
            .environmentObject(autocompleteContext)
            .environmentObject(toastContext)
    }
    
    
    // MARK: - Autocomplete
    private lazy var autocompleteProvider = BGAutocompleteSuggestionProvider(for: self)
    
    override func performAutocomplete() {
        //guard let word = textDocumentProxy.currentWord else { return resetAutocomplete() }
        let word = textDocumentProxy.currentWord ?? ""
        autocompleteProvider.autocompleteSuggestions(for: word) { [weak self] result in
            switch result {
            case .failure(let error): print(error.localizedDescription)
            case .success(let result): self?.autocompleteContext.suggestions = result
            }
        }
    }
    
    override func resetAutocomplete() {
        autocompleteContext.suggestions = []
    }
    
    
    override func textDidChange(_ textInput: UITextInput?) {
        switch keyboardType {
        case .alphabetic(let state):
            KeyboardAction.shift(currentState: state).standardTapAction?(self)
        default: break
        }
        
        super.textDidChange(textInput)
    }
}
