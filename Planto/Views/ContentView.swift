//
//  ContentView.swift
//  Planto
//
//  Created by Rana on 01/05/1447 AH.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {           // اختياري بس يريح بالتنقّل لاحقًا
            TodayReminderView()     // كل المنطق داخلها (سبلاش + ليست)
                .navigationBarBackButtonHidden(true) // لو حابة تتأكدي ما يظهر السهم
        }
    }
}

#Preview {
    ContentView()
}

 
