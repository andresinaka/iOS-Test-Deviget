//
//  Date.swift
//  Reddit
//
//  Created by Andres Canal on 21/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import Foundation

extension Date {

    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
