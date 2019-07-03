//
//  GenricValue.swift
//  PhotosApp
//
//  Created by Varun Tomar on 21/05/19.
//  Copyright © 2019 Varun Tomar. All rights reserved.
//

import Foundation

class GenricValue<T> {
    typealias ComplitionHandler = (_ value:T) -> Void
    
    var value : T {
        didSet{
            //notify
            notify()
        }
    }
    
    init(_ value:T) {
        self.value = value
    }
    
    private var listners = [String:ComplitionHandler]()
    private func addListner(listenr:NSObject, completion : @escaping ComplitionHandler){
        listners[listenr.description] = completion
    }
    
    func addAndNotify(listner:NSObject, completion : @escaping ComplitionHandler) {
        addListner(listenr: listner, completion: completion)
        notify()
    }
    
    private func notify(){
        listners.forEach({$0.value(value)})
    }
    
    deinit {
        self.listners.removeAll()
    }
}
