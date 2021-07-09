//
//  FirebaseauthFIrestoreApp.swift
//  FirebaseauthFIrestore
//
//  Created by Bilel Hattay on 05/07/2021.
//

import SwiftUI
import Firebase

@main
struct FirebaseauthFIrestoreApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(ViewModelCard())
        }
    }
}
