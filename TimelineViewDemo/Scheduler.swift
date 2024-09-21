//
//  Scheduler.swift
//  TimelineViewDemo
//
//  Created by Frog on 2024/9/17.
//

import SwiftUI

final class DataModel {
    var offset: CGFloat = 0
}

struct Scheduler: View {
    private var formatter = DateFormatter()
    private var dataModel = DataModel()
    
    @State private var isMarqueeing = false
    
    var body: some View {
        List {
            Section("Periodic") {
                TimelineView(.periodic(from: .now, by: 1), content: { context in
                    Text(formatDate(context.date))
                        .font(.largeTitle)
                })
            }
            
            Section("Every Minute") {
                TimelineView(.everyMinute) { context in
                    Text(context.date, style: .time)
                        .font(.largeTitle)
                }
            }
            
            Section("Explicit Sequence") {
                TimelineView(.explicit([
                    .now,
                    .now.addingTimeInterval(5),
                    .now.addingTimeInterval(10)
                ])) { context in
                    Text(formatDate(context.date))
                        .font(.largeTitle)
                }
            }
            
            Section("Animation") {
                VStack {
                    GeometryReader { reader in
                        TimelineView(.animation) { context in
                            let _ = { dataModel.offset -= 1
                                if dataModel.offset <= -reader.size.width {
                                    dataModel.offset = 0
                                }
                            }()
                            
                            Text("Hello TimelineView")
                                .font(.largeTitle)
                                .offset(x: dataModel.offset)
                        }
                    }
                }
                
                VStack {
                    VStack {
                        GeometryReader { reader in
                            TimelineView(.animation(minimumInterval: 0.01, paused: !isMarqueeing)) { context in
                                let _ = { dataModel.offset -= 1
                                    if dataModel.offset <= -reader.size.width {
                                        dataModel.offset = 0
                                    }
                                }()
                                
                                Text("Hello TimelineView")
                                    .font(.largeTitle)
                                    .offset(x: dataModel.offset)
                            }
                        }
                    }
                    .padding()
                    
                    Button( isMarqueeing ? "Stop" : "Start") {
                        isMarqueeing.toggle()
                    }
                    .buttonStyle(.bordered)
                    .padding()
                }
            }
        }
    }
                             
     private func formatDate(_ date: Date) -> String {
         formatter.dateFormat = "h:m s"
         
         return formatter.string(from: date)
     }
    
    private func future() -> Date{
        return Date.now.addingTimeInterval(10000)
    }
}

#Preview {
    Scheduler()
}
