//
//  Date.swift
//  CleverOwl
//
//  Created by user228347 on 7/8/24.
//

import Foundation
func daysUntilDate(_ date: Date) -> Int? {
    let calendar = Calendar.current
    let now = Date()
    let components = calendar.dateComponents([.day], from: now, to: date)
    return components.day
}
