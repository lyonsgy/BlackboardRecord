//
//  VideoListViewController.h
//  BlackboardRecord
//
//  Created by lyons on 2018/7/6.
//  Copyright © 2018年 lyons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)backBtnClick:(id)sender;

@end
