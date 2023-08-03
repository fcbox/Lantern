//
//  HomeViewController.swift
//  Lantern
//
//  Created by JiongXing on 2019/11/11.
//  Copyright © 2021 Shenzhen Hive Box Technology Co.,Ltd All rights reserved.
//

import UIKit
import Lantern

class HomeViewController: UITableViewController {
    
    var dataSource: [[BaseCollectionViewController]] = [[]]
    let section = ["动画转场效果", "网络图片实况图片场景", "视频图片混合", "不同的若干使用场景"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: self.view.bounds, style: .grouped)
        self.title = "Lantern"
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.lightGray
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tableView.fc.registerCell(HomeTableViewCell.self)
        // 授权网络数据访问
        guard let url = URL(string: "http://www.baidu.com") else  {
            return
        }
        LanternLog.low("Request: \(url.absoluteString)")
        URLSession.shared.dataTask(with: url) { (data, resp, _) in
            if let response = resp as? HTTPURLResponse {
                LanternLog.low("Response statusCode: \(response.statusCode)")
            }
        }.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource = [[
            LocalImageViewController(),
            LocalImageZoomViewController(),
            LocalImageSmoothZoomViewController(),
            CustomViewController()],
                      
            [LivePhotoViewController(),
            KingfisherImageViewController(),
            SDWebImageViewController(),
            LongImageViewController(),
            GIFViewController()],
                      
            [VideoPhotoViewController(),
            VerticalBrowseViewController()],
                      
            [StoreTextPageViewController(),
            DataSourceDeleteViewController(),
            DataSourceAppendViewController(),
            PushNextViewController(),
            LoadingProgressViewController(),
            MultipleCellViewController(),
            MultipleSectionViewController(),
            DefaultPageIndicatorViewController(),
            NumberPageIndicatorViewController()]]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return section.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.fc.dequeueReusableCell(HomeTableViewCell.self)
        let vc = dataSource[indexPath.section][indexPath.row]
        cell.textLabel?.text = vc.name
        cell.textLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        cell.detailTextLabel?.text = vc.remark
        cell.detailTextLabel?.font = .systemFont(ofSize: 14, weight: .thin)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: 40))
        let lab = UILabel.init(frame: CGRect.init(x: 20, y: 10, width: self.view.bounds.width, height: 20))
        lab.text = self.section[section]
        lab.font = .systemFont(ofSize: 18, weight: .semibold)
        lab.textColor = .black
        view.addSubview(lab)
        return view
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        navigationController?.pushViewController(dataSource[indexPath.section][indexPath.row], animated: true)
    }
}

class HomeTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
