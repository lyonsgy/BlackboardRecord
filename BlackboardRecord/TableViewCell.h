//
//  TableViewCell.h
//  BlackboardRecord
//
//  Created by lyons on 2018/7/6.
//  Copyright © 2018年 lyons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoSizeLabel;

@end
