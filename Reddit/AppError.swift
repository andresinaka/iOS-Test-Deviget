//
//  AppError.swift
//  Reddit
//
//  Created by Andres Canal on 20/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import Foundation

enum AppError: Error {
    case url(URLError?)
    case decode
    case unknown(Error?)
    case httpError(Int)
    case generic(String)
    case parseError
}
