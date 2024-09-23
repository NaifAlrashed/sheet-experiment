//
//  ContentView.swift
//  AAAAA
//
//  Created by Naif Alrashed on 20/09/2024.
//

import SwiftUI

struct ContentView: View {
    @State var isPresented = false
    @StateObject var mapSheetsStore = MapSheetsStore()
    var body: some View {
        ZStack {
            VStack {
                if isPresented {
                    Button("show anything on top of the current sheet") {
                        mapSheetsStore.show(resolvedItem: "new resolvedItem!")
                    }
                }
                Button("Display first sheet!") {
                    isPresented = true
                }
                .sheet(isPresented: $isPresented) {
                    ViewA()
                        .environmentObject(mapSheetsStore)
                }
            }
            VStack {
                Spacer()
                HStack {
                    Circle()
                        .foregroundStyle(.red)
                        .frame(width: 50)
                        .offset(x: 0, y: -mapSheetsStore.height)
                    Spacer()
                }
            }
        }
    }
}
struct ViewA: View {
    @State var isPresented = false
    @State var currentHeight: PresentationDetent = .fraction(0.3)
    @EnvironmentObject var mapSheetsStore: MapSheetsStore
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
                        mapSheetsStore.dismiss()
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

struct ResolvedItem: Identifiable {
    let id = UUID()
    let title: String
}

struct POIView: View {
    let resolvedItem: ResolvedItem
    @State var currentDetent: PresentationDetent = .medium
    var body: some View {
        Text("This is a POI! \(resolvedItem.title)")
            .mapSheet(currentDetent: $currentDetent, detents: [.medium])
    }
}

#Preview {
    ContentView()
}
