//
//  UserViewModel.swift
//  ObserverVR
//
//  Created by Uri on 25/3/23.
//

import Foundation
import Combine


class UserViewModel{
    var userList: [UserModel] = []
    var reloadData = PassthroughSubject<Void, Error>()  // Observable that notifies the view when VM has data for it
    @Published var isLoading: Bool?     // Observable, notifies the view if true or false
    
    func getUsers(){
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.userList = UserModel.getUsers()
            self.reloadData.send()
            self.isLoading = false
        }
    }
}
