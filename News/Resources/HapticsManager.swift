//
//  HapticsManager.swift
//  News
//
//  Created by Elmar Ibrahimli on 29.05.23.
//

import Foundation
import UIKit

final class HapticsManager {
    static let shared = HapticsManager()
    
    func vibrateForSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}
