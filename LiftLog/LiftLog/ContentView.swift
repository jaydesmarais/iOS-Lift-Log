//
//  ContentView.swift
//  LiftLog
//
//  Created by Vernon Edejer on 4/16/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var selectedDay: SelectedDay
    @State private var selection = 1
    
    var body: some View {
        TabView(selection: $selection) {
             NutritionView()
                .environmentObject(userData)
                .environmentObject(selectedDay)
                .tabItem {
                    Label("Nutrition", systemImage: "fork.knife")
                }.tag(1)
            ActivityView()
                .environmentObject(userData)
                .environmentObject(selectedDay)
                .tabItem {
                    Label("Activity", systemImage: "figure.run")
                }.tag(2)
        }
        // Adding some data to test with... remove if you'd like
        .onAppear() {
            userData.addActivity(activity: Activity(activityType: .WeightTraining, subActions: [SubAction(name:"Bench Press", rounds: 4, reps: 10, weight:215), SubAction(name:"Dips", rounds: 4, reps: 15, weight:0, durationMinutes:1, durationSeconds:30)], date: Calendar.current.date(byAdding: .hour, value: -2, to: Date()) ?? Date(), durationHours: 1, durationMinutes: 45, calories: 140))
            userData.addActivity(activity: Activity(activityType: .Swimming, subActions: [], date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(), durationHours: 0, durationMinutes: 30, calories: 515))
            userData.addActivity(activity: Activity(activityType: .Golf, subActions: [], date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(), durationHours: 8, durationMinutes: 15, calories: 231))
            
            userData.addMeal(meal: Meal(date: Calendar.current.date(byAdding: .hour, value: -7, to: Date()) ?? Date(), name: "Raisin Bran", category: .Breakfast, calories: 250))
            userData.addMeal(meal: Meal(date: Calendar.current.date(byAdding: .hour, value: -7, to: Date()) ?? Date(), name: "Milk", category: .Breakfast, calories: 250))
            userData.addMeal(meal: Meal(date: Calendar.current.date(byAdding: .hour, value: -4, to: Date()) ?? Date(), name: "Buffalo Chicken Sandwich", category: .Lunch, calories: 530))
            userData.addMeal(meal: Meal(date: Calendar.current.date(byAdding: .minute, value: -5, to: Date()) ?? Date(), name: "Hawaiian Pizza", category: .Dinner, calories: 780))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserData())
            .environmentObject(SelectedDay())
    }
}
