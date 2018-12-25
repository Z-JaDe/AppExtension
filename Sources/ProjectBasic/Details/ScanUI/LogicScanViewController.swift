//
//  LogicScanViewController.swift
//  Wallet
//
//  Created by 郑军铎 on 2018/8/27.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import UIKit
import AVFoundation

open class LogicScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    public typealias ParseCodeClosureType = (String, @escaping (Bool) -> Void) -> Void
    public var parseCodeClosure: ParseCodeClosureType?
    public var isLight: Bool = false {
        didSet {self.updateLighted(isLight: self.isLight)}
    }

    private var _isReading: Bool = true
    // MARK: -
    lazy var device: AVCaptureDevice? = {
        return AVCaptureDevice.default(for: AVMediaType.video)
    }()
    lazy var session: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = .high

        if let device = device, let input = try? AVCaptureDeviceInput(device: device) {
            if session.canAddInput(input) {
                session.addInput(input)
            }
        }
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.rectOfInterest = self.rectOfInterest(scanViewRect: self.scanViewRect())
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        if output.availableMetadataObjectTypes.count > 0 {
            output.metadataObjectTypes = [.qr, .ean13, .ean8, .code128]
        }

        return session
    }()
    open func scanViewRect() -> CGRect {
        return jd.screenBounds
    }
    lazy var preview: AVCaptureVideoPreviewLayer = {
        let preView = AVCaptureVideoPreviewLayer(session: self.session)
        preView.videoGravity = .resize
        preView.frame = self.view.bounds
        return preView
    }()

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.checkCanScan { [weak self] (canUse) in
            guard let `self` = self else {return}
            if canUse {
                self.openScanning()
            } else {
                self.popVC()
            }
        }
    }
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.deviceAvailable {
            self.updateLighted(isLight: self.isLight)
        }

    }
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.deviceAvailable {
            self.stopScanning()
            updateLighted(isLight: false)
        }
    }
    // MARK: -
    var deviceAvailable: Bool {
        return self.device != nil
    }
    let pscope = PermissionScope()
    public func checkCanScan(_ closure: @escaping (Bool) -> Void) {
        if self.deviceAvailable {
            pscope.requestCamera(closure)
        } else {
            Alert.showPrompt("设备不支持扫描") { (_, _) in
                closure(false)
            }
        }
    }
    // MARK: -
    open func openScanning() {
        self._isReading = true
        Async.main {
            self.view.layer.insertSublayer(self.preview, at: 0)
            self.session.startRunning()
        }
    }
    open func stopScanning() {
        self._isReading = false
        Async.main {
            self.session.stopRunning()
        }
    }
    open func updateLighted(isLight: Bool) {
        jd.torchOpenState = isLight
    }
    // MARK: - 处理扫描结果
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {
            return
        }
        guard let stringValue = metadataObject.stringValue else {
            return
        }
        guard self._isReading == true else {
            return
        }
        self.stopScanning()
        logDebug(stringValue)
        self.parseCode(stringValue)

    }
    func parseCode(_ code: String) {
        self.parseCodeClosure?(code, {(_) in
            self.openScanning()
        })
    }
}
extension LogicScanViewController {
    func rectOfInterest(scanViewRect: CGRect) -> CGRect {
        let width = scanViewRect.size.height / self.view.height
        let height = scanViewRect.size.width / self.view.width
        return CGRect(x: (1 - width) / 2, y: (1 - height) / 2, width: width, height: height)
    }
}
