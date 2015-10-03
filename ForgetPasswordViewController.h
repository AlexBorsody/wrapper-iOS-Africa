//
//  ForgetPasswordViewController.h
//  JUICEGURU
//
//  Created by user on 29/07/14.
//  Copyright (c) 2014 Digipowers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPasswordViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *sendBT;
@property (weak, nonatomic) IBOutlet UITextField *emailET;
- (IBAction)send:(id)sender;
- (IBAction)back:(id)sender;

@end
