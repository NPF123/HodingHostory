//
//  MyAttentionViewController.m
//  LimitFree
//
//  Created by LZXuan on 15-4-15.
//  Copyright (c) 2015年 LZXuan. All rights reserved.
//
//拍照
#import "MyAttentionViewController.h"
#import <AVFoundation/AVFoundation.h>



@interface MyAttentionViewController ()
@property (nonatomic)AVCaptureDevice *device;
@property (nonatomic)AVCaptureDeviceInput *input;
@property (nonatomic)AVCaptureSession *session;
@property (nonatomic)AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic)AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation MyAttentionViewController


- (AVCaptureDevice *)deviceWithPosition:(AVCaptureDevicePosition)position{
    
    NSArray *deviceArr =[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in deviceArr) {
        if (device.position ==position) {
            return device;
        }
    }
    return nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    self.device = [self deviceWithPosition:AVCaptureDevicePositionBack];
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *dict =@{AVVideoCodecKey:AVVideoCodecJPEG};
    [self.stillImageOutput setOutputSettings:dict];
    //初始化session
    self.session = [[AVCaptureSession alloc]init];
    
    //设置session的分辨率
    //self.session.sessionPreset = AVCaptureSessionPreset1920x1080;
    
    if([self.session canAddInput:self.input])
    {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(10, 40, self.view.bounds.size.width - 20, 300);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    
    [self.view.layer addSublayer:self.previewLayer];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(kScreenSize.width/2-40, kScreenSize.height-80, 80, 80);
    
    [button setImage:[[UIImage imageNamed:@"paizhao.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [self.session startRunning];
    
}
-(AVCaptureConnection*)findConnetion
{
    NSArray *connectionArray = self.stillImageOutput.connections;
    for (AVCaptureConnection *conntion in connectionArray) {
        NSArray *inputPortArray = conntion.inputPorts;
        for (AVCaptureInputPort *port in inputPortArray) {
            if([port.mediaType isEqual:AVMediaTypeVideo])
            {
                //如果该port时视频格式的，那么该connection就是我们要找的
                //                findConnection = conntion;
                return conntion;
            }
        }
    }
    return nil;
}

- (void)btnClick:(UIButton *)button{
    
    //    [self.session beginConfiguration];
    //    self.session.sessionPreset = AVCaptureSessionPreset1920x1080;
    //    [self.session commitConfiguration];
    
    AVCaptureConnection *connection = [self findConnetion];
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        NSData *data = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        
        UIImage *image = [UIImage imageWithData:data];
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }];
}

-(void)swipFrontAndBackgournd
{
    NSArray *inputsArray = self.session.inputs;
    for (AVCaptureDeviceInput *input in inputsArray) {
        AVCaptureDevice *device = input.device;
        if ([device hasMediaType:AVMediaTypeVideo]) {
            AVCaptureDevice *newDevice = nil;
            AVCaptureDeviceInput *newInput = nil;
            if (device.position == AVCaptureDevicePositionBack) {
                newDevice = [self deviceWithPosition:AVCaptureDevicePositionFront];
            }else{
                newDevice = [self deviceWithPosition:AVCaptureDevicePositionBack];
            }
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newDevice error:nil];
            
            
            [self.session beginConfiguration];
            [self.session removeInput:input];
            [self.session addInput:newInput];
            [self.session commitConfiguration];
            break;
        }
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = YES;
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
