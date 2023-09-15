//
//  ActivityDetailComponents.swift
//  LiftLog
//
//  Created by Jay Desmarais on 5/1/23.
//

import SwiftUI

struct SubActionEditor: View {
    @Binding var activity: Activity
    @Binding var subAction: SubAction
    
    var body: some View {
        Section {
            HStack {
                Button(role: .destructive) {
                    activity.delete(subAction: subAction)
                } label: {
                    Image(systemName: "minus.circle")
                }
                TextField("Sub-Action Name", text: $subAction.name).textFieldStyle(.roundedBorder).font(.title2)
            }
            HStack {
                HStack {
                    TextField("Rounds", value: $subAction.rounds, format: .number, prompt: Text("Rounds")).textFieldStyle(.roundedBorder)
                    Text("Rounds")
                }
                Text(" x ").bold()
                HStack {
                    TextField("Reps", value: $subAction.reps, format: .number, prompt: Text("Reps")).textFieldStyle(.roundedBorder)
                    Text("Reps")
                }
            }
            HStack {
                TextField("Weight", value: $subAction.weight, format: .number, prompt: Text("Weight")).textFieldStyle(.roundedBorder)
                Text("lbs.")
            }
            HStack {
                TextField("Minutes", value: $subAction.durationMinutes, format: .number, prompt: Text("Minutes")).textFieldStyle(.roundedBorder)
                Text("Min.")
                TextField("Seconds", value: $subAction.durationSeconds, format: .number, prompt: Text("Seconds")).textFieldStyle(.roundedBorder)
                Text("Sec.")
            }
        }
    }
}

struct ActivityDetailEditor: View {
    @EnvironmentObject var userData: UserData
    @Binding var activity: Activity
    
    var body: some View {
        Section {
            Menu {
                Picker(selection: $activity.activityType, label: Text("Activity Type")) {
                    ForEach(ActivityType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
            } label: {
                Label(activity.activityType.rawValue, systemImage:activity.activityType.activityIcon)
                    .font(.title2)
                    .labelStyle(.titleAndIcon).padding()
            }.id(activity.activityType)
            DatePicker("Date", selection: $activity.date).labelsHidden()
            HStack {
                Text("Duration:").padding(.trailing)
                HStack {
                    TextField("1", value: $activity.durationHours, format: .number).textFieldStyle(.roundedBorder)
                    Text("hrs.")
                }
                HStack {
                    TextField("0", value: $activity.durationMinutes, format: .number).textFieldStyle(.roundedBorder)
                    Text("mins.")
                }
            }
            HStack {
                TextField("Calories Burned", value: $activity.calories, format: .number, prompt: Text("Calories Burned")).textFieldStyle(.roundedBorder)
                Text("Calories Burned")
            }
        }
    }
}

struct SubActionRoundsReps: View {
    var rounds: Int?
    var reps: Int?
    
    var body: some View {
        if rounds != nil || reps != nil {
            HStack {
                if let rounds = rounds {
                    Text(String(rounds) + " Rounds")
                }
                if let _ = rounds, let _ = reps {
                    Text(" x ").bold()
                }
                if let reps = reps {
                    Text(String(reps) + " Reps")
                }
            }
        }
    }
}

struct SubActionDuration: View {
    var minutes: Int?
    var seconds: Int?
    
    var body: some View {
        if minutes != nil || seconds != nil {
            HStack {
                if let minutes = minutes {
                    Text(String(minutes) + String(minutes > 1 ? " Minutes" : " Minute"))
                }
                if let seconds = seconds {
                    Text(String(seconds) + " Seconds")
                }
            }
        }
    }
}
