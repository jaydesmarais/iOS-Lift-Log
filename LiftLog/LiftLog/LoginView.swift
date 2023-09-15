//
//  LoginView.swift
//  LiftLog
//
//  Created by Jay Desmarais on 5/1/23.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var loginSettings: LoginSettings
    
    var body: some View {
        VStack {
            Spacer()
            Label("LiftLog", systemImage: "figure.run").font(Font.system(size: 75).weight(.semibold)).padding()
            Spacer()
            Button {
                loginSettings.isLoggedIn = true
            } label: {
                ZStack {
                    MainCardBackground().frame(maxHeight: 60)
                    Label("Login", systemImage: "lock.fill").font(.title3.weight(.semibold)).foregroundColor(.white)
                }.padding(.top, 70)
            }.buttonStyle(.plain).padding(.horizontal)
            Spacer()
            Text("Created by Jay Desmarais and Vernon Edejar")
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(LoginSettings())
    }
}
