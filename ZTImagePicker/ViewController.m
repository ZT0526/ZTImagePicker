//
//  ViewController.m
//  ZTImagePicker
//
//  Created by ZT0526 on 2017/5/13.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "ViewController.h"
#import "ZTImagePickerController.h"
#import "ZTImagePickerOverLayView.h"
#import "XBWaterMarkCameraHandler.h"
#import "UIImage+FWAddition.h"

@interface ViewController ()<UIImagePickerControllerDelegate>

@property (nonatomic, strong) ZTImagePickerController *imagePicker;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)buttonAction:(id)sender {
    
//    self.imagePicker = [[ZTImagePickerController alloc] init];
//    
//    
//    [self presentViewController:self.imagePicker animated:YES completion:nil];
    
    
    [[XBWaterMarkCameraHandler sharedHandler] showCameraPickerInController:self finishBlock:^(UIImage *originImage, ZTLocationModel *placemark, NSUInteger index,XBWaterMark markType, NSString *xmType) {
        //            [[originImage markedImageWithDate:[NSDate fixedDate] user:[FWUser currentUser].username type:@"" placemark:placemark withPhone:[FWUser currentUser].cellphone] saveImageToAlarmPhotoAlbum];
        [[originImage markedImageWithType:markType date:[NSDate date] user:@"hhh" placLocation:placemark withPhone:nil xmType:xmType] saveImageToAlarmPhotoAlbum];
    }];

}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"asd");
}



@end
