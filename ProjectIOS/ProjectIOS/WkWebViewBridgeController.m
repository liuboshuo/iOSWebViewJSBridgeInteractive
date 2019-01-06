//
//  WkWebViewBridgeController.m
//  WebViewInteractiveIOS
//
//  Created by ls-mac on 2018/10/5.
//  Copyright © 2018年 shuoliu. All rights reserved.
//

#import "WkWebViewBridgeController.h"
#import <WebKit/WebKit.h>
#import "WebViewJavascriptBridge.h"
#import "TwoController.h"

@interface WkWebViewBridgeController ()<WKNavigationDelegate,WKUIDelegate>

@property(nonatomic , strong)WebViewJavascriptBridge *bridge;

@end

@implementation WkWebViewBridgeController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	self.title = @"WkWebViewBridgeController";
	
	
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
	
	
	UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
	UIButton *callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[callbackButton setTitle:@"ocCallJs" forState:UIControlStateNormal];
	[callbackButton addTarget:self action:@selector(ocCallJs) forControlEvents:UIControlEventTouchUpInside];
	[self.view insertSubview:callbackButton aboveSubview:webView];
	callbackButton.frame = CGRectMake(10, 110, 100, 35);
	callbackButton.titleLabel.font = font;
	
	
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
	
	
	
}

-(void)ocCallJs
{
	[self.bridge callHandler:@"ocCallJs" data:@"123" responseCallback:^(id responseData) {
		NSLog(@"responseData=%@",responseData);
	}];
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
	// 执行js脚本
	[webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable data, NSError * _Nullable error) {
		self.title = data;
	}];
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
	NSLog(@"%@",error);
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
	[alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		completionHandler();
	}])];
	[self presentViewController:alertController animated:YES completion:nil];
	
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
