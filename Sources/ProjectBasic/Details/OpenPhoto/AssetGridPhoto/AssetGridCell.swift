//
//  AssetGridCell.swift
//  ZiWoYou
//
//  Created by Z_JaDe on 2016/12/26.
//  Copyright © 2016年 Z_JaDe. All rights reserved.
//

import Foundation

class AssetGridCell: CollectionModelCell<AssetGridModel> {
    let imageView: ImageView = ImageView()

    override func configInit() {
        super.configInit()
        self.insets = UIEdgeInsets.zero
    }

    var selectedImgView: ImageView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let selectedImgView = self.selectedImgView {
                self.addSubview(selectedImgView)
                selectedImgView.snp.makeConstraints { (maker) in
                    maker.right.bottom.equalToSuperview()
                }
            }
        }
    }
    override func addChildView() {
        super.addChildView()
        self.addSubview(self.imageView)
    }
    override func configLayout() {
        super.configLayout()
        self.imageView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    override func configData(with model: AssetGridModel) {
        model.image.asObservable().subscribeOnNext({[weak self] (image) in
            self?.imageView.image = image
        }).disposed(by: appearDisposeBag)
    }

    override func updateSelectedState(_ isSelected: Bool) {
        if isSelected {
            self.selectedImgView = self.selectedAccessoryTypeImageView
        } else {
            self.selectedImgView = self.unselectedAccessoryTypeImageView
        }
    }
}
