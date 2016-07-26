# CNRefresh
`swift版本的上拉、下拉刷新。`

### 下拉刷新(header)，支持四种模式：
1. Activity；(加载组件)
2. Image；(图片)
3. ImageAnimation；(序列动画)
4. CircleLoading;(转圈动画)


### 同样，上拉刷新(footer)，也支持四种模式：
1. Activity；(加载组件)
2. Image；(图片)
3. ImageAnimation；(序列动画)
4. Button；(按钮模式)

### 同时我们还有文本模式:
1. None；(没有文本，即没有文字提示)
2. Dynamic；(动态文本提示，即文字会随着拖拽来动态变化，如下拉刷新、松开立即刷新、正在加载数据、数据加载完成)
3. Static；(静态文本提示，即文字一直都是一个状态，不会变化，如正在加载中)

所有的模式的`基本UI属性都可以自定义`，包括背景色、高度、间距、文案、图片、序列图片动画、转圈动画的颜色值等；

### 刷新状态
1. Normal;（正常状态）
2. Refreshing;(正在刷新)

`对于，要判断当前是否正在刷新，可以通过此状态来判断。`

### 刷新交互状态
1. Draging;(拖拽中)
2. Release;(释放)
3. Refreshing;(刷新中)
4. EndRefresh;(刷新完成)


### 集成：
下载源文件，集成进工程文件里面；(后续支持pods)

### 使用：(具体参看demo)
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
        
        tableView?.headRefresh { [unowned self] in
            if self.houseListTableView?.refreshStatue == .Refreshing {
                // todo
            }
        }
        
        tableView?.footRefresh { [unowned self] in
            if self.houseListTableView?.refreshStatue == .Refreshing {
                // todo
            }
        }

### 停止刷新
    tableView.endRefresh()
    
### 移除刷新组件
    tableView.removeFootRefresh()
    
`如有问题，欢迎指正。`