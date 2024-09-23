//
//  MapSheetsStore.swift
//  AAAAA
//
//  Created by Naif Alrashed on 23/09/2024.
//

import Foundation
import Combine
import SwiftUI

/// manages all the sheets presented in the map
@Observable
final class MapSheetsStore: ObservableObject {
    /// currently presented sheet's height
    private(set) var height: CGFloat = .zero
    private var sheets: [WeakSheetContainer] = []
    private var currentSheetHeightSubscription: AnyCancellable?
    
    /// the purpose of this class is to hold weak reference to the `SingleSheetStore`
    /// we cannot hold a weak reference in an array directly like so `[weak SingleSheetStore?]`
    private class WeakSheetContainer {
        weak var sheet: SingleSheetStore?
        
        init(sheet: SingleSheetStore) {
            self.sheet = sheet
        }
    }
    
    func show(resolvedItem: String) {
        if let currentSheet = sheets.last?.sheet {
            currentSheet.reslovedItemToShow = ResolvedItem(title: resolvedItem)
        }
    }
    
    /// dismisses the currently presetned sheet and update the height based on the previous sheet
    func dismiss() {
        currentSheetHeightSubscription?.cancel()
        if sheets.count > 2 {
            currentSheetHeightSubscription = sheets[sheets.count - 2].sheet?.$height.sink(receiveValue: { [weak self] newHeight in
                self?.updateHeight(to: newHeight)
            })
            sheets.last?.sheet?.dismiss()
        } else {
            updateHeight(to: .zero)
        }
    }
    
    /// when a new sheet is presented, we add it to our sheet stack
    /// and observe the height changes
    func add(_ sheet: SingleSheetStore) {
        sheets.append(WeakSheetContainer(sheet: sheet))
        currentSheetHeightSubscription?.cancel()
        currentSheetHeightSubscription = sheet.$height.sink { [weak self] newHeight in
            self?.updateHeight(to: newHeight)
        }
    }
    
    /// when a sheet is dismissed, we remove it from the stack and start observing the previous sheet's height
    func removeLastSheet() {
        currentSheetHeightSubscription?.cancel()
        sheets.removeLast()
        if let currentlyPresentedSheetStoreContainer = sheets.last {
            if let height = currentlyPresentedSheetStoreContainer.sheet?.height {
                updateHeight(to: height)
            }
            currentSheetHeightSubscription = currentlyPresentedSheetStoreContainer.sheet?.$height.sink { [weak self] newHeight in
                self?.updateHeight(to: newHeight)
            }
        } else {
            // we don't have any presented sheets
            // in reality, our app will never run into this case since our search sheet is not dismissable
            updateHeight(to: .zero)
        }
    }
    
    private func updateHeight(to newHeight: CGFloat, withAnimations: Bool = true) {
        if abs(height - newHeight) > 20, withAnimations {
            // if the height difference is big, we animate the change to make it look nice
            // this happen if the a new view is presented or dismissed
            withAnimation(.linear(duration: 0.25)) {
                height = newHeight
            }
        } else {
            height = newHeight
        }
    }
}
