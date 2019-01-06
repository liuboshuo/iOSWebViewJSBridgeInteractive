//
//  ViewController.m
//  ProjectIOS
//
//  Created by ls-mac on 2018/10/2.
//  Copyright © 2018年 ls-mac. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "TwoController.h"
#import "WkWebViewBridgeController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UIButton *wkWebViewBridgeButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 190, 210, 40)];
	wkWebViewBridgeButton.layer.cornerRadius = 5;
	[wkWebViewBridgeButton setTitle:@"wkWebViewBridgeButton" forState:UIControlStateNormal];
	[wkWebViewBridgeButton setBackgroundColor:[UIColor purpleColor]];
	[wkWebViewBridgeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[wkWebViewBridgeButton addTarget:self action:@selector(wkWebViewBridgeClick) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:wkWebViewBridgeButton];
	
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	
	

}

-(void)wkWebViewBridgeClick
{
	WkWebViewBridgeController *wkWebViewBridgeController = [[WkWebViewBridgeController alloc] init];
	[self.navigationController pushViewController:wkWebViewBridgeController animated:YES];
}
@end
