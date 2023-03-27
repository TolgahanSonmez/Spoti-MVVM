//
//  Settings.swift
//  Spoti
//
//  Created by Tolgahan Sonmez on 27.02.2023.
//

import Foundation

struct Sections {
    let title : String
    let options : [Option]
}

struct Option {
    let title : String
    let handler : () -> Void
}
