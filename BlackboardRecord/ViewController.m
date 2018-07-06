//
//  ViewController.m
//  BlackboardRecord
//
//  Created by lyons on 2018/7/5.
//  Copyright © 2018年 lyons. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ZYSScreenAudioRecorder.h"
#import "LXFRectangleBrush.h"
#import "LXFLineBrush.h"
#import "LXFArrowBrush.h"
#import "LXFTextBrush.h"
#import "LXFMosaicBrush.h"
#import "LXFEraserBrush.h"

@interface ViewController ()<LXFDrawBoardDelegate>
@property (nonatomic, strong) ZYSScreenAudioRecorder *recorder;
/** 描述 */
@property(nonatomic, copy) NSString *desc;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.board.delegate = self;
    
}

#pragma mark - Getters
- (ZYSScreenAudioRecorder *)recorder {
    if (!_recorder) {
        _recorder = [[ZYSScreenAudioRecorder alloc] initWithRecordLayer:self.board.layer];
    }
    
    return _recorder;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - LXFboardDelegate
- (NSString *)LXFDrawBoard:(LXFDrawBoard *)drawBoard textForDescLabel:(UILabel *)descLabel{
    
    //    return [NSString stringWithFormat:@"我的随机数：%d", arc4random_uniform(256)];
    return self.desc;
}

- (void)LXFDrawBoard:(LXFDrawBoard *)drawBoard clickDescLabel:(UILabel *)descLabel{
    descLabel ? self.desc = descLabel.text: nil;
    [self alterboardDescLabel];
}

- (void)alterboardDescLabel {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加描述" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.desc = alertController.textFields.firstObject.text;
        [self.board alterDescLabel];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入";
        textField.text = self.desc;
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)revoke:(id)sender {
    [self.board revoke];
}

- (IBAction)redo:(id)sender {
    [self.board redo];
}

- (IBAction)pencilBrush:(id)sender {
    self.board.brush = [LXFPencilBrush new];
    self.board.style.lineWidth = 2;
}

- (IBAction)arrowBrush:(id)sender {
    self.board.brush = [LXFArrowBrush new];
    self.board.style.lineWidth = 2;
}

- (IBAction)lineBrush:(id)sender {
    self.board.brush = [LXFLineBrush new];
    self.board.style.lineWidth = 2;
}

- (IBAction)textBrush:(id)sender {
    self.board.brush = [LXFTextBrush new];
    self.board.style.lineWidth = 2;
}

- (IBAction)rectangleBrush:(id)sender {
    self.board.brush = [LXFRectangleBrush new];
    self.board.style.lineWidth = 2;
}

- (IBAction)mosaicBrush:(id)sender {
    self.board.brush = [LXFMosaicBrush new];
    self.board.style.lineWidth = 2;
}

- (IBAction)eraserBrush:(id)sender {
    self.board.brush = [LXFEraserBrush new];
    // 调整笔刷大小
    self.board.style.lineWidth = 10;
}

- (IBAction)recordBtnClick:(id)sender {
    if (_recordBtn.selected==true) {
        //录制中（结束）
        _recordBtn.selected = false;
        [_recorder stopRecordingWithHandler:^(NSString *videoPath) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:videoPath]];
                [player.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
                [player.moviePlayer prepareToPlay];
                [player.moviePlayer play];
                [self presentMoviePlayerViewControllerAnimated:player];
                
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
            });
        }];
    }else{
        //未录制（开始）
        _recordBtn.selected = true;
        [self.recorder startRecording];
        [_recorder screenRecording:^(NSTimeInterval duration) {
            NSLog(@"时间: %.2lf", duration);
        }];
    }
}

// movie play finished.
- (void)movieFinishedCallback:(NSNotification *)notifycation{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [self dismissMoviePlayerViewControllerAnimated];
}
@end
