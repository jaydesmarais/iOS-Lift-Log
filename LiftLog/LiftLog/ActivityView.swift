//
//  ActivityView.swift
//  LiftLog
//
//  Created by Jay Desmarais on 4/17/23.
//

import SwiftUI

struct ActivityItemView: View {
    @EnvironmentObject var userData: UserData
    let activity: Activity
    
    var body: some View {
        ZStack {
            Label(activity.activityType.rawValue, systemImage:activity.activityType.activityIcon)
                .font(.headline).bold()
                .labelStyle(.titleAndIcon)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            HStack {
                Text(activity.date.formatted(date: .omitted, time: .shortened))
                    .font(.headline).bold()
                Text(activity.calories.description + " cal.").font(.headline).bold()
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            Label("View", systemImage: "chevron.right").frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing).labelStyle(.iconOnly)
        }.padding().frame(minHeight: 65)
    }
}

struct ActivityView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var selectedDay: SelectedDay
    
    @State private var plusButtonID = UUID()
    @State private var addingActivity = false
    @State private var newActivity = Activity()
    
    func getNumCalories () -> Int {
        var numCals = 0
        for activity in userData.activities {
            if activity.date.formatted(date: .numeric, time: .omitted) == selectedDay.dateString {
                numCals += activity.calories
            }
        }
        return numCals
    }
        
    var body: some View {
        NavigationStack {
            List {
                Section {
                   DateSelector()
                }
                Section(header: Text("Calories Burned")) {
                    ZStack {
                        MainCardBackground()
                        let numCalories = getNumCalories()
                        Text(String(numCalories)).font(.largeTitle).bold().foregroundColor(.white)
                    }.modifier(ListRowStyle())
                }.headerProminence(.increased)
                Section(header: Text("Activity")) {
                    ForEach(userData.sortedActivities(selectedDay: selectedDay), id:\.self) { $activity in
                        ZStack {
                            MedCardBackground()
                            ActivityItemView(activity: activity)
                        }.modifier(ListRowStyle())
                            .background(
                                NavigationLink("", destination: ActivityEditor(activity: $activity, isNew: false))
                            )
                    }
                    if userData.sortedActivities(selectedDay: selectedDay).wrappedValue.count < 1 {
                        ZStack {
                            MedCardBackground()
                            VStack {
                                Text("No activity recorded for this day")
                                    .font(.headline).bold()
                                Text("Use the \"+\" to add an activity")
                                    .font(.headline).bold()
                            }.padding()
                        }.modifier(ListRowStyle())
                    }
                }.headerProminence(.increased)
            }
            .navigationTitle("Activity")
            .toolbar {
                ToolbarItem {
                    Button {
                        newActivity = Activity(date: selectedDay.date)
                        addingActivity = true
                    } label: {
                        Image(systemName: "plus")
                    }.id(plusButtonID)
                }
            }.sheet(isPresented: $addingActivity) {
                NavigationStack {
                    ActivityEditor(activity: $newActivity, isNew: true)
                        .onDisappear {
                            // Force an update after sheet is closed to make button clickable again
                            self.plusButtonID = UUID()
                        }
                }
            }
        }
    }
}
