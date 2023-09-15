//
//  MealDetail.swift
//  LiftLog
//
//  Created by Jay Desmarais on 4/23/23.
//

import SwiftUI
import PhotosUI

struct MealDetail: View {
    @EnvironmentObject var userData: UserData
    @Environment(\.dismiss) var dismiss
    @Binding var meal: Meal
    
    @State var deletingMeal = false
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedPhotoData: Data?
    
    let isEditing: Bool
    let isNew: Bool
    
    var body: some View {
        List {
            if isEditing {
                TextField("Meal Name", text: $meal.name).font(.title2).padding()
                DatePicker("Date", selection: $meal.date).labelsHidden()
                Picker(selection: $meal.category, label: Text("Category:")) {
                    ForEach(MealCategory.allCases, id: \.self) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                HStack {
                    TextField("Calories Ingested", value: $meal.calories, format: .number, prompt: Text("Calories Ingested")).textFieldStyle(.roundedBorder)
                    Text("Calories Ingested")
                }
                Section {
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Text("Select a photo")
                    }
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable (type: Data.self) {
                                meal.assignPhoto(photoData: data)
                            }
                        }
                    }
                    if let selectedPhotoData = meal.photoData, let image = UIImage (data: selectedPhotoData) {
                        Image(uiImage: image).resizable().scaledToFit()
                        Button(role: .destructive) {
                            meal.photoData = nil
                        } label: {
                            Text("Remove Photo")
                        }
                    }
                }
                Section {
                    if !isNew {
                        Button(role: .destructive) {
                            deletingMeal.toggle()
                        } label: {
                            Text("Delete Meal")
                        }.confirmationDialog("Do you really want to delete?", isPresented: $deletingMeal) {
                            Button("Yes, I want to delete this item", role: .destructive) {
                                dismiss()
                                userData.delete(meal: meal)
                            }
                            Button("No! Don't delete it!", role: .cancel) { }
                        }
                    }
                }

            } else {
                Text(meal.name).font(.title2).fontWeight(.semibold).padding()
                HStack {
                    Text(meal.date, style: .date)
                    Text(meal.date, style: .time)
                }
                Text("Category: " + String(meal.category.rawValue))
                Text(String(meal.calories) + " Calories Ingested")
                Section {
                    if let selectedPhotoData = meal.photoData, let image = UIImage (data: selectedPhotoData) {
                        Image(uiImage: image).resizable().resizable().scaledToFit()
                    }
                }
            }
        }
    }
}

