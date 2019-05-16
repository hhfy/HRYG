//
//  BaseViewController.m
//
//  Created by LTWL on 2017/5/16.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.isPush = NO;
//    [HttpTool cancelRequeset];
    [SVProgressHUD dismiss];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [HttpTool cancelRequeset];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isPush = YES;
    self.view.backgroundColor = SetupColor(242, 242, 242);
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        self.automaticallyAdjustsScrollViewInsets = NO;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkForOnline:) name:NetworkForWWANNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkForOnline:) name:NetworkForWIFINotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkForInterrupt:) name:NetworkForInterruptNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needReloadData) name:NeedReloadDataNotification object:nil];
}

- (NSString *)token {
    @synchronized(self) {
        return [SaveTool objectForKey:Token];
    }
}

- (void)networkForInterrupt:(NSNotification *)note {
    if (self.networkForInterrupt) self.networkForInterrupt();
}

- (void)networkForOnline:(NSNotification *)note {
    if (self.networkForOnline) self.networkForOnline();
}

- (void)needReloadData {
    if (self.reloadData) self.reloadData();
}

- (void)dealloc {
//    [HttpTool cancelRequeset];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
