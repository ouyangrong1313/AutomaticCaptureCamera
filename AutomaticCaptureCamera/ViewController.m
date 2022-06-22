//
//  ViewController.m
//  AutomaticCaptureCamera
//
//  Created by 欧阳荣 on 2022/6/16.
//

#import "ViewController.h"
#import "OYCameraViewController.h"
#import "SSPublicHeader.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    OYCameraViewController *cameraVC = segue.destinationViewController;
    cameraVC.uploadSuccess = ^(UIImage *img) {
        self.imgView.image = img;
    };
    
}



@end
