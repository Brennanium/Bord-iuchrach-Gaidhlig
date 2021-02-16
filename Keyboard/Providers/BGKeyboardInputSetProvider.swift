//
//  DemoKeyboardInputSetProvider.swift
//  Bord-iuchrach Gaidhlig
//
//  Created by Brennan Drew on 1/12/21.
//

import UIKit
import KeyboardKit


public class BGKeyboardInputSetProvider: DeviceSpecificInputSetProvider, LocalizedService {
    
    public init(device: UIDevice = .current) {
        self.device = device
    }
    public var device: UIDevice
    public let localeKey: String = "gd"
    
    public func alphabeticInputSet() -> AlphabeticKeyboardInputSet {
        AlphabeticKeyboardInputSet(rows: [
            "qwertyuiop".chars,
            ["a", "s", "d", "f", "g", "h", "j", "k", "l", Self.specialCharacter(proxy: KeyboardInputViewController.shared.textDocumentProxy)],
            row(phone: "zxcvbnm", pad: "zxcvbnm,.")
        ]) 
    }
    
    public func numericInputSet() -> NumericKeyboardInputSet {
        NumericKeyboardInputSet(rows: [
            "1234567890".chars,
            row(phone: "-/:;()£&@“", pad: "@#£&*()’”"),
            row(phone: ".,?!’", pad: "%-+=/;:,.")
        ])
    }
    
    public func symbolicInputSet() -> SymbolicKeyboardInputSet {
        SymbolicKeyboardInputSet(rows: [
            row(phone: "[]{}#%^*+=", pad: "1234567890"),
            row(phone: "_\\|~<>$€¥•", pad: "$€¥_^[]{}"),
            row(phone: ".,?!’", pad: "§|~…\\<>!?")
        ])
    }

    
    
    
    static func specialCharacter(proxy: UITextDocumentProxy) -> String {
        if proxy.isCursorAtNewSentence ||
            proxy.isCursorAtNewWord {
            return "’"
        }
        //last character is a vowel
        if "AEIOUaeiou".contains((proxy.documentContextBeforeInput ?? "").suffix(1)) {
            return "\u{0300}"
        }
        return "’";
    }
}


extension String {
    
    var chars: [String] { self.map { String($0) } }
}
