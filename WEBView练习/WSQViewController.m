//
//  WSQViewController.m
//  WEBView练习
//
//  Created by Shouqiang Wei on 14-5-14.
//  Copyright (c) 2014年 Shouqiang Wei. All rights reserved.
//

#import "WSQViewController.h"
#import "BrowserController.h"


@interface WSQViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtUrl;
@property (weak, nonatomic) IBOutlet UIButton *btnSearchClicked;
- (IBAction)btnSearchClicked:(id)sender;

@end

@implementation WSQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSearchClicked:(id)sender {
    NSURL* url = [NSURL URLWithString:_txtUrl.text];
    BrowserController* b = [BrowserController new];
    b.currenURL = url;
    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:b];
    [self presentViewController:navi animated:YES completion:nil];

}
@end
