//
//  ProFeaturesView.swift
//  YakTrak
//
//  Created by Ryan Klumph on 8/26/21.
//

import SwiftUI
import StoreKit
import TelemetryDeck

struct ProFeaturesView: View {
    
    enum Sheet { case gate }
    @State var sheet: Sheet? = nil
    @StateObject var storeManager: StoreManager
    
    var body: some View {
        ScrollView {
            Capsule()
                .fill(Color.gray)
                .frame(width: 80, height: 5)
                .padding(.vertical)
        VStack {
            Text("unlock more\n awesome")
                .font(Font.custom("BungeeInline-Regular", size: 45))
                .foregroundColor(Color("neongreen"))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
            
            Text ("Double the FX")
                .font(Font.custom("BungeeInline-Regular", size: 26))
                .foregroundColor(Color("neonyellow"))
                .multilineTextAlignment(.center)
                .padding()
            HStack {
                Spacer()
                Text("🤖")
                    .shadow(radius: 10)
                    .padding()
                    .font(.system(size: 40))
                    .background(Color(("neonpink")))
                    .clipShape(Circle())
                
                
                Text("⛪️")
                    .shadow(radius: 10)
                    .padding()
                    .font(.system(size: 40))
                    .background(Color(("neonblue")))
                    .clipShape(Circle())
                
                Text("🔊")
                    .shadow(radius: 10)
                    .padding()
                    .font(.system(size: 40))
                    .background(Color(("neonpurple")))
                    .clipShape(Circle())
                
                Text("📻")
                    .shadow(radius: 10)
                    .padding()
                    .font(.system(size: 40))
                    .background(Color(("neongreen")))
                    .clipShape(Circle())
                
                Spacer()
            }.padding(.bottom)
            
            Text ("Triple the icons")
                .font(Font.custom("BungeeInline-Regular", size: 26))
                .foregroundColor(Color("neonpink"))
                .multilineTextAlignment(.center)
                .padding()
            HStack {
                Image("alternate_pinklines")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .cornerRadius(15)
                    .shadow(color: Color("neonpink"), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                Image("alternate_facecolors")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .cornerRadius(15)
                    .shadow(color: .white, radius: 10, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                Image("alternate_djdark")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .cornerRadius(15)
                    .shadow(color: .white, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                Image("alternate_blueyak")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .cornerRadius(15)
                    .shadow(color: Color("neonblue"), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
            }.padding(.bottom)
            Group {
                Text("Recording durations")
                    .font(Font.custom("BungeeInline-Regular", size: 26))
                    .foregroundColor(Color("neonpurple"))
                    .multilineTextAlignment(.center)
                    .padding()
                Text("10, 15, 25, and 60 seconds")
                    .gradientForeground(colors: [Color("neonblue"), Color("neonyellow")])
                    .font(.title3)
                    .padding(.bottom)
                Spacer()
            }
            
            // Check if IAP has been purchased
            if UserDefaults.standard.bool(forKey: "com.thatvirtualboy.VoiceRecorderApp.pro") {
                Text("Unlocked!")
                    .gradientForeground(colors: [Color("neonblue"), Color("neonpink")])
                    .padding()
            } else {
                Button (action: {
                    
                    sheet = .gate
                    TelemetryManager.send("ProFeaturesView",
                                          with: ["Opened" : "true"])
                    
                }, label: {
                    Text("Tap to unlock more awesome")
                        .cornerRadius(8)
                        .foregroundColor(.black)
                    
                    
                })
                .buttonStyle(GradientButtonStyle2()).padding()
                .shadow(color: Color("neonpink").opacity(0.4), radius: 20, x: 0, y: 10)
                .padding()
            }
            Button (action: {
                
                storeManager.restoreProducts()
                
            }, label: {
                Text("Restore Purchases")
                    .foregroundColor(.secondary)
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                
            })
            .padding(.bottom)
            
            Text("In App Purchases require the help of a Parent or Guardian")
                .font(.footnote)
                .foregroundColor(.secondary)
                .opacity(0.7)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .padding(.bottom, 10)
            Spacer()
        }
        }
        .preferredColorScheme(.dark)
        .sheet(using: $sheet) { sheet in
            switch sheet {
            case .gate:
                GateScreen()
            }
        }
    }
}

struct ProFeaturesView_Previews: PreviewProvider {
    static var previews: some View {
        ProFeaturesView(storeManager: StoreManager())
    }
}
