//
//  SimpleMarquee.swift
//  TimelineViewDemo
//
//  Created by Frog on 2024/9/21.
//

import SwiftUI

struct InnerWidthPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    func measureWidth(_ onChange: @escaping (CGFloat) -> ()) -> some View {
        overlay {
            GeometryReader { reader in
                Color.clear.preference(key: InnerWidthPreferenceKey.self, value: reader.size.width)
            }
        }
        .onPreferenceChange(InnerWidthPreferenceKey.self, perform: { onChange($0) })
    }
}


final class SimpleMarqueeDataContext {
    var offset: CGFloat = 0
    
    var contentWidth: CGFloat = 0
    
    private var lastTimeInterval: TimeInterval?
    
    var containerWidth: CGFloat = 0
    
    var instanceCount = 0
    
    public func updateOffset(_ timeInterval: TimeInterval) {
        if let lastTimeInterval = lastTimeInterval {
            let diff = timeInterval - lastTimeInterval
            offset += diff * 50
        }
        
        if offset >= containerWidth {
            offset = 0
        }
        
        lastTimeInterval = timeInterval
    }
}

struct SimpleMarquee<Content>: View where Content: View {
    private var content: () -> Content
    private var dataContext: SimpleMarqueeDataContext = .init()
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        GeometryReader { reader in
            TimelineView(.animation) { context in
                let _ = {
                    dataContext.updateOffset(context.date.timeIntervalSince1970)
                }()
                HStack(spacing: 0) {
                    content()
                        .measureWidth { width in
                            dataContext.contentWidth = width
                        }

                    content()
                        .offset(x: reader.size.width - dataContext.contentWidth)
                }
                .offset(x: -dataContext.offset)
            }
            .onAppear {
                dataContext.containerWidth = reader.size.width
            }
        }
    }
}

struct SimpleMarqueeView: View {
    var body: some View {
        VStack {
            SimpleMarquee {
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Hello, TimelineView!")
                }
                .padding()
                .border(.red)
            }
        }
    }
}

#Preview {
    SimpleMarqueeView()
}
