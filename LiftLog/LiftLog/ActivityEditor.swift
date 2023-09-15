//
//  ActivityEditor.swift
//  LiftLog
//
//  Created by Jay Desmarais on 4/18/23.
//

import SwiftUI

struct ActivityEditor: View {
    @Binding var activity: Activity
    var isNew: Bool
    
    @EnvironmentObject var userData: UserData
    @Environment(\.dismiss) var dismiss

    @State private var activityCopy = Activity()
    @State private var isEditing = false
    
    var body: some View {
        ActivityDetail(activity: $activityCopy, isEditing: isNew ? true: isEditing, isNew: isNew)
            .toolbar {
                if isEditing || isNew {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                            /* Removed because entering a value to a Sub-Action and keeping the textField selected changed the value in the detail view after cancelling an edit.
                             *
                             * activityCopy = activity
                             * isEditing.toggle()
                             * if isNew {
                             *    dismiss()
                             * }
                             */
                        }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    if isNew {
                        Button("Add") {
                            userData.addActivity(activity: activityCopy)
                            dismiss()
                        }
                    } else {
                        Button(isEditing ? "Done" : "Edit") {
                            if isEditing {
                                activity = activityCopy
                            }
                            isEditing.toggle()
                        }.navigationBarBackButtonHidden(isEditing)
                    }
                }
            }
            .onAppear {
                activityCopy = activity
            }
    }
}
