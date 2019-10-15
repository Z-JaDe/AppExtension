//
//  RxProgress.swift
//  AppExtension
//
//  Created by ZJaDe on 2019/1/3.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
extension Reactive where Base: Request {
    public func progress() -> Observable<RxProgress> {
        Observable.create { observer in
            let handler: Request.ProgressHandler = { progress in
                let rxProgress = RxProgress(bytesWritten: progress.completedUnitCount,
                                            totalBytes: progress.totalUnitCount)
                observer.on(.next(rxProgress))

                if rxProgress.bytesWritten >= rxProgress.totalBytes {
                    observer.on(.completed)
                }
            }
            switch self.base {
            case let uploadReq as UploadRequest:
                uploadReq.uploadProgress(closure: handler)
            case let downloadReq as DownloadRequest:
                downloadReq.downloadProgress(closure: handler)
            case let dataReq as DataRequest:
                dataReq.downloadProgress(closure: handler)
            default: break
            }

            return Disposables.create()
        }
            // warm up a bit :)
            .startWith(RxProgress(bytesWritten: 0, totalBytes: 0))
    }
}

// MARK: RxProgress
public struct RxProgress {
    public let bytesWritten: Int64
    public let totalBytes: Int64

    public init(bytesWritten: Int64, totalBytes: Int64) {
        self.bytesWritten = bytesWritten
        self.totalBytes = totalBytes
    }
}

extension RxProgress {
    public var bytesRemaining: Int64 {
        totalBytes - bytesWritten
    }
    public var completed: Float {
        if totalBytes > 0 {
            return Float(bytesWritten) / Float(totalBytes)
        } else {
            return 0
        }
    }
}

extension RxProgress: Equatable {}

public func == (lhs: RxProgress, rhs: RxProgress) -> Bool {
    return lhs.bytesWritten == rhs.bytesWritten &&
        lhs.totalBytes == rhs.totalBytes
}
