//
//  DemoSecondaryCalloutActionProvider.swift
//  Bord-iuchrach Gaidhlig
//
//  Created by Brennan Drew on 1/12/21.
//

import Foundation
import KeyboardKit
/**
 This provider provides secondary callouts with the standard
 secondary callout actions for the provided action.
 */
open class DemoSecondaryCalloutActionProvider: SecondaryCalloutActionProvider {
    
    public init() {}
    
    public func secondaryCalloutActions(for action: KeyboardAction, in context: KeyboardContext) -> [KeyboardAction] {
        action.secondaryCalloutActions()
    }
}


public extension KeyboardAction {
    
    /**
     This returns the standard secondary callout actions for
     a keyboard action.
     */
    func secondaryCalloutActions() -> [KeyboardAction] {
        switch self {
        case .character(let char): return char.standardActionCallouts()
        default: return []
        }
    }
}


private extension String {
    
    var isUppercased: Bool { self == uppercased() }
    
    func standardActionCallouts() -> [KeyboardAction] {
        switch self {
        case "\u{0300}": return [.character("\u{0300}"), .character("’"), .character("-")]
        case "’": return [.character("’"), .character("\u{0300}"), .character("-")]
        default:
            let result = lowercased().results()
            let string = isUppercased ? result.uppercased() : result
            return string.splitActions
        }
    }
    
    func results() -> String {
        switch self {
        case "-": return "-–—•"
        case "/": return "/\\"
        case "&": return "&§"
        case "”": return "\"”“„»«"
        case ".": return ".…"
        case "?": return "?¿"
        case "!": return "!¡"
        case "'": return "'’‘`"
        //case "\u{0300}": return "\u{0300}’-"
        //case "’": return "’\u{0300}-"
        case "%": return "%‰"
        case "=": return "=≠≈"
            
        case "£": return "£€$¥₩₽"
        
        case "a": return "aàá"
        case "c": return "cç"
        case "e": return "eèé"
        case "i": return "iìí"
        case "o": return "oòó"
        case "u": return "uùú"
        
        default: return ""
        }
    }
    
    var splitActions: [KeyboardAction] {
        map { .character(String($0)) }
    }
}
