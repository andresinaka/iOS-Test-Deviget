//
//  PostDetailViewModel.swift
//  Reddit
//
//  Created by Andres Canal on 20/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import Foundation

protocol PostDetailViewModelProtocol {
    var title: Observable<String> { get }
}

final class PostDetailViewModel: PostDetailViewModelProtocol {
    var title: Observable<String> = Observable("")

    deinit {
        print("DEINITED PostDetailViewModel")
    }
}
