//
//  NutritionView.swift
//  LiftLog
//
//  Created by Jay Desmarais on 4/17/23.
//

import SwiftUI

struct MealItemView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var selectedDay: SelectedDay
    let meal: Meal
    
    var body: some View {
        ZStack {
            Text(meal.name)
                .font(.headline).bold()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .lineLimit(1)
            HStack {
                Text(meal.date.formatted(date: .omitted, time: .shortened))
                    .font(.headline).bold()
                Text(meal.calories.description + " cal.").font(.headline).bold()
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            Label("View", systemImage: "chevron.right").frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing).labelStyle(.iconOnly)
        }.padding().frame(minHeight: 65)
    }
}

struct NutritionView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var selectedDay: SelectedDay
    
    @State private var plusButtonID = UUID()
    @State private var addingMeal = false
    @State private var newMeal = Meal(name: "Meal", category: .Breakfast)
    @State private var total = 0
    @State private var mealCategory: MealCategory = .Breakfast
    
    func getNumCalories () -> Int {
        var numCals = 0
        for activity in userData.meals {
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
                Section(header: Text("Water Tracker")) {
                    VStack {
                        HStack {
                            ZStack {
                                MainCardBackground()
                                Grid {
                                    GridRow {
                                        Text(String(userData.getWater(selectedDay: selectedDay)) + " / " ).font(.title).bold().foregroundColor(.white).padding(.leading)
                                        TextField("64", value: $userData.waterGoal, format: .number, prompt: Text("64"))
                                            .font(.title).bold()
                                            .textFieldStyle(.roundedBorder)
                                            .padding(.trailing)
                                            .onChange(of: userData.waterGoal) { newValue in
                                                if newValue > 0 {
                                                    userData.waterGoal = newValue
                                                } else {
                                                    userData.waterGoal = 64
                                                }
                                            }
                                    }
                                }
                            }.frame(width: 225, height: 70)
                            ZStack {
                                MainCardBackground()
                                Text("oz.").font(.largeTitle).bold().foregroundColor(.white)
                            }.frame(height: 70)
                        }
                        ProgressView(value: (Float(userData.getWater(selectedDay: selectedDay)) / Float(userData.waterGoal)))
                        Spacer()
                        HStack {
                            Button {
                                userData.changeWater(selectedDay: selectedDay, by: -1)
                            } label: {
                                ZStack {
                                    MainCardBackground()
                                    Image(systemName: "minus").font(.title).bold().foregroundColor(.white)
                                }
                            }.buttonStyle(.plain).disabled(userData.getWater(selectedDay: selectedDay) <= 0)
                            Button {
                                userData.changeWater(selectedDay: selectedDay, by: 1)
                            } label: {
                                ZStack {
                                    MainCardBackground()
                                    Image(systemName: "plus").font(.title).bold().foregroundColor(.white)
                                }
                            }.buttonStyle(.plain)
                        }
                    }.modifier(ListRowStyle())
                }.headerProminence(.increased)
                Section(header: Text("Calories Ingested")) {
                    ZStack {
                        MainCardBackground()
                        let numCalories = getNumCalories()
                        Text(String(numCalories)).font(.largeTitle).bold().foregroundColor(.white)
                    }.modifier(ListRowStyle())
                }.headerProminence(.increased)
                Section(header: Text("Recent Meals")) {
                    Picker("New Item Type", selection: $mealCategory) {
                        ForEach(MealCategory.allCases, id:\.self) { category in
                            Text(String(category.rawValue)).modifier(ListRowStyle()).padding(.leading)
                        }
                    }.pickerStyle(.segmented).modifier(ListRowStyle())
                    ForEach(userData.sortedMeals(category: mealCategory, selectedDay: selectedDay), id:\.self) { $meal in
                        ZStack {
                            MedCardBackground()
                            MealItemView(meal: meal)
                        }.modifier(ListRowStyle())
                            .background(
                                NavigationLink("", destination: MealEditor(meal: $meal, isNew: false))
                            )
                    }
                    if userData.sortedMeals(category: mealCategory, selectedDay: selectedDay).wrappedValue.count < 1 {
                        ZStack {
                            MedCardBackground()
                            Text("Use the \"+\" to add your " + String(mealCategory.rawValue).lowercased() ).font(.headline).bold().padding()
                        }.modifier(ListRowStyle())
                    }
                }.headerProminence(.increased)
            }
            .navigationTitle("Nutrition")
            .toolbar {
                ToolbarItem {
                    Button {
                        newMeal = Meal(date: selectedDay.date, name: "Meal", category: .Breakfast)
                        addingMeal = true
                    } label: {
                        Image(systemName: "plus")
                    }.id(plusButtonID)
                }
            }.sheet(isPresented: $addingMeal) {
                NavigationStack {
                    MealEditor(meal: $newMeal, isNew: true)
                        .onDisappear {
                            // Force an update after sheet is closed to make button clickable again
                            self.plusButtonID = UUID()
                        }
                }
            }
        }
    }
}
