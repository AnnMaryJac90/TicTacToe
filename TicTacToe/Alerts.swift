//
//  Alerts.swift
//  TicTacToe
//
//  Created by Anil Thomas on 2/24/22.
//

import SwiftUI
struct AlertItem: Identifiable{
    let id = UUID()
    var title : Text
    var message :Text
    var buttonTitle : Text
}


struct AlertContext {
   static let  humanWin = AlertItem(title: Text("You Win!!"),
                              message: Text("You are an excellent player"),
                              buttonTitle: Text("Ok"))
    
  static  let machineWin = AlertItem(title: Text("You Lost"),
                               message: Text("Better luck next time"),
                               buttonTitle: Text("Play again"))
    
   static let draw = AlertItem(title: Text("Draw"),
                         message: Text("What a game!!"),
                         buttonTitle: Text("Try Again"))
    
}
