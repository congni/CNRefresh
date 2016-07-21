//
//  ViewController.swift
//  CNRefreshDemo
//
//  Created by 汪君 on 16/7/19.
//  Copyright © 2016年 quanXiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    /// TableView
    private var houseListTableView: UITableView?
    private var tableDataArray: Array<Int> = []
    private var currentHeadPage = 1
    private var currentFootPage = 1
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        addUITableView()
        reloadTableView(radom())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
     添加TableView
     */
    private func addUITableView() {
        self.houseListTableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height), style: .Plain)
        houseListTableView?.dataSource = self
        houseListTableView?.delegate = self
        houseListTableView?.backgroundColor = UIColor.clearColor()
        houseListTableView?.separatorColor = UIColor.clearColor()
        houseListTableView?.reloadData()
        self.view.addSubview(houseListTableView!)
        
        /**
        *  顶部刷新模式设置，目前支持四种模式: Activity,图片,序列动画,转圈动画
        */
        houseListTableView?.headRefreshStyle = .CircleLoading
        /**
        *  底部刷新模式设置，目前支持四种模式: Activity,图片,序列动画,按钮模式
        */
        houseListTableView?.footRefreshStyle = .Button
        /**
        *  以上模式，都支持单独文本模式设置，文本模式是指，在上面四种模式中是否支持文字显示，以及显示怎样的文字，三种模式：不显示文字，显示动态文字(即跟着拖拽的事件会自动更改文字文案(文字文案可以设置))，显示静态文字(文字一旦设置，不再改变(同样，文案可以设置))
        */
        houseListTableView?.headRefreshTipLabelStyle = .None
        /**
        *  文案设置，CNRefreshProfile里面的文案，都可以通过这种方式来设置
        */
        CNRefreshProfile.footButtonStyleTitle = "底部按钮加载"
        
        
        houseListTableView?.headRefresh { [unowned self] in
            if self.houseListTableView?.refreshStatue == .Refreshing {
                GCDUtils.delay(3.0, task: { () -> () in
                    self.reloadTableView(self.radom())
                    self.currentHeadPage = self.currentHeadPage + 1
                })
            }
        }
        
        houseListTableView?.footRefresh { [unowned self] in
            if self.houseListTableView?.refreshStatue == .Refreshing {
                GCDUtils.delay(3.0, task: { () -> () in
                    self.reloadTableView(self.radom())
                    self.currentFootPage = self.currentFootPage + 1
                })
            }
        }
    }
    
    private func radom() -> Array<Int> {
        let count: Int = Int(arc4random() % 50)
        var index: Int = 1
        
        var array: Array<Int> = []
        
        while index < count {
            array.append(index)
            
            index = index + 1
        }
        
        return array
    }
}



// MARK: - 对外提供更新tableView数据源的接口
extension ViewController {
    /**
     数据接口，刷新tableView
     - parameter dataList: 数据
     */
    internal func reloadTableView(dataList: Array<Int>) {
        tableDataArray = dataList
        dispatch_async(dispatch_get_main_queue(), {
            self.houseListTableView?.reloadData()
            if self.houseListTableView?.refreshStatue == .Refreshing {
                
                if self.currentFootPage > 2 {
                    self.houseListTableView?.removeFootRefresh()
                } else {
                    self.houseListTableView?.endRefresh()
                }
                
                
                if self.currentHeadPage > 2 {
                    self.houseListTableView?.removeHeaderRefresh()
                } else {
                    self.houseListTableView?.endRefresh()
                }
            }
        })
    }
}


// MARK: - TableView delegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellReuseIdentifier = "test"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellReuseIdentifier)
            cell?.selectionStyle = .None
        }
        
        let dataInt = tableDataArray[indexPath.row]
        cell?.textLabel?.text = "\(dataInt)"
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
}


