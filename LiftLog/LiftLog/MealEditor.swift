//
//  MealEditor.swift
//  LiftLog
//
//  Created by Jay Desmarais on 4/23/23.
//

import SwiftUI

struct MealEditor: View {
    @Binding var meal: Meal
    var isNew: Bool
    
    @EnvironmentObject var userData: UserData
    @Environment(\.dismiss) var dismiss

    @State private var mealCopy = Meal(name: "Cereal", category: .Breakfast)
    @State private var isEditing = false
    
    var body: some View {
        MealDetail(meal: $mealCopy, isEditing: isNew ? true: isEditing, isNew: isNew)
            .toolbar {
                if isEditing || isNew {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    if isNew {
                        Button("Add") {
                            userData.addMeal(meal: mealCopy)
                            dismiss()
                        }
                    } else {
                        Button(isEditing ? "Done" : "Edit") {
                            if isEditing {
                                meal = mealCopy
                            }
                            isEditing.toggle()
                        }.navigationBarBackButtonHidden(isEditing)
                    }
                }
            }
            .onAppear {
                mealCopy = meal
            }
    }
}

