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
    public init(
        for controller: KeyboardInputViewController,
        trailingSpace: Bool = true)
    {
        self.controller = controller
        space = trailingSpace ? " " : "";
    }
    
    weak private var controller: KeyboardInputViewController?
    
    private var textDocumentProxy: UITextDocumentProxy? {
        controller?.textDocumentProxy
    }
    private var space: String
    
    func autocompleteSuggestions(for text: String, completion: AutocompleteResponse) {
        //guard text.count > 0 else { return completion(.success([])) }
        completion(.success(suggestions(for: text)))
    }
}

public struct DemoAutocompleteSuggestion: AutocompleteSuggestion {
    
    public var replacement: String
    public var title: String { replacement }
    public var subtitle: String?
    public var additionalInfo: [String: Any] { [:] }
}

private extension BGAutocompleteSuggestionProvider {
    
    func suggestions(for text: String) -> [DemoAutocompleteSuggestion] {
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
    
    func suggestions(_ words: [String]) -> [DemoAutocompleteSuggestion] {
        words.map { word in suggestion(word + space)}
    }
    
    func suggestion(_ word: String, _ subtitle: String? = nil) -> DemoAutocompleteSuggestion {
        DemoAutocompleteSuggestion(replacement: word, subtitle: subtitle)
    }
}

