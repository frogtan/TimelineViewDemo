//
//  DisplayTime.swift
//  TimelineViewDemo
//
//  Created by Frog on 2024/9/14.
//

import SwiftUI
import Combine

struct DisplayTime: View {
    @State private var date = Date.now
    @State private var timerToken: AnyCancellable?
    
    private var formatter = DateFormatter()
    
    var body: some View {
        List {
            Section("Timer") {
                Text(formatDate(date))
                    .font(.largeTitle)
            }
            
            Section("TimelineView") {
                TimelineView(.periodic(from: .now, by: 1)) { context in
                    Text(formatDate(context.date))
                        .font(.largeTitle)
                }
            }
        }
        .onAppear {
            timerToken = Timer.publish(every: 1, on: .main, in: .common)
                .autoconnect()
                .sink { _ in
                    date = .now
                }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        formatter.timeStyle = .medium
        
        return formatter.string(from: date)
    }
}

#Preview {
    DisplayTime()
}
