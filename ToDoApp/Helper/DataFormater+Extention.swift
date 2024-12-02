//
//  DataFormater+Extention.swift
//  ToDoApp
//
//  Created by Irina Deeva on 02/12/24.
//

import Foundation

extension DateFormatter {
    static let mediumDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}
