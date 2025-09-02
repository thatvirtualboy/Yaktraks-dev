//
//  About.swift
//  YakTrak
//
//  Created by Ryan Klumph on 9/7/21.
//

import SwiftUI
import TelemetryDeck

struct About: View {
    
    var body: some View {
        
        //NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("A note from the developer")
                    Text("\nHello! 👋 I'm so glad you downloaded Yaktraks. \n\nFor many of us, our lives have dramatically changed in recent years, with more and more changing each day. However one thing has remained constant: the need for our kids’ entertainment! Just the other day, my kids discovered a new microphone at my desk and they asked if they could play with it. I sat them on my lap and launched QuickTime so they could record and hear their own voices. They had so much fun coming up with silly things to say and hearing it play back, it sparked an idea. 💡\n\nRemember those old voice recorder toys from the 90s and 2000s? They were small, brightly colored, and *extremely* lacking in features by today’s modern toy standards. But the truth of the matter is, kids are great at finding joy in simple things. Be it a cardboard box they can color and turn into a spaceship, or a microphone where they can say whatever silly things come to mind.\n\nAll of this inspired the small, simple project for iOS that you are now using. 🥳\n\nYaktraks is all about pure, honest fun. It’s an iOS app that is built for kids which allows them to record their voice, and play it back with silly sound effects. But what makes Yaktraks different from other “voice changer” apps out there? Well, Yaktraks is\n").foregroundColor(.secondary)
                    
                    Text("""
            • Built for kids with bright colors and ease of use
            • Is privacy focused with no personally identifiable information ever collected
            • Is built upon the same principle of the voice-changer toys of olde - simplicity and honest fun
            • Is free and requires no monthly subscription
            """).foregroundColor(.secondary)
                    
                    Text("\nAdditionally, Yaktraks features\n").foregroundColor(.secondary)
                    
                    Text("""
                • 6-second recordings just like the toys from the 90s (additional recording durations available via IAP)
                • 4 included voice effects (and another 4 available via IAP)
                • Multiple App Icons to choose from to customize the homescreen (some included, some available via IAP)
                • Locked content and future updates & features are available with a one-time small purchase of just $1.99
                """).foregroundColor(.secondary)
                    
                    Text("\nI hope you enjoy using Yaktraks! 🙏 \n\n-Ryan").foregroundColor(.secondary)
                }
                .padding()
           // }
            .navigationTitle("About")
            .preferredColorScheme(.dark)
            .onAppear { TelemetryAbout() }
            
        }
    }
    
    func TelemetryAbout() {
        TelemetryManager.send("AboutAccessed",
                              with: ["Opened" : "true"])
    }
}

struct About_Previews: PreviewProvider {
    static var previews: some View {
        About()
    }
}
