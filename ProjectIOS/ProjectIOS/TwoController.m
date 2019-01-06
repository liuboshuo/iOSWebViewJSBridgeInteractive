//
//  TwoController.m
//  ProjectIOS
//
//  Created by ls-mac on 2018/10/5.
//  Copyright © 2018年 ls-mac. All rights reserved.
//

#import "TwoController.h"

@interface TwoController ()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation TwoController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = @"js传过来的base64图片";
	self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 100, 340, 190)];
	self.imageView.contentMode = UIViewContentModeScaleAspectFit;
	[self.view addSubview:self.imageView];
}

-(void)setImage:(UIImage *)image {
	_image = image;
	
	CGFloat width = [UIScreen mainScreen].bounds.size.width;
	CGFloat height = width * ( image.size.height / image.size.width);
	self.imageView.frame = CGRectMake(0, 120, width, height);
	self.imageView.image = image;
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
