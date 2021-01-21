//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Brennan Drew on 1/11/21.
//

import UIKit
import KeyboardKit
import KeyboardKitSwiftUI
import SwiftUI
import Combine

class BGKeyboardViewController: KeyboardInputViewController {

    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup(with: keyboardView)
        //context = BGObservableKeyboardContext(from: context)
        context.actionHandler = BGKeyboardActionHandler(
            inputViewController: self,
            toastContext: toastContext)
        context.keyboardAppearanceProvider = BGKeyboardAppearanceProvider(for: self)
        
        context.keyboardInputSetProvider = DemoKeyboardInputSetProvider()
        
        SecondaryInputCalloutContext.shared = SecondaryInputCalloutContext(
            actionProvider: DemoSecondaryCalloutActionProvider(),
            context: context)
    }
    
    
    // MARK: - Properties
    
    private var cancellables = [AnyCancellable]()
    
    private let toastContext = KeyboardToastContext()
    
    private var keyboardView: some View {
        BGKeyboardView()
            .environmentObject(autocompleteContext)
            .environmentObject(toastContext)
    }
    
    
    // MARK: - Autocomplete
    
    private lazy var autocompleteContext = ObservableAutocompleteContext()
    
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
        switch context.keyboardType {
        case .alphabetic(let state):
            KeyboardAction.shift(currentState: state).standardTapActionForController?(self)
        default: break
        }
        
        super.textDidChange(textInput)
    }
}
