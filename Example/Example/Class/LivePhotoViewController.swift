//
//  LivePhotoViewController.swift
//  Example
//
//  Created by 小豌先生 on 2023/7/6.
//  Copyright © 2023 Shenzhen Hive Box Technology Co.,Ltd. All rights reserved.
//

import UIKit
import Lantern
import Photos
import PhotosUI
import AVFoundation
import Kingfisher

class LivePhotoViewController: BaseCollectionViewController {
    
    override var name: String { "iPhone实况动图加载显示" }
    
    override var remark: String { "举例如何本地加载iPhone实况动图显示" }
    
    override func makeDataSource() -> [ResourceModel] {
        var result: [ResourceModel] = []
        let model = ResourceModel()
        model.livePhotoUrl = "https://iosdata16.s3.us-west-1.amazonaws.com/waves.JPG"
        model.liveMovUrl = "https://iosdata16.s3.us-west-1.amazonaws.com/waves.mov"
        result.append(model)
        return result
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.fc.dequeueReusableCell(BaseCollectionViewCell.self, for: indexPath)
        cell.imageView.image = UIImage.init(contentsOfFile: Bundle.main.path(forResource: "pee", ofType: "HEIC")!)
        cell.livePhotoBadgeImage = PHLivePhotoView.livePhotoBadgeImage(options: .overContent)
        return cell
    }
    
    override func openLantern(with collectionView: UICollectionView, indexPath: IndexPath) {
        let lantern = Lantern()
        lantern.numberOfItems = {[weak self] in
            self?.dataSource.count ?? 0
        }
        // 使用自定义的Cell
        lantern.cellClassAtIndex = { _ in
            LivePhotoImageCell.self
        }
        lantern.reloadCellAtIndex = { context in
            let lanternCell = context.cell as? LivePhotoImageCell
            lanternCell?.imageView.image = UIImage.init(contentsOfFile: Bundle.main.path(forResource: "pee", ofType: "HEIC")!)
            lanternCell?.showLocalLive()
        }
        lantern.transitionAnimator = LanternZoomAnimator(previousView: { index -> UIView? in
            let path = IndexPath(item: index, section: indexPath.section)
            let cell = collectionView.cellForItem(at: path) as? BaseCollectionViewCell
            return cell?.imageView
        })
        lantern.pageIndex = indexPath.item
        lantern.show()
    }
}

class LivePhotoImageCell: LanternImageCell {
    let livePhotoView = PHLivePhotoView()
    var targetSize: CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: imageView.bounds.width * scale, height: imageView.bounds.height * scale)
    }
    override func setup() {
        imageView.isUserInteractionEnabled = true
        contentView = livePhotoView
        super.setup()
    }
    
    func reloadData(placeholder: UIImage?, urlString: String?) {

    }
    
    func showLocalLive() {
        let imageUrl = URL.init(fileURLWithPath: Bundle.main.path(forResource: "pee", ofType: "HEIC")!)
        let vidoUrl = URL.init(fileURLWithPath: Bundle.main.path(forResource: "pee", ofType: "MOV")!)
        PHLivePhoto.request(withResourceFileURLs: [vidoUrl, imageUrl], placeholderImage: nil, targetSize: targetSize, contentMode: .aspectFit, resultHandler: { (livePhoto, info) in
                    guard let livePhoto = livePhoto else {
                        print("Failed to fetch live photo resources")
                        return
                    }
                    self.livePhotoView.livePhoto = livePhoto
                    self.livePhotoView.startPlayback(with: .hint)
                })
    }
}
