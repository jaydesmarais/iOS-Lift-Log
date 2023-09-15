//
//  LiftLogApp.swift
//  LiftLog
//
//  Created by Vernon Edejer on 4/16/23.
//

import SwiftUI
import HealthKit

@main
struct LiftLogApp: App {
    @StateObject var userData = UserData()
    @StateObject var selectedDay = SelectedDay()
    @StateObject var loginSettings = LoginSettings()
    
    var body: some Scene {
        WindowGroup {
            if !loginSettings.isLoggedIn {
                LoginView()
                    .environmentObject(loginSettings)
                    .onAppear(perform: {
                        loginSettings.getHealthAuthorizationRequestStatus()
                    })
            } else if HKHealthStore.isHealthDataAvailable() && !loginSettings.hasRequestedHealthData {
                HealthKitView()
                    .environmentObject(loginSettings)
            } else {
                ContentView()
                    .environmentObject(userData)
                    .environmentObject(selectedDay)
            }
        }
    }
}
