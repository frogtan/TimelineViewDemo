//
//  TimelineViewDemoApp.swift
//  TimelineViewDemo
//
//  Created by Frog on 2024/9/13.
//

import SwiftUI

@main
struct TimelineViewDemoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                List {
                    NavigationLink {
                        DisplayTime()
                    } label: {
                        Text("Display Time")
                    }

                    NavigationLink {
                        Scheduler()
                    } label: {
                        Text("Scheduler")
                    }
                    
                    NavigationLink {
                        SimpleMarqueeView()
                    } label: {
                        Text("Simple Marquee")
                    }
                }
            }
        }
    }
}
