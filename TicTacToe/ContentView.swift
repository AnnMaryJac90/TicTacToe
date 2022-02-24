//
//  ContentView.swift
//  TicTacToe
//
//  Created by Anil Thomas on 2/23/22.
//

import SwiftUI

let coloums : [GridItem] = [GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())]

struct ContentView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack{
                Spacer()
            LazyVGrid(columns: coloums,spacing: 15){
                ForEach(0..<9){i in
                    ZStack{
                        Circle()
                            .foregroundColor(.blue)
                            .frame(width: geometry.size.width/3-10, height: geometry.size.width/3-10, alignment: .center)
                            
                    }
                }

                
            }
                Spacer()
            
            }.padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
