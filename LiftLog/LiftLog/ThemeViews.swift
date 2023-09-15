//
//  ThemeViews.swift
//  LiftLog
//
//  Created by Jay Desmarais on 4/18/23.
//

import SwiftUI

struct ListRowStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }
}

struct MedCardBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(Color.init(.lightGray))
    }
}

struct MainCardBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(Color.init(.darkGray))
    }
}

struct DateSelector: View {
    @EnvironmentObject var selectedDay: SelectedDay
    
    var body: some View {
        HStack {
            ZStack {
                HStack {
                    Button {
                        selectedDay.changeDay(days: -7)
                    } label: {
                        Image(systemName: "chevron.left.2")
                    }.buttonStyle(.bordered).foregroundColor(.primary)
                    Button {
                        selectedDay.changeDay(days: -1)
                    } label: {
                        Image(systemName: "chevron.left")
                    }.buttonStyle(.bordered).foregroundColor(.primary)
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                Text(selectedDay.dateString).font(.title3).bold().onTapGesture {
                    selectedDay.date = Date()
                }
                HStack {
                    Button {
                        selectedDay.changeDay(days: 1)
                    } label: {
                        Image(systemName: "chevron.right")
                    }.buttonStyle(.bordered).foregroundColor(.primary)
                    Button {
                        selectedDay.changeDay(days: 7)
                    } label: {
                        Image(systemName: "chevron.right.2")
                    }.buttonStyle(.bordered).foregroundColor(.primary)
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
            }
        }.modifier(ListRowStyle())
    }
}
