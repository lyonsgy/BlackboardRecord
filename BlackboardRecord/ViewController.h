//
//  ViewController.h
//  BlackboardRecord
//
//  Created by lyons on 2018/7/5.
//  Copyright © 2018年 lyons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXFDrawBoard.h"

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet LXFDrawBoard *board;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;

- (IBAction)revoke:(id)sender;
- (IBAction)redo:(id)sender;
- (IBAction)pencilBrush:(id)sender;
- (IBAction)arrowBrush:(id)sender;
- (IBAction)lineBrush:(id)sender;
- (IBAction)textBrush:(id)sender;
- (IBAction)rectangleBrush:(id)sender;
- (IBAction)mosaicBrush:(id)sender;
- (IBAction)eraserBrush:(id)sender;
- (IBAction)recordBtnClick:(id)sender;

@end

