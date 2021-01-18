//
//  DemoKeyboardInputSetProvider.swift
//  Bord-iuchrach Gaidhlig
//
//  Created by Brennan Drew on 1/12/21.
//

import UIKit
import KeyboardKit


public class DemoKeyboardInputSetProvider: KeyboardInputSetProvider {
    public func alphabeticInputSet(for context: KeyboardContext) -> AlphabeticKeyboardInputSet {
        AlphabeticKeyboardInputSet(inputRows: [
            ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
            ["a", "s", "d", "f", "g", "h", "j", "k", "l", Self.specialCharacter(proxy: context.textDocumentProxy)],
            ["z", "x", "c", "v", "b", "n", "m"]
        ]) 
    }
    
    public func numericInputSet(for context: KeyboardContext) -> NumericKeyboardInputSet {
        KeyboardInputSet.standardNumeric(currency: "£")
    }
    
    public func symbolicInputSet(for context: KeyboardContext) -> SymbolicKeyboardInputSet {
        KeyboardInputSet.standardSymbolic(center: ["_", "\\", "|", "~", "<", ">", "$", "€", "¥", "•"])
    }
    
    
    
    static func specialCharacter(proxy: UITextDocumentProxy) -> String {
        if proxy.isCursorAtNewSentence ||
            proxy.isCursorAtNewWord {
            return "’"
        }
        //last character is a vowel
        if "AEIOUaeiu".contains((proxy.documentContextBeforeInput ?? "").suffix(1)) {
            return "\u{0300}"
        }
        return "’";
    }
}


