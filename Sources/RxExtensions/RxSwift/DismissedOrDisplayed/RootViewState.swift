//
//  RootViewState.swift
//  ZiWoYou
//
//  Created by Z_JaDe on 16/9/27.
//  Copyright © 2016 Z_JaDe. All rights reserved.
//

import UIKit

public enum RootViewState {
    case viewNoLoad
    case viewDidLoad
    case viewWillAppear
    case viewDidAppear
    case viewWillDisappear
    case viewDidDisappear

    public var isLoad: Bool {
        switch self {
        case .viewNoLoad:
            return false
        default:
            return true
        }
    }

    public var isAppear: Bool {
        switch self {
        case .viewWillAppear, .viewDidAppear:
            return true
        default:
            return false
        }
    }
    public var isDidAppear: Bool {
        switch self {
        case .viewDidAppear:
            return true
        default:
            return false
        }
    }
    public var isDisappear: Bool {
        switch self {
        case .viewWillDisappear, .viewDidDisappear:
            return true
        default:
            return false
        }
    }
    public var isDidDisappear: Bool {
        switch self {
        case .viewDidDisappear:
            return true
        default:
            return false
        }
    }
}
