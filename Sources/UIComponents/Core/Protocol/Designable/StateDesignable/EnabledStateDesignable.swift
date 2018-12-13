//
//  EnabledStateDesignable.swift
//  PaiBaoTang
//
//  Created by Z_JaDe on 2017/7/10.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation

public protocol EnabledStateDesignable: class {
    var isEnabled: Bool? {get set}
    /// ZJaDe: 刷新enabld状态 只有当self.isEnabled为空时设置才有效，self.isEnabled不为空时，self.isEnabled有效
    func refreshEnabledState(_ isEnabled: Bool)
    func updateEnabledState(_ isEnabled: Bool)
}
extension EnabledStateDesignable {
    public func refreshEnabledState(_ isEnabled: Bool) {
        var _isEnabled = isEnabled
        if let isEnabled = self.isEnabled {
            _isEnabled = isEnabled
        }
        updateEnabledState(_isEnabled)
    }
}
