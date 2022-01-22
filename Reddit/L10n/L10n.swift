//
//  L10n.swift
//  Reddit
//
//  Created by Andres Canal on 22/01/2022.
//  Copyright © 2022 Andres Canal. All rights reserved.
//

import Foundation

extension String {

    func localized(args: CVarArg...) -> String {
        let format = Bundle.main.localizedString(forKey: self, value: nil, table: "Localizable")
        return String(format: format, locale: Locale.current, arguments: args)
    }

}
