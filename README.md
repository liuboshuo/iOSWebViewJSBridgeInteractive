# js和iOS交互通信之jsbridge篇

## 前言

本篇文章和
[iOS WebView和JS的交互](https://www.jianshu.com/p/3fea43b882eb)都是iOS和js的交互，但是本篇文章是vue和iOS的交互，而且iOS使用的是JSBridge第三方框架实现和vue的交互，通信

### iOS的实现

首先创建一个iOS工程，引入WebViewJavascriptBridge第三方框架，使用pod还是自己手动导入都可以


下面看一下具体实现

创建WKWebview，初始化WebViewJavascriptBridge，设置WebViewJavascriptBridge,WKWebView的代理

```
// 初始化webview
	WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
	// 此处替换你本机的ip
	NSURL *url = [NSURL URLWithString:kHOSTURL];
	webView.navigationDelegate = self;
	webView.UIDelegate = self;
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	[webView loadRequest:request];
	[self.view addSubview:webView];
//	self.webView = webView;
	
	self.view.backgroundColor = [UIColor whiteColor];
	// 开启日志
	[WebViewJavascriptBridge enableLogging];
	
	self.bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
	[self.bridge setWebViewDelegate:self];
```

### 使用方法
iOS调用js的实现
需要WebViewJavascriptBridge使用callHandler调用js注册的方法
`ocCallJS`方法需要在js中注册
```
[self.bridge callHandler:@"ocCallJs" data:@"123" responseCallback:^(id responseData) {
		NSLog(@"responseData=%@",responseData);
	}];

```

js调用iOS的实现
需要iOS注册一个方法以供js回调
`jsCallOc`方法需要通过jsbridge注册
```
[self.bridge registerHandler:@"jsCallOc" handler:^(id data, WVJBResponseCallback responseCallback) {
		//将base64字符串转为NSData
		NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:data options:NSDataBase64DecodingIgnoreUnknownCharacters];
		//将NSData转为UIImage
		UIImage *decodedImage = [UIImage imageWithData: decodeData];
		TwoController *twoCtr = [[TwoController alloc] init];
		twoCtr.view.backgroundColor = [UIColor purpleColor];
		[self.navigationController pushViewController:twoCtr animated:YES];
		twoCtr.image = decodedImage;
		
		if (responseCallback) {
			// 反馈给JS
			responseCallback(@{@"jsCallOc的参数1": @"jsCallOc的参数2"});
		}
	}];
```
### vue的实现

封装一个JSBridge插件

```
/*这段代码是固定的，必须要放到js中*/
function setupWebViewJavascriptBridge(callback) {
    if (window.WebViewJavascriptBridge) {
        return callback(WebViewJavascriptBridge);
    }
    if (window.WVJBCallbacks) {
        return window.WVJBCallbacks.push(callback);
    }
    window.WVJBCallbacks = [callback];
    var WVJBIframe = document.createElement('iframe');
    WVJBIframe.style.display = 'none';
    WVJBIframe.src = 'wvjbscheme://__BRIDGE_LOADED__';
    document.documentElement.appendChild(WVJBIframe);
    setTimeout(function() {
        document.documentElement.removeChild(WVJBIframe)
    }, 0)
}

export default {
    callhandler(name, data, callback) {
        setupWebViewJavascriptBridge(function(bridge) {
            bridge.callHandler(name, data, callback)
        })
    },
    registerhandler(name, callback) {
        setupWebViewJavascriptBridge(function(bridge) {
            bridge.registerHandler(name, function(data, responseCallback) {
                callback(data, responseCallback)
            })
        })
    }
}
```

## 使用方法

js调用iOS

```
this.$bridge.callhandler("jsCallOc",image.replace("data:image/jpeg;base64,",""),(responseData)=>{
          console.log("responseData",responseData);
        })
```

iOS调用js

```
this.$bridge.registerhandler('ocCallJs', (data, responseCallback) => {
        alert(data)
        responseCallback(data)
    });
```

效果

![](http://upload-images.jianshu.io/upload_images/2152694-fa5fe528e4ba1382.gif?imageMogr2/auto-orient/strip)
