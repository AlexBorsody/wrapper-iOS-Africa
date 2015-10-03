//
//  LoginViewController.h
//  JUICEGURU
//
//  Created by user on 23/07/14.
//  Copyright (c) 2014 Digipowers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBAudienceNetwork/FBAudienceNetwork.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailET;
@property (weak, nonatomic) IBOutlet UITextField *passwordET;
- (IBAction)loginBT:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UILabel *forgotPassword;
@property (weak, nonatomic) IBOutlet UILabel *loginError;
@property (weak, nonatomic) IBOutlet UIButton *signUp;
- (IBAction)signUPTouch:(id)sender;
- (IBAction)signInFacebook:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *signInWithoutFB;
- (IBAction)signInWithoutFB:(id)sender;

@end
