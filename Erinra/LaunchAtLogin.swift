//
//  LaunchAtLogin.swift
//  Erinra
//
//  Created by Peter Hedlund on 9/17/23.
//

import Foundation
import ServiceManagement

@Observable
class LaunchAtLogin {
    
    var isEnabled: Bool {
        get {
            access(keyPath: \.isEnabled)
            _isEnabled = SMAppService.mainApp.status == .enabled
            return _isEnabled
        }
        set {
            withMutation(keyPath: \.isEnabled) {
                _isEnabled = newValue
                do {
                    if newValue {
                        if SMAppService.mainApp.status == .enabled {
                            try? SMAppService.mainApp.unregister()
                        }

                        try SMAppService.mainApp.register()
                    } else {
                        try SMAppService.mainApp.unregister()
                    }
                } catch {
                    print("Failed to \(newValue ? "enable" : "disable") launch at login: \(error.localizedDescription)")
                }
            }
        }
    }

    @ObservationIgnored private var _isEnabled: Bool = false
}

