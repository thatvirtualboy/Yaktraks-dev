//
//  Extensions.swift
//  VoiceRecorderApp
//
//  Created by Ryan Klumph on 8/19/21.
//

import Foundation
import SwiftUI

extension Date {
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

}

extension View {
    public func sheet<Content: View, Value>(
        using value: Binding<Value?>,
        @ViewBuilder content: @escaping (Value) -> Content
    ) -> some View {
        let binding = Binding<Bool>(
            get: { value.wrappedValue != nil },
            set: { _ in value.wrappedValue = nil }
        )
        return sheet(isPresented: binding) {
            content(value.wrappedValue!)
        }
    }
}
