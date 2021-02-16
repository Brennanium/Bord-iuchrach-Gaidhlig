//
//  DemoAutocompleteSuggestionProvider.swift
//  KeyboardKitDemo
//
//  Created by Daniel Saidi on 2019-07-05.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//
import UIKit
import KeyboardKit

/**
 This class is shared between the demo app and all keyboards.
 */
class BGAutocompleteSuggestionProvider: AutocompleteSuggestionProvider {
    public init(for controller: KeyboardInputViewController) {
        self.controller = controller
    }
    
    weak private var controller: KeyboardInputViewController?
    
    private var textDocumentProxy: UITextDocumentProxy? {
        controller?.textDocumentProxy
    }
    
    private var context: KeyboardContext {
        KeyboardInputViewController.shared.keyboardContext
    }
    
    func autocompleteSuggestions(for text: String, completion: AutocompleteResponse) {
        //guard text.count > 0 else { return completion(.success([])) }
        completion(.success(suggestions(for: text)))
    }
}

public struct BGAutocompleteSuggestion: AutocompleteSuggestion {
    
    public var replacement: String
    public var title: String { replacement }
    public var subtitle: String?
    public var additionalInfo: [String: Any] { [:] }
}

private extension BGAutocompleteSuggestionProvider {
    
    func suggestions(for text: String) -> [BGAutocompleteSuggestion] {
        if text == "a" {
            return suggestions([
                "à",
                "a’",
                "agus"
            ])
        }
        if let proxy = textDocumentProxy {
            if proxy.isCursorAtNewSentence ||
                proxy.documentContextBeforeInput == nil ||
                proxy.documentContextBeforeInput! == ""
                {
                return suggestions([
                    "’S e",
                    "Tha",
                    "Chan eil"
                ])
            }
            
            if text.isEmpty {
                return suggestions([
                    "a’",
                    "an",
                    "agus"
                ])
            }
        }
        
        if text.count > 0 {
            return suggestions([
                text + "ach",
                text + "aidh",
                text + "ichean"
            ])
        }
        
        return suggestions([
            "’S e",
            "Tha",
            "Chan eil"
        ])
        
    }
    
    func suggestions(_ words: [String]) -> [BGAutocompleteSuggestion] {
        words.map { word in suggestion(word)}
    }
    
    func suggestion(_ word: String, _ subtitle: String? = nil) -> BGAutocompleteSuggestion {
        BGAutocompleteSuggestion(replacement: captialization(word), subtitle: subtitle)
    }
    
    func captialization(_ word: String) -> String {
        let keyboardType = context.keyboardType
        
        switch keyboardType {
        case .alphabetic(let state):
            switch state {
            case .capsLocked: return word.uppercased()
            //case .uppercased: return word//.firstLetterCapitalized
            //case .lowercased: return word.lowercased()
            default: return word
            }
        default: return word
        }
    }
}



private extension String {
    var firstLetterCapitalized: String {
        if prefix(1) == "’" && count > 1 {
            return prefix(2).capitalized + dropFirst(2)
        }
        return prefix(1).capitalized + dropFirst()
    }
}
