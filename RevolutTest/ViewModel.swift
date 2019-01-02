//
//  ViewModel.swift
//  RevolutTest
//
//  Created by Артмеий Шлесберг on 02/01/2019.
//  Copyright © 2019 Shlesberg. All rights reserved.
//

import Foundation

//TODO: write readme about these concepts

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
