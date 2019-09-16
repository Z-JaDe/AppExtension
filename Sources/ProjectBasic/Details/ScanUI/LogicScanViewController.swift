//
//  LogicScanViewController.swift
//  Wallet
//
//  Created by 郑军铎 on 2018/8/27.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import UIKit
import AVFoundation

open class LogicScanViewController: UIViewController {
    public typealias ParseCodeClosureType = (String, @escaping (Bool) -> Void) -> Void
    public var parseCodeClosure: ParseCodeClosureType?
    public var isLight: Bool = false {
        didSet {self.updateLighted(isLight: self.isLight)}
    }

    private var _isReading: Bool = true
    // MARK: -
    var deviceAvailable: Bool {
        self.device != nil
    }
    lazy var device: AVCaptureDevice? = {
        AVCaptureDevice.default(for: AVMediaType.video)
    }()
    lazy var session: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = .high
        return session
    }()
    public private(set) lazy var previewView: UIView = UIView()
    var _previewLayer: AVCaptureVideoPreviewLayer?
    var previewLayer: AVCaptureVideoPreviewLayer {
        if let layer = _previewLayer {
            return layer
        } else {
            let layer = AVCaptureVideoPreviewLayer(session: self.session)
            layer.videoGravity = .resize
            _previewLayer = layer
            return layer
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        addChildView()
        configLayout()
        if self.deviceAvailable {
            self.addScanInputAntOutput()
            self.previewView.layer.insertSublayer(self.previewLayer, at: 0)
            self.previewLayer.frame = self.previewView.bounds
        }
        self.checkCanScan { [weak self] (canUse) in
            if canUse {
                self?.openScanning()
            }
        }
    }
    open func addChildView() {
        self.view.addSubview(self.previewView)
    }
    open func configLayout() {

    }
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.previewView.frame = self.view.bounds
        _previewLayer?.frame = self.previewView.bounds
    }
    // MARK: -
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.deviceAvailable {
            self.openScanning()
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
    let pscope = PermissionScope()
    // MARK: -
    open func openScanning() {
        self._isReading = true
        self.session.startRunning()
    }
    open func stopScanning() {
        self._isReading = false
        self.session.stopRunning()
    }
    /// ZJaDe: 灯泡开关更新
    open func updateLighted(isLight: Bool) {
        jd.torchOpenState = isLight
    }
    /// ZJaDe: 扫描范围
    open func scanViewRect() -> CGRect {
        jd.screenBounds
    }
    /// ZJaDe: 扫描结果处理
    open func parseScanResult(metadataObject: AVMetadataMachineReadableCodeObject, stringValue: String) {
        guard self._isReading == true else { return }
        self.stopScanning()
        logDebug("扫描到\(stringValue)")
        self.parseCode(stringValue)
    }
    func parseCode(_ code: String) {
        self.parseCodeClosure?(code, {(_) in
            self.openScanning()
        })
    }
}
extension LogicScanViewController {
    /// ZJaDe: 闭包可能会被队列或者Alert持有
    public func checkCanScan(_ closure: @escaping (Bool) -> Void) {
        if self.deviceAvailable {
            pscope.requestCamera { (canUse) in
                DispatchQueue.main.async {
                    closure(canUse)
                }
            }
        } else {
            Alert.showPrompt("设备不支持扫描") { (_, _) in
                closure(false)
            }
        }
    }
    func addScanInputAntOutput() {
        guard session.inputs.isEmpty else { return }
        if let device = device, let input = try? AVCaptureDeviceInput(device: device) {
            if session.canAddInput(input) {
                session.addInput(input)
            }
        }
        guard session.outputs.isEmpty else { return }
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.rectOfInterest = self.rectOfInterest(scanViewRect: self.scanViewRect())
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        /// ZJaDe: availableMetadataObjectTypes依赖于input，所以要先把input output添加到session中再做判断
        if output.availableMetadataObjectTypes.isNotEmpty {
            output.metadataObjectTypes = output.availableMetadataObjectTypes//[.qr, .ean13, .ean8, .code128]
        }
    }
    func rectOfInterest(scanViewRect: CGRect) -> CGRect {
        let width = scanViewRect.size.height / self.view.height
        let height = scanViewRect.size.width / self.view.width
        return CGRect(x: (1 - width) / 2, y: (1 - height) / 2, width: width, height: height)
    }
}
// MARK: - 处理扫描结果
extension LogicScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject else { return }
        guard let stringValue = metadataObject.stringValue else { return }
        self.parseScanResult(metadataObject: metadataObject, stringValue: stringValue)
    }
}
