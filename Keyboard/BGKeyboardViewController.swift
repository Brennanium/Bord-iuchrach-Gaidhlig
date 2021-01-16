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
        context.actionHandler = DemoKeyboardActionHandler(
            inputViewController: self,
            toastContext: toastContext)
        context.keyboardAppearanceProvider = DemoKeyboardAppearanceProvider()
//        context.keyboardLayoutProvider = StandardKeyboardLayoutProvider(
//            leftSpaceAction: .keyboardType(.emojis),
//            rightSpaceAction: .keyboardType(.images))
        
        context.keyboardInputSetProvider = DemoKeyboardInputSetProvider()
        
        context.secondaryCalloutActionProvider = DemoSecondaryCalloutActionProvider()
        
        SecondaryInputCalloutContext.shared = SecondaryInputCalloutContext(
            actionProvider: context.secondaryCalloutActionProvider,
            context: context)
    }
    
    
    // MARK: - Properties
    
    private var cancellables = [AnyCancellable]()
    
    private let toastContext = KeyboardToastContext()
    
    private var keyboardView: some View {
        BGKeyboardView(controller: self)
            .environmentObject(autocompleteContext)
            .environmentObject(toastContext)
    }
    
    
    // MARK: - Autocomplete
    
    private lazy var autocompleteContext = ObservableAutocompleteContext()
    
    private lazy var autocompleteProvider = DemoAutocompleteSuggestionProvider(for: self)
    
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
}
