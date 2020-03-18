//
//  ViewController.m
//  AspectsDemo
//
//  Created by ShanYuQin on 2020/3/18.
//  Copyright © 2020 ShanYuQin. All rights reserved.
//

#import "ViewController.h"
#import "Aspects.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)buttonPressed:(id)sender {
    UIViewController *testController = [[UIImagePickerController alloc] init];

    testController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:testController animated:YES completion:NULL];


    [testController aspect_hookSelector:@selector(viewWillDisappear:) withOptions:0 usingBlock:^(id<AspectInfo> info, BOOL animated) {
        NSLog(@"UIImagePickerController即将调用viewWillDisappear");
        UIViewController *controller = [info instance];
        if (controller.isBeingDismissed || controller.isMovingFromParentViewController) {
            
            UIWindow* window = nil;
            if (@available(iOS 13.0, *)) {
                for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
                    if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                        window = windowScene.windows.firstObject;
                        break;
                    }
                }
            }else{
                window = [UIApplication sharedApplication].keyWindow;
            }
            
            UIViewController *vc = window.rootViewController;

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Popped" message:@"Hello from Aspects" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ac1 = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"取消");
            }];
            [alert addAction:ac1];
            [vc presentViewController:alert animated:YES completion:nil];
        }
    } error:NULL];

    
    [testController aspect_hookSelector:NSSelectorFromString(@"dealloc") withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> info) {
        NSLog(@"UIImagePickerController控制器即将被销毁 %@", [info instance]);
    } error:NULL];
}



@end
