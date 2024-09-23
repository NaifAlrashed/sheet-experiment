//
//  SingleSheetStore.swift
//  AAAAA
//
//  Created by Naif Alrashed on 23/09/2024.
//

import Foundation

class SingleSheetStore: ObservableObject {
    @Published private(set) var height: CGFloat = .zero
    private weak var customSheetStore: MapSheetsStore?
    private var isFirstTimeSettingHeight = true
    @Published private(set) var shouldDismiss = false
    
    @Published var reslovedItemToShow: ResolvedItem? // let's pretend this is a resolved item
    
    func update(to height: CGFloat, sheetStore: MapSheetsStore) {
        self.height = height
        if isFirstTimeSettingHeight {
            isFirstTimeSettingHeight = false
            self.customSheetStore = sheetStore
            customSheetStore?.add(self)
        }
    }
    
    func dismiss() {
        shouldDismiss = true
    }

    deinit {
        // at this point any weak reference to this object is set to nil! so we cannot pass self anymore
        // we are assuming that self is the last sheet. I cannot think of a scenario where this is not true
        customSheetStore?.removeLastSheet()
    }
}
