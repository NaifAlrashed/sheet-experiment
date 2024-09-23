//
//  MapSheetModifier.swift
//  AAAAA
//
//  Created by Naif Alrashed on 23/09/2024.
//

import SwiftUI

struct MapSheetModifier: ViewModifier {
    @Binding var currentDetent: PresentationDetent
    @EnvironmentObject var sheetStore: MapSheetsStore
    @StateObject private var singleSheetStore = SingleSheetStore()
    @Environment(\.dismiss) var dismiss
    let detents: Set<PresentationDetent>
    
    func body(content: Content) -> some View {
        content
            .background {
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: HeightPreferenceKey.self, value: geometry.size.height)
                }
            }
            .onPreferenceChange(HeightPreferenceKey.self) { newHeight in
                singleSheetStore.update(to: newHeight, sheetStore: self.sheetStore)
            }
            .presentationDetents(detents, selection: $currentDetent)
            .presentationBackgroundInteraction(.enabled)
            .onReceive(singleSheetStore.$shouldDismiss) { shouldDismiss in
                if shouldDismiss {
                    dismiss()
                }
            }
            .onChange(of: singleSheetStore.shouldDismiss) { _, shouldDismiss in
                if shouldDismiss {
                    dismiss()
                }
            }
    }
}

extension View {
    func mapSheet(currentDetent: Binding<PresentationDetent>, detents: Set<PresentationDetent>) -> some View {
        self
            .modifier(MapSheetModifier(currentDetent: currentDetent, detents: detents))
    }
}

struct HeightPreferenceKey: PreferenceKey {

    // MARK: Static Properties

    static var defaultValue: CGFloat = .zero

    // MARK: Static Functions

    // MARK: - Internal

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        defaultValue = nextValue()
    }
}

