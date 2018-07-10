//
//  VideoListViewController.m
//  BlackboardRecord
//
//  Created by lyons on 2018/7/6.
//  Copyright © 2018年 lyons. All rights reserved.
//

#import "VideoListViewController.h"
#import "LocalDataManager.h"
#import "TableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ZFPlayer.h"
#import "VideoPlayerViewController.h"

@interface VideoListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) NSMutableArray *dataArray;
@end

@implementation VideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSArray *filename = [self getFilenamelistOfType:@"mp4" fromDirPath:docPath];
    _dataArray = [NSMutableArray arrayWithArray:filename];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"RecipeCell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSString *name = _dataArray[indexPath.row];
    cell.videoNameLabel.text = name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = _dataArray[indexPath.row];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    VideoPlayerViewController *vc = [VideoPlayerViewController new];
//    vc.url = [NSString stringWithFormat:@"%@/%@",docPath,name];
//    [self presentViewController:vc animated:true completion:^{
//
//    }];
    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",docPath,name]]];
    [player.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
    [player.moviePlayer prepareToPlay];
    [player.moviePlayer play];
    [self presentMoviePlayerViewControllerAnimated:player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (IBAction)backBtnClick:(id)sender{
    [self dismissViewControllerAnimated:true completion:^{}];
}

- (void)movieFinishedCallback:(NSNotification *)notifycation{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [self dismissMoviePlayerViewControllerAnimated];
}

- (NSArray *)getFilenamelistOfType:(NSString *)type fromDirPath:(NSString *)dirPath
{
    NSMutableArray *filenamelist = [NSMutableArray arrayWithCapacity:10];
    NSArray *tmplist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil];
    for (NSString *filename in tmplist) {
        NSString *fullpath = [dirPath stringByAppendingPathComponent:filename];
        if ([self isFileExistAtPath:fullpath]) {
            if ([[filename pathExtension] isEqualToString:type]) {
                [filenamelist  addObject:filename];
            }
        }
    }
    return filenamelist;
}

- (BOOL)isFileExistAtPath:(NSString*)fileFullPath {
    BOOL isExist = NO;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath];
    return isExist;
}

@end
