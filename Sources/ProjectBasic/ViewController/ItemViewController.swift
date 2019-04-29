//
//  ItemViewController.swift
//  SNKit_TJS
//
//  Created by syk on 2018/5/9.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

open class ItemViewController: ViewController<UIView>, TaskQueueProtocol {
    public let taskQueue: TaskQueue = TaskQueue()
    open override func configInit() {
        super.configInit()
        if #available(iOS 11.0, *) {
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color.viewBackground
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /// ZJaDe: 界面出现后恢复任务
        self.taskQueue.taskResume()
    }
    /// ZJaDe: NavItemViewController 才需要暂停
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        /// ZJaDe: 界面消失后暂停任务
        self.taskQueue.taskSuspend()
    }
    deinit {
        self.taskQueue.cleanAllTasks()
    }
}
