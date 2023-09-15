//
//  UserData.swift
//  LiftLog
//
//  Created by Jay Desmarais on 4/17/23.
//

import SwiftUI
import Foundation

struct Activity: Hashable {
    var id = UUID()
    var activityType: ActivityType = .IndoorRun
    var subActions: [SubAction] = []
    var date = Date()
    var durationHours = 1
    var durationMinutes = 30
    var calories = 0
    var photoData: Data?
    
    mutating func assignPhoto(photoData: Data?) {
        self.photoData = photoData
    }
    
    mutating func delete(subAction: SubAction) {
        if let index = self.subActions.firstIndex(where: { $0.id == subAction.id }) {
            subActions.remove(at: index)
        }
    }
    
    func durationString() -> String {
        var retVal = "Duration: "
        if self.durationHours > 0 {
            retVal += String(self.durationHours) + " Hour"
            retVal += self.durationHours > 1 ? "s, " : ", "
        }
        retVal += String(self.durationMinutes) + " Minute"
        if self.durationMinutes > 1 {
            retVal += "s"
        }
        return retVal
    }
}

struct SubAction: Hashable {
    var id = UUID()
    var name: String
    var rounds: Int?
    var reps: Int?
    var weight: Int?
    var durationMinutes: Int?
    var durationSeconds: Int?
}

enum ActivityType: String, CaseIterable {
    case IndoorRun = "Indoor Run"
    case OutdoorRun = "Outdoor Run"
    case IndoorCycle = "Indoor Cycle"
    case OutdoorCycle = "Outdoor Cycle"
    case IndoorWalk = "Indoor Walk"
    case OutdoorWalk = "Outdoor Walk"
    case Swimming =  "Swimming"
    case WeightTraining = "Weight Training"
    case Yoga = "Yoga"
    case Pilates = "Pilates"
    case Boxing = "Boxing"
    case Hiit = "HIIT"
    case Tennis = "Tennis"
    case Basketball = "Basketball"
    case Golf = "Golf"
    case JumpRope = "Jump Rope"
    case Core = "Core Training"
    
    var calorieRate : Int {
        switch self {
        case .IndoorRun, .OutdoorRun:
            return 50
        case .IndoorCycle, .OutdoorCycle:
            return 40
        case .IndoorWalk, .OutdoorWalk:
            return 20
        case .Boxing:
            return 42
        default:
            return 25
        }
     }
    
    var activityIcon : String {
        let figure = "figure."
        var icon = ""
        switch self {
        case .IndoorRun, .OutdoorRun:
            icon = "run"
        case .OutdoorCycle:
            icon = "outdoor.cycle"
        case .IndoorCycle:
            icon = "indoor.cycle"
        case .IndoorWalk, .OutdoorWalk:
            icon = "walk"
        case .Boxing:
            icon = "boxing"
        case .Swimming:
            icon = "pool.swim"
        case .WeightTraining:
            icon = "strengthtraining.traditional"
        case .Yoga:
            icon = "yoga"
        case .Pilates:
            icon = "pilates"
        case .Hiit:
            icon = "highintensity.intervaltraining"
        case .Tennis:
            icon = "tennis"
        case .Basketball:
            icon = "basketball"
        case .Golf:
            icon = "golf"
        case .JumpRope:
            icon = "jumprope"
        case .Core:
            icon = "core.training"
        }
        return figure + icon
     }
}

struct Meal: Hashable {
    var id = UUID()
    var date = Date()
    var name: String
    var category: MealCategory
    var calories = 0
    var photoData: Data?
    
    mutating func removePhoto() {
        self.photoData = nil
    }
    
    mutating func assignPhoto(photoData: Data?) {
        self.photoData = photoData
    }
}

enum MealCategory: String, CaseIterable {
    case Breakfast = "Breakfast"
    case Lunch = "Lunch"
    case Dinner = "Dinner"
    case Snack = "Snack"
}

struct Water: Hashable {
    var day = Date().formatted(date: .numeric, time: .omitted)
    var amount = 0
}

class SelectedDay: ObservableObject {
    @Published var date: Date = Date()
    
    var dateString: String {
        date.formatted(date: .numeric, time: .omitted)
    }
    
    func changeDay(days: Int) {
        self.date = Calendar.current.date(byAdding: .day, value: days, to: date) ?? Date()
    }
}

@MainActor class UserData: ObservableObject {
    @Published var activities: [Activity] = []
    @Published var meals: [Meal] = []
    @Published var water: [Water] = []
    @Published var waterGoal: Int = 64

    func addActivity(activity: Activity) {
        activities.append(activity)
    }
    
    func addMeal(meal: Meal) {
        meals.append(meal)
    }
    
    func getWater(selectedDay: SelectedDay) -> Int {
        if let index = self.water.firstIndex(where: { $0.day == selectedDay.dateString}) {
            return self.water[index].amount
        } else {
            water.append(Water(day: selectedDay.dateString))
            return 0
        }
    }
    
    func changeWater(selectedDay: SelectedDay, by: Int) {
        if let index = self.water.firstIndex(where: { $0.day == selectedDay.dateString}) {
            self.water[index].amount += by
        }
    }
    
    func sortedActivities(selectedDay: SelectedDay) -> Binding<[Activity]> {
        Binding<[Activity]>(
            get: {
                self.activities.sorted{$0.date > $1.date}.filter({ $0.date.formatted(date: .numeric, time: .omitted) == selectedDay.dateString})
            },
            set: { activities in
                for activity in activities {
                    guard let index = self.activities.firstIndex(where: { $0.id == activity.id }) else { return }
                    self.activities[index] = activity
                }
            }
        )
    }
    
    func sortedMeals(category: MealCategory, selectedDay: SelectedDay) -> Binding<[Meal]> {
        Binding<[Meal]>(
            get: {
                self.meals.sorted{$0.date > $1.date}.filter{$0.category == category}.filter({$0.date.formatted(date: .numeric, time: .omitted) == selectedDay.dateString})
            },
            set: { meals in
                for meal in meals {
                    guard let index = self.meals.firstIndex(where: { $0.id == meal.id }) else { return }
                    self.meals[index] = meal
                }
            }
        )
    }
    
    func duplicate(activity: Activity) {
        if let index = self.activities.firstIndex(where: { $0.id == activity.id }) {
            var activityDuplicate = activities[index]
            activityDuplicate.id = UUID()
            self.addActivity(activity: activityDuplicate)
        }
    }
    
    func delete(activity: Activity) {
        if let index = self.activities.firstIndex(where: { $0.id == activity.id }) {
            activities.remove(at: index)
        }
    }
    
    func delete(meal: Meal) {
        if let index = self.meals.firstIndex(where: { $0.id == meal.id }) {
            meals.remove(at: index)
        }
    }
}
