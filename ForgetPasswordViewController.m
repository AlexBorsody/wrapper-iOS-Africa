//
//  ForgetPasswordViewController.m
//  JUICEGURU
//
//  Created by user on 29/07/14.
//  Copyright (c) 2014 Digipowers. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "LoginViewController.h"

@interface ForgetPasswordViewController ()

@end

@implementation ForgetPasswordViewController
NSUserDefaults *userDefault;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
      [_sendBT.layer setCornerRadius:4.0f];
    userDefault = [NSUserDefaults standardUserDefaults];
    NSString *email = [userDefault objectForKey:@"email"];
    _emailET.text = email;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)ForgotPass{
    //////////////////////////////////////////////
    NSString *URL = @"http://live-sw-africa.pantheon.io/forget_password/";
    NSString *PostURL = [URL stringByAppendingString:_emailET.text];
    NSURL *theURL = [NSURL URLWithString:PostURL];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    [theRequest setHTTPMethod:@"GET"];
   
    
    [NSURLConnection sendAsynchronousRequest:theRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        // if(data != nil){
        NSString *noti = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"response:: %@", noti);
        if(data!=nil){
            if([noti  isEqual: @" "]){
                NSLog(@"response:: %@", noti);

            }else if([noti  isEqual: @"Wrong Username!"]){
                NSLog(@"response:: %@", noti);
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Please enter correct details" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                alertView.tag = 100;
                [alertView show];
            }else{
                NSLog(@"response:: %@", noti);
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Email sent, Please reset your password" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                alertView.tag = 100;
                [alertView show];
            }
            
        }else{
            // [self _showAlert2:@"Por favor,conectarse a Internet"];
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (IBAction)send:(id)sender {
    if(_emailET.text.length > 2){
    [self ForgotPass];
    }
}

- (IBAction)back:(id)sender {
    LoginViewController *viewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
