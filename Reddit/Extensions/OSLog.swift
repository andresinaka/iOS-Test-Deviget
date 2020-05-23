//
//  OSLog.swift
//  Reddit
//
//  Created by Andres Canal on 23/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import Foundation
import os.log

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier ?? "Missing Bundle Identifier"

    static let viewModel = OSLog(subsystem: subsystem, category: "viewModel")
}
