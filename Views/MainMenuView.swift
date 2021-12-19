//
//  MainMenuView.swift
//  GermanLearning
//
//  Created by Niklas on 02/08/2021.
//  This view is the main menu which is shown when the app is launched
//  Contains a button to load MainAppView

import SwiftUI

struct MainMenuView: View {
    // Store managed object context
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        NavigationView{
            ZStack {
                // Background image                
                MainMenuBackgroundView()
                    .opacity(0.2)
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    
                    Spacer()
                    
                    // DeutschBlox Text
                    VStack(alignment: .leading) {
                        Text("Deutsch")
                            .font(.system(size: 80))
                            .fontWeight(.heavy)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 10.0)
                            .background(Color.purple)
                            .cornerRadius(20)
                        
                        Text("Blox")
                            .font(.system(size: 80))
                            .fontWeight(.heavy)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 10.0)
                            .background(Color.blue)
                            .cornerRadius(20)
                    }
                    
                    Spacer()
                    Spacer()
                    
                    // Start button
                    NavigationLink(destination: MainAppView().environment(\.managedObjectContext, context)) {
                        
                        HStack {
                            Text("Start")
                                .font(.system(size: 50))
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 40, weight: .bold))
                                .padding(.leading, 10)
                        }
                        .foregroundColor(.white)
                        .frame(width: 250)
                        .padding(.all, 15)
                        .background(Color.pink)
                        .cornerRadius(20)
                        .padding(.bottom, 10)
                    }
                    
                    
                    Spacer()

                }
                .navigationBarHidden(true)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
