//
//  Configurable.swift
//  VendPractice
//
//  Created by Tony Mu on 25/06/21.
//

/// The interface for configure view with a given model
protocol Configurable {
    associatedtype Model
    func configureWithModel(_:Model)
}
