//
//  PrivacyView.swift
//  PrivacyView
//
//  Created by Ryan Klumph on 9/13/21.
//

import SwiftUI

struct PrivacyView: View {
    
    @Environment(\.presentationMode) var presentationMode
    let privacyURL = "https://thatvirtualboy.com/privacy"
    
    var body: some View {
        NavigationView {
            VStack {
                Image("privacy-handshake-icon")
                    .resizable()
                    .frame(width: 90, height: 71)
                    .padding()
                
                Text("Yaktraks & Privacy")
                    .font(.largeTitle)
                    .bold()
                
                Text("Yaktraks is designed to protect your information so you don't have to worry about your data.")
                    .padding(5)
                    .padding(.horizontal, 30)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("Your Personal Information")
                    .font(.headline)
                Text("Personal information is never collected. Voice recordings are stored on your device and never shared outside of the app.")
                    .font(.callout)
                    .padding(.horizontal)
                    .padding(.top,1)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("Collected Information")
                    .font(.headline)
                Text("Yaktraks collects usage data in order to improve the app. This may include information like device type, iOS version, app version, language, and feature utilization. No personally identifiable information is ever collected.\n\nLearn more at https://thatvirtualboy.com/privacy")
                    .font(.callout)
                    .padding(.horizontal)
                    .padding(.top,1)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
     
                // below removed due to kids app access... later can re-introduce to have a check if guardian or something
//                Group {
//                    if let url = URL(string: privacyURL) {
//                Link("Learn more", destination: url).padding(.bottom)
//                    }
//                }
//                .padding()

                Spacer()
                
                Text("")
                    .padding()

            }
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) { Text("Done")}
                                
            )
            .preferredColorScheme(.dark)
        }
    }
}

struct PrivacyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyView()
    }
}
