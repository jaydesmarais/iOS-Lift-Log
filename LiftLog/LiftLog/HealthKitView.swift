//
//  HealthKitView.swift
//  LiftLog
//
//  Created by Jay Desmarais on 5/1/23.
//

import SwiftUI

struct HealthKitView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var loginSettings: LoginSettings
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            Image("AppleHealthIcon").resizable().scaledToFit().frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading).padding(.leading, 70)
            VStack {
                Text("Automatically sync your readings with Apple Health.").font(Font.system(size: 35).weight(.semibold)).padding([.trailing, .bottom], 50)
                Text("Using LiftLog with the Apple Health App on iPhone allows you to access and manage your LiftLog data in the Apple Health App and vice versa, giving you extra flexibility!\n\nWe securely access your data from Apple HealthKit and will never store it. You can always change your HealthKit settings in Apple Settings or the Apple Health App. ").padding(.horizontal).multilineTextAlignment(.leading)
            }.padding(.leading, 20)
            Button {
                loginSettings.requestHealthKitPermissions()
            } label: {
                ZStack {
                    MainCardBackground().frame(maxHeight: 60)
                    Label("Enable HealthKit", systemImage: "heart.fill").font(.title3.weight(.semibold)).foregroundColor(.white)
                }
            }.buttonStyle(.plain).padding(.horizontal).padding(.top, 25)
            Button("Skip for Now") {
                loginSettings.hasRequestedHealthData = true
            }.foregroundColor(.primary).padding()
            Spacer()
        }.background(colorScheme == .light ? Color.init(.lightGray) : Color.black)
    }
}

struct HealthKitView_Previews: PreviewProvider {
    static var previews: some View {
        HealthKitView()
            .environmentObject(LoginSettings())
    }
}
