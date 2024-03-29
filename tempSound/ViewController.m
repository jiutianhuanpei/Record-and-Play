//
//  ViewController.m
//  tempSound
//
//  Created by 沈红榜 on 15/6/5.
//  Copyright (c) 2015年 沈红榜. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVAudioRecorderDelegate, AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

//录音存储路径
@property (nonatomic, strong)NSURL *tmpFile;

//录音
@property (nonatomic, strong) AVAudioRecorder *recorder;


//播放
@property (nonatomic, strong) AVAudioPlayer *player;

//录音状态(是否录音)
@property (nonatomic, assign)BOOL isRecoding;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //刚打开的时候录音状态为不录音
    
    self.isRecoding = NO;
    
    //播放按钮不能被点击
    
//    [self.playButton setEnabled:NO];
    
    //播放按钮设置成半透明
    
//    self.playButton.titleLabel.alpha = 0.5;
    
    //创建临时文件来存放录音文件
    
    self.tmpFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"TmpFile"]];
    
    //设置后台播放
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    //判断后台有没有播放
    
    if (session == nil) {
        NSLog(@"Error creating sessing:%@", [sessionError description]);
    } else {
        [session setActive:YES error:nil];
    }

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)startRecord:(id)sender {
    if (!self.isRecoding) {
        
        //将录音状态变为录音
        self.isRecoding = YES;
        
        //将录音按钮变为停止
        [self.recordButton setTitle:@"停止" forState:UIControlStateNormal];
        
        
        //播放按钮不能被点击
        [self.playButton setEnabled:NO];
        self.playButton.titleLabel.alpha = 0.5;
        
        //开始录音,将所获取到得录音存到文件里
        self.recorder = [[AVAudioRecorder alloc] initWithURL:_tmpFile settings:nil error:nil];
        
        //准备记录录音
        [_recorder prepareToRecord];
        
        //启动或者恢复记录的录音文件
        [_recorder record];
        
        _player = nil;
        
    } else {
        //录音状态 点击录音按钮 停止录音
        self.isRecoding = NO;
        [self.recordButton setTitle:@"录音" forState:UIControlStateNormal];
        
        //录音停止的时候,播放按钮可以点击
        [self.playButton setEnabled:YES];
        [self.playButton.titleLabel setAlpha:1];
        
        
        //停止录音
        [_recorder stop];
        _recorder = nil;
        
        //        &nnbsp;
        
        NSError *playError;
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:_tmpFile error:&playError];
        
        //当播放录音为空, 打印错误信息
        if (self.player == nil) {
            NSLog(@"Error crenting player: %@", [playError description]);
            
        }
        self.player.delegate = self;
    }

}

- (IBAction)playRecord:(id)sender {
    if ([self.player isPlaying]) {
        
        //暂停播放
        [_player pause];
        
        //按钮显示为播放
        [self.playButton setTitle:@"播放" forState:UIControlStateNormal];
        
    } else {
        //开始播放
        [_player play];
        
        [self.playButton setTitle:@"暂停" forState:UIControlStateNormal];
    }
}


//当播放结束后调用这个方法

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //按钮标题变为播放
    [self.playButton setTitle:@"播放" forState:UIControlStateNormal];
}



@end
