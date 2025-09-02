//
//  Clock.swift
//  YakTrak
//
//  Created by Ryan Klumph on 8/28/21.
//  Derived from https://marcgg.com/blog/2020/05/06/circular-progressbar-clock-swiftui/

import SwiftUI

let timer = Timer
    .publish(every: 1, on: .main, in: .common)
    .autoconnect()

struct Clock: View {
    var counter: Int
    var countTo: Int
    
    var body: some View {
        VStack {
            Text(counterToMinutes())
                .foregroundColor(.secondary)
        }
    }
    
    func counterToMinutes() -> String {
        let currentTime = countTo - counter
        let seconds = currentTime % 60
        
        return "\(seconds < 10 ? "" : "")\(seconds)s"
    }
    
    func progress() -> CGFloat {
        return (CGFloat(counter) / CGFloat(countTo))
    }
    
    func completed() -> Bool {
        return progress() == 1
    }
}


// example view calling the clock
struct CountdownView: View {
    @State var counter: Int = 0
    @State var countTo: Int = 59
    
    var body: some View {
        
        VStack{
            ZStack{
                Clock(counter: counter, countTo: countTo)
            }
        }.onReceive(timer) { time in
            if (self.counter < self.countTo) {
                self.counter += 1
            }
        }
    }
    
    func progress() -> CGFloat {
        return (CGFloat(counter) / CGFloat(countTo))
    }
    
    func completed() -> Bool {
        return progress() == 1
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView()
    }
}
