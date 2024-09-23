//
//  ContentView.swift
//  AAAAA
//
//  Created by Naif Alrashed on 20/09/2024.
//

import SwiftUI

struct ContentView: View {
    @State var isPresented = false
    @StateObject var sheetStore = MapSheetsStore()
    var body: some View {
        ZStack {
            Button("Display first sheet!") {
                isPresented = true
            }
            .sheet(isPresented: $isPresented) {
                ViewA()
                    .environmentObject(sheetStore)
            }
            VStack {
                Spacer()
                HStack {
                    Circle()
                        .foregroundStyle(.red)
                        .frame(width: 50)
                        .offset(x: 0, y: -sheetStore.height)
                    Spacer()
                }
            }
        }
    }
}
struct ViewA: View {
    @State var isPresented = false
    @State var currentHeight: PresentationDetent = .fraction(0.3)
    @EnvironmentObject var mapSheetStore: MapSheetsStore
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Button("present a new sheet") {
                        isPresented = true
                    }
                }
            }
            .padding()
            .sheet(isPresented: $isPresented) {
                ViewB()
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button("close") {
                        mapSheetStore.dismiss()
                    }
                }
            }
        }
        .mapSheet(
            currentDetent: $currentHeight,
            detents: [.fraction(0.3), .fraction(0.7)]
        )
    }
}

struct ViewB: View {
    @State var isPresented = false
    @State var currentHeight: PresentationDetent = .fraction(0.5)
    @EnvironmentObject var mapSheetStore: MapSheetsStore
    var body: some View {
        ScrollView {
            VStack {
                Button("present a new sheet") {
                    isPresented = true
                }
            }
            .padding()
        }
        .sheet(isPresented: $isPresented) {
            ViewA()
        }
        .mapSheet(
            currentDetent: $currentHeight,
            detents: [.fraction(0.5), .fraction(0.9)]
        )
    }
}

#Preview {
    ContentView()
}
