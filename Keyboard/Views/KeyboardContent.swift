//
//  KeyboardContent.swift
//  Keyboard
//
//  Created by Brennan Drew on 1/12/21.
//

import SwiftUI
import KeyboardKit

struct KeyboardContent: View {
    public init(
        layout: KeyboardLayout,
        appearance: KeyboardAppearance,
        actionHandler: KeyboardActionHandler,
        inputCalloutStyle: InputCalloutStyle? = nil,
        secondaryInputCalloutStyle: SecondaryInputCalloutStyle? = nil,
        width: CGFloat = KeyboardInputViewController.shared.view.frame.width,
        buttonBuilder: @escaping ButtonBuilder = Self.standardButtonBuilder) {
        self.layout = layout
        self.actionHandler = actionHandler
        self.appearance = appearance
        self.inputCalloutStyle = inputCalloutStyle
        self.secondaryInputCalloutStyle = secondaryInputCalloutStyle
        self.buttonBuilder = buttonBuilder
        self.keyboardWidth = width
    }
    
    private let actionHandler: KeyboardActionHandler
    private let appearance: KeyboardAppearance
    private let buttonBuilder: ButtonBuilder
    private let inputCalloutStyle: InputCalloutStyle?
    private var keyboardWidth: CGFloat
    private let layout: KeyboardLayout
    private let secondaryInputCalloutStyle: SecondaryInputCalloutStyle?
    
    
    @EnvironmentObject private var context: ObservableKeyboardContext
    
    public typealias ButtonBuilder = (KeyboardAction) -> AnyView
    
    
    public var body: some View {
        VStack(spacing: 0) {
            rows(for: layout)
        }
        .inputCallout(style: inputCalloutStyle ?? .systemStyle(for: context))
        .secondaryInputCallout(style: secondaryInputCalloutStyle ?? .systemStyle(for: context))
    }
}

extension KeyboardContent {
    
    /**
     This is the standard `buttonBuilder`, that will be used
     when no custom builder is provided to the view.
     */
    static func standardButtonBuilder(action: KeyboardAction) -> AnyView {
        AnyView(SystemKeyboardButtonContent(action: action))
    }
}


private extension KeyboardContent {
    func rows(for layout: KeyboardLayout) -> some View {
        let inputWidth = layout.inputWidth(for: keyboardWidth)
        return ForEach(layout.items.enumerated().map { $0 }, id: \.offset) {
            row(for: layout, items: $0.element, inputWidth: inputWidth)
        }
    }
    
    func row(for layout: KeyboardLayout, items: KeyboardLayoutItemRow, inputWidth: CGFloat) -> some View {
        HStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.offset) {
                rowItem(for: layout, item: $0.element, inputWidth: inputWidth)
            }
        }
    }
    
    func rowItem(for layout: KeyboardLayout, item: KeyboardLayoutItem, inputWidth: CGFloat) -> some View {
        buttonBuilder(item.action)
            .frame(maxWidth: .infinity)
            .frame(height: item.size.height - item.insets.top - item.insets.bottom)
            .rowItemWidth(for: item, totalWidth: keyboardWidth, referenceWidth: inputWidth)
            .keyboardButtonStyle(for: item.action, appearance: appearance)
            .padding(item.insets)
            .background(Color.clearInteractable)
            .keyboardGestures(for: item.action, actionHandler: actionHandler)
    }
}

/*
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
*/
