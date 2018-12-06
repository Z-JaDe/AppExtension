//
//  AppDefaultImage.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/6/7.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation

public class AppDefaultImage {

    public static var backTemplate: UIImage = {
        return UIImage(named: "AppDefaultImage.bundle/ic_back_template", in: Bundle(for: AppDefaultImage.self), compatibleWith: nil)!
    }()
    public static var cancelTemplate: UIImage = {
        return UIImage(named: "AppDefaultImage.bundle/ic_cancel_template", in: Bundle(for: AppDefaultImage.self), compatibleWith: nil)!
    }()

    public static var accessoryTypeSelected: UIImage = {
        return UIImage(named: "AppDefaultImage.bundle/ic_accessoryType_selected", in: Bundle(for: AppDefaultImage.self), compatibleWith: nil)!
    }()
    public static var accessoryTypeUnselected: UIImage = {
        return UIImage(named: "AppDefaultImage.bundle/ic_accessoryType_unselected", in: Bundle(for: AppDefaultImage.self), compatibleWith: nil)!
    }()

    public static var userDefault: UIImage = {
        return UIImage(named: "AppDefaultImage.bundle/ic_default_userImg", in: Bundle(for: AppDefaultImage.self), compatibleWith: nil)!
    }()
    public static var userFailure: UIImage = {
        return UIImage(named: "AppDefaultImage.bundle/ic_default_userImg", in: Bundle(for: AppDefaultImage.self), compatibleWith: nil)!
    }()
    public static var `default`: UIImage = {
        return UIImage(named: "AppDefaultImage.bundle/ic_default_image", in: Bundle(for: AppDefaultImage.self), compatibleWith: nil)!
    }()
    public static var failure: UIImage = {
        return UIImage(named: "AppDefaultImage.bundle/ic_default_image_failure", in: Bundle(for: AppDefaultImage.self), compatibleWith: nil)!
    }()
}
