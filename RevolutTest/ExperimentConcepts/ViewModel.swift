//
//  ViewModel.swift
//  RevolutTest
//
//  Created by Артмеий Шлесберг on 02/01/2019.
//  Copyright © 2019 Shlesberg. All rights reserved.
//

import Foundation

/*
 README:
 
 Here I've tried to create a generic view model concept.
 I've created a protocol and a type erasure.
 But there are stil problems with constructors.
 We can't use generic protocol, because it doesn't know the exact type of the assosiated view.
 We also can't use the erased type, because it loses all the other protocol.
 This is the point where I've came so far, and then decided to drop the generics.
 
 I'm sure there is a way to improve this and finally achieve generic view models, however it requires some time for experiments
*/

protocol ViewModelType {
    
    associatedtype AssociatedView
    
    func associate(view: AssociatedView)
    
    func asViewModel() -> ViewModel<AssociatedView>
    
}

extension ViewModelType {
    func asViewModel() -> ViewModel<AssociatedView> {
        return ViewModel(viewModel: self)
    }
}

class ViewModel<AV>: ViewModelType {
    
    typealias AssociatedView = AV
    
    private var association: (AssociatedView) -> ()
    
    init<VM: ViewModelType>(viewModel: VM) where VM.AssociatedView == AssociatedView{
        self.association = viewModel.associate
    }
    
    func associate(view: AssociatedView) {
        return association(view)
    }
}
