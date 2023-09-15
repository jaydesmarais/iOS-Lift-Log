//
//  ActivityDetail.swift
//  LiftLog
//
//  Created by Jay Desmarais on 4/22/23.
//

import SwiftUI
import PhotosUI

struct ActivityDetail: View {
    @EnvironmentObject var userData: UserData
    @Environment(\.dismiss) var dismiss
    @Binding var activity: Activity
    
    @State var deletingActivity = false
    @State var duplicateAlert = false
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedPhotoData: Data?
    
    let isEditing: Bool
    let isNew: Bool
    
    var body: some View {
        List {
            if isEditing {
                ActivityDetailEditor(activity: $activity)
                ForEach($activity.subActions, id:\.id) { $subAction in
                    SubActionEditor(activity: $activity, subAction: $subAction)
                }
                Section {
                    Button {
                        activity.subActions.append(SubAction(name: "Sub Action " + String(activity.subActions.count + 1)))
                    } label: {
                        Section {
                            Text("Add Sub-Action")
                        }
                    }
                }
                Section {
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Text("Select a photo")
                    }
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                activity.assignPhoto(photoData: data)
                            }
                        }
                    }
                    if let selectedPhotoData = activity.photoData,
                       let image = UIImage (data: selectedPhotoData) {
                        Image(uiImage: image).resizable().scaledToFit()
                        Button(role: .destructive) {
                            activity.photoData = nil
                        } label: {
                            Text("Remove Photo")
                        }
                    }
                }
                Section {
                    if !isNew {
                        Button {
                            duplicateAlert.toggle()
                            userData.duplicate(activity: activity)
                        } label: {
                            Text("Duplicate Activity")
                        }.alert(
                            "Duplicate Created",
                            isPresented: $duplicateAlert
                        ) {
                            Button {
                            } label: {
                                Text("Thanks!")
                            }
                        } message: {
                            Text("Your duplicate has been created and will display on the main page! You may now edit the copy here without impacting your duplicate")
                        }
                        Button(role: .destructive) {
                            deletingActivity.toggle()
                        } label: {
                            Text("Delete Activity")
                        }.confirmationDialog("Do you really want to delete?", isPresented: $deletingActivity) {
                            Button("Yes, I want to delete this activity", role: .destructive) {
                                dismiss()
                                userData.delete(activity: activity)
                            }
                            Button("No! Don't delete it!", role: .cancel) { }
                        }
                    }
                }
            } else {
                Section {
                    Label(activity.activityType.rawValue, systemImage:activity.activityType.activityIcon)
                        .font(.title2).bold()
                        .labelStyle(.titleAndIcon).padding()
                    HStack {
                        Text(activity.date, style: .date)
                        Text(activity.date, style: .time)
                    }
                    Text(activity.durationString())
                    Text(String(activity.calories) + " Calories Burned")
                }
                ForEach(activity.subActions, id:\.self) { subAction in
                    Section {
                        Text(String(subAction.name)).font(.title3).fontWeight(.semibold)
                        SubActionRoundsReps(rounds: subAction.rounds, reps: subAction.reps)
                        if let weight = subAction.weight {
                            Text(String(weight) + " lbs.")
                        }
                        SubActionDuration(minutes: subAction.durationMinutes, seconds: subAction.durationSeconds)
                    }
                }
                Section {
                    if let selectedPhotoData = activity.photoData, let image = UIImage (data: selectedPhotoData) {
                        Image(uiImage: image).resizable().scaledToFit()
                    }
                }
            }
        }
    }
}
