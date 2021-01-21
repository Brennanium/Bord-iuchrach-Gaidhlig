//
//  KeyboardContent.swift
//  Keyboard
//
//  Created by Brennan Drew on 1/12/21.
//

import SwiftUI
import KeyboardKit
import KeyboardKitSwiftUI

struct KeyboardContent: View {
    public init(
        layout: KeyboardLayout,
        //dimensions: SystemKeyboardDimensions,
        buttonBuilder: @escaping ButtonBuilder = Self.standardButtonBuilder) {
        self.rows = layout.actionRows
        self.dimensions = BGKeyboardDimensions()
        self.buttonBuilder = buttonBuilder
    }
    
    private let buttonBuilder: ButtonBuilder
    private let dimensions: KeyboardDimensions
    private let rows: KeyboardActionRows
    
    @State private var size: CGSize = .zero
    @EnvironmentObject var context: ObservableKeyboardContext
    
    public typealias ButtonBuilder = (KeyboardAction, KeyboardSize) -> AnyView
    public typealias KeyboardSize = CGSize
    
    public var body: some View {
        VStack(spacing: 0) {
            ForEach(rows.enumerated().map { $0 }, id: \.offset) {
                row(at: $0.offset, actions: $0.element)
            }
        }
        .bindSize(to: $size)
        .inputCallout(style: .systemStyle(for: context))
        .secondaryInputCallout(for: context, style: .systemStyle(for: context))
    }
}

extension KeyboardContent {

    /**
     This is the standard `buttonBuilder`, that will be used
     when no custom builder is provided to the view.
     */
    static func standardButtonBuilder(action: KeyboardAction, keyboardSize: KeyboardSize) -> AnyView {
        AnyView(SystemKeyboardButtonContent(action: action))
    }
}

private extension KeyboardContent {

    func row(at index: Int, actions: KeyboardActionRow) -> some View {
        HStack(spacing: 0) {
            secondRowEdgeSpacer(at: index)
            ForEach(Array(actions.enumerated()), id: \.offset) {
                let rowItem = SystemKeyboardButtonRowItem(
                    action: $0.element,
                    buttonContent: buttonBuilder($0.element, size),
                    dimensions: dimensions,
                    keyboardSize: size)
                
                if $0.element.isShift {
                    rowItem
                    thirdRowEdgeSpacer(at: index) //Spacer(minLength: thirdRowPadding)
                } else if case .keyboardType = $0.element {
                    rowItem
                    thirdRowEdgeSpacer(at: index)
                } else if ($0.element == .backspace) {
                    thirdRowEdgeSpacer(at: index) //Spacer(minLength: thirdRowPadding)
                    rowItem
                } else {
                    rowItem
                }
            }
            secondRowEdgeSpacer(at: index)
        }
    }
    
    @ViewBuilder
    func secondRowEdgeSpacer(at index: Int) -> some View {
        if index == 1 {
            Spacer(minLength: secondRowPadding)
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    func thirdRowEdgeSpacer(at index: Int) -> some View {
        if index == 2 {
            Spacer(minLength: thirdRowPadding)
            //EmptyView()
        }else {
            EmptyView()
        }
    }
    
    /**
     A temp. way to get side padding on each side on English
     iPhone keyboards.
     */
    var secondRowPadding: CGFloat {
        guard Locale.current.identifier.starts(with: "en") else { return 0 }
        guard UIDevice.current.userInterfaceIdiom == .phone else { return 0 }
        return max(0, 20 * CGFloat(rows[0].count - rows[1].count))
    }
    
    var thirdRowPadding: CGFloat {
        guard UIDevice.current.userInterfaceIdiom == .phone else { return 0 }
        guard rows[2].count <= 9 else { return 0 }
        switch context.keyboardType {
        case .alphabetic, .numeric, .symbolic: return 10
        default: return 0
        }
    }
}
//struct Keyboard_Previews: PreviewProvider {
//    static var previews: some View {
//        KeyboardContent()
//    }
//}





extension View {
    
    /**
     Bind the view's safe area to a binding.
     */
    func bindSafeAreaInsets(to binding: Binding<EdgeInsets>) -> some View {
        background(safeAreaBindingView(for: binding))
    }
    
    /**
    Bind the view's size to a binding.
    */
    func bindSize(to binding: Binding<CGSize>) -> some View {
        background(sizeBindingView(for: binding))
    }
}

private extension View {
    
    func changeStateAsync(_ action: @escaping () -> Void) {
        DispatchQueue.main.async(execute: action)
    }
    
    func safeAreaBindingView(for binding: Binding<EdgeInsets>) -> some View {
        GeometryReader { geo in
            self.safeAreaBindingView(for: binding, geo: geo)
        }
    }
    
    func safeAreaBindingView(for binding: Binding<EdgeInsets>, geo: GeometryProxy) -> some View {
        changeStateAsync { binding.wrappedValue = geo.safeAreaInsets }
        return Color.clear
    }
    
    func sizeBindingView(for binding: Binding<CGSize>) -> some View {
        GeometryReader { geo in
            self.sizeBindingView(for: binding, geo: geo)
        }
    }
    
    func sizeBindingView(for binding: Binding<CGSize>, geo: GeometryProxy) -> some View {
        changeStateAsync { binding.wrappedValue = geo.size }
        return Color.clear
    }
}
