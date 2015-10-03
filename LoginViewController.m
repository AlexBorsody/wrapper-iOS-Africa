//
//  LoginViewController.m
//  JUICEGURU
//
//  Created by user on 23/07/14.
//  Copyright (c) 2014 Digipowers. All rights reserved.
//

#import "LoginViewController.h"
#import "WebsiteViewController.h"
#import "ForgetPasswordViewController.h"
#import "SignUpViewController.h"
#import "SVProgressHUD.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
NSUserDefaults *userDefault;
NSString *email,*pass;

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
    
    _emailET.layer.borderWidth = 1;
    _emailET.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _passwordET.layer.borderWidth = 1;
    _passwordET.layer.borderColor = [[UIColor lightGrayColor] CGColor];
     userDefault = [NSUserDefaults standardUserDefaults];
   // [_login.layer setCornerRadius:4.0f];
    _login.layer.borderWidth = 1;
    _login.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _forgotPassword.layer.borderWidth = 1;
    _forgotPassword.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _signUp.layer.borderWidth = 1;
    _signUp.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _signInWithoutFB.layer.borderWidth = 1;
    _signInWithoutFB.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    UITapGestureRecognizer *gestureForgot = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Forgot:)];
    _forgotPassword.userInteractionEnabled = YES;
    [_forgotPassword addGestureRecognizer:gestureForgot];
   
    // Do any additional setup after loading the view from its nib.
    
    NSString *loginWithoutCheck = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginWithoutFacebook"];
    if ([loginWithoutCheck isEqual:@"1"]) {
        _signInWithoutFB.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)Login{
    //////////////////////////////////////////////
    NSString *URL = @"http://live-sw-africa.pantheon.io/is_valid";
    NSURL *theURL = [NSURL URLWithString:URL];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setValue:@"MEDTELAPP2013" forHTTPHeaderField:@"X_MEDTELAPP_KEY"];
    
    NSString *authuser = @"username=";
    NSString *authpass = @"&pass=";
    NSString *concatenate1 = [authuser stringByAppendingString:email];
    NSString *concatenate2 = [authpass stringByAppendingString:pass];
    NSString *Post = [concatenate1 stringByAppendingString:concatenate2];
    
    NSLog(@"UDID:: %@", Post);
    //NSString *post = [URL stringByAppendingString:stringWithoutSpaces];
    NSData *postData = [Post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    [theRequest setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:theRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        // if(data != nil){
        NSString *noti = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSString *newStr = [noti substringWithRange:NSMakeRange(0, [noti length]-4)];
        NSLog(@"trimmedString:: %@", noti);
        if(data!=nil){
            if([noti  isEqual: @"0"]){
                _loginError.hidden = NO;
            }else{
                _loginError.hidden = YES;
                [userDefault setValue:noti forKey:@"website"];
                [userDefault setValue:_emailET.text forKey:@"email"];
                [userDefault setValue:_passwordET.text forKey:@"password"];
                [userDefault setValue:@"1" forKey:@"login"];
                [userDefault synchronize];
                WebsiteViewController *viewController = [[WebsiteViewController alloc] initWithNibName:@"WebsiteViewController" bundle:nil];
                [self.navigationController pushViewController:viewController animated:YES];
            }
           
        }else{
            // [self _showAlert2:@"Por favor,conectarse a Internet"];
            _loginError.text = @"No internet connection";
            _loginError.hidden = NO;
        }
    }];
}


- (void)Forgot:(UITapGestureRecognizer *)recognizer {
    
    [userDefault setValue:_emailET.text forKey:@"email"];
    [userDefault synchronize];
    
    ForgetPasswordViewController *viewController = [[ForgetPasswordViewController alloc] initWithNibName:@"ForgetPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
    
    if([textField isEqual:_emailET]){
    _emailET.placeholder = nil;
         _loginError.hidden = YES;
    }
    
    if([textField isEqual:_passwordET]){
        _passwordET.placeholder = nil;
         _loginError.hidden = YES;
    }
   
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if([textField isEqual:_emailET]){
        _emailET.placeholder = @"Email";

    }
    
    if([textField isEqual:_passwordET]){
        _passwordET.placeholder = @"Password";
    }
    
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


- (IBAction)loginBT:(id)sender {
     email = _emailET.text;
     pass = _passwordET.text;
    if(_emailET.text.length == 0){
         _emailET.layer.borderColor = [UIColor redColor].CGColor;
        UIColor *color = [UIColor redColor];
        _emailET.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
        _passwordET.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
    } else if (_passwordET.text.length == 0){
        _emailET.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _passwordET.layer.borderColor = [UIColor redColor].CGColor;
         UIColor *color = [UIColor redColor];
        _passwordET.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    }else{
        _emailET.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _passwordET.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self Login];
    }
}

- (IBAction)signUPTouch:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"How do you want to Register?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"SignUp with Facebook", @"SignUp with Email", nil];
    actionSheet.tag = 100;
    [actionSheet showInView:self.view];
    
//    SignUpViewController *viewcontroller = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
//    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)signInFacebook:(id)sender {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error
        } else if (result.isCancelled) {
            // Handle cancellations
            NSLog(@"Response:: %@", @"Hello");
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if ([result.grantedPermissions containsObject:@"email"]) {
                // Do work
                [SVProgressHUD showWithStatus:@"Signing In" maskType:SVProgressHUDMaskTypeBlack];
                NSLog(@"Response:: %@", @"Hello");
                NSLog(@"Granted all permission");
                if ([FBSDKAccessToken currentAccessToken])
                {
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result2, NSError *error)
                     {
                         if (!error)
                         {
                             NSLog(@"%@",result2);
                             
                             //NSString *emailID = [[result2 objectForKey:@"name"] stringByAppendingString:@"@gmail.com"];
                             //NSString *emailIDFinal = [emailID stringByReplacingOccurrencesOfString:@" " withString:@""];
                             
                             NSString *userName = [result2 objectForKey:@"name"];
                             NSString *userNameSend = [userName stringByReplacingOccurrencesOfString:@" " withString:@""];
                             
                             //////////////////////////////////////////////
                             NSString *URL = @"http://live-sw-africa.pantheon.io/is_valid";
                             NSURL *theURL = [NSURL URLWithString:URL];
                             NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
                             [theRequest setHTTPMethod:@"POST"];
                             [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                             [theRequest setValue:@"MEDTELAPP2013" forHTTPHeaderField:@"X_MEDTELAPP_KEY"];
                             
                             NSString *authuser = @"username=";
                             NSString *authpass = @"&pass=";
                             NSString *concatenate1 = [authuser stringByAppendingString:[result2 objectForKey:@"id"]];
                             NSString *concatenate2 = [authpass stringByAppendingString:[result2 objectForKey:@"id"]];
                             NSString *Post = [concatenate1 stringByAppendingString:concatenate2];
                             
                             NSLog(@"UDID:: %@", Post);
                             //NSString *post = [URL stringByAppendingString:stringWithoutSpaces];
                             NSData *postData = [Post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                             [theRequest setHTTPBody:postData];
                             
                             [NSURLConnection sendAsynchronousRequest:theRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                 // if(data != nil){
                                 NSString *noti = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                 //NSString *newStr = [noti substringWithRange:NSMakeRange(0, [noti length]-4)];
                                 NSLog(@"trimmedString:: %@", noti);
                                 if(data!=nil){
                                     if([noti  isEqual: @"0"]){
                                         _loginError.hidden = NO;
                                     }else{
                                         _loginError.hidden = YES;
                                         [userDefault setValue:noti forKey:@"website"];
                                         [userDefault setValue:userNameSend forKey:@"email"];
                                         [userDefault setValue:[result2 objectForKey:@"id"] forKey:@"password"];
                                         [userDefault setValue:@"1" forKey:@"login"];
                                         [userDefault synchronize];
                                         WebsiteViewController *viewController = [[WebsiteViewController alloc] initWithNibName:@"WebsiteViewController" bundle:nil];
                                         [self.navigationController pushViewController:viewController animated:YES];
                                     }
                                     
                                     FBSDKLoginManager *loginmanager= [[FBSDKLoginManager alloc]init];
                                     [loginmanager logOut];
                                     
                                     [SVProgressHUD dismiss];
                                 }else{
                                     // [self _showAlert2:@"Por favor,conectarse a Internet"];
                                     _loginError.text = @"No internet connection";
                                     _loginError.hidden = NO;
                                     [SVProgressHUD dismiss];
                                 }
                             }];
                             
                         }
                     }];
                    
                } else
                {
                    NSLog(@"Not granted");
                }
                
                NSLog(@"Response:: %@", result.grantedPermissions);
                [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
            }
        }
    }];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
        
        NSLog(@"The Normal action sheet.");
        NSLog(@"Index = %ld - Title = %@", (long)buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
        if (buttonIndex == 0) {
            FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
            [login logInWithReadPermissions:@[@"email",@"public_profile"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                if (error) {
                    // Process error
                } else if (result.isCancelled) {
                    // Handle cancellations
                    NSLog(@"Response:: %@", @"Hello");
                } else {
                    // If you ask for multiple permissions at once, you
                    // should check if specific permissions missing
                    if ([result.grantedPermissions containsObject:@"email"]) {
                        // Do work
                        NSLog(@"Response:: %@", @"Hello");
                        NSLog(@"Granted all permission");
                        [SVProgressHUD showWithStatus:@"Signing Up" maskType:SVProgressHUDMaskTypeBlack];
                        
                        if ([FBSDKAccessToken currentAccessToken])
                        {
                            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result2, NSError *error)
                             {
                                 if (!error)
                                 {
                                     NSLog(@"%@",result2);
                                     
                                     //////////////////////////////////////////////
                                     
                                     NSString *emailID = [[result2 objectForKey:@"name"] stringByAppendingString:@"@gmail.com"];
                                     NSString *emailIDFinal = [emailID stringByReplacingOccurrencesOfString:@" " withString:@""];
                                     
                                     NSString *userName = [result2 objectForKey:@"name"];
                                     NSString *userNameSend = [userName stringByReplacingOccurrencesOfString:@" " withString:@""];
                                     
                                     NSString *URL = @"http://live-sw-africa.pantheon.io/user_registration?username=";
                                     NSString *concatenate1 = [URL stringByAppendingString:[result2 objectForKey:@"id"]];
                                     NSString *concatenate2 = [concatenate1 stringByAppendingString:@"&pass="];
                                     NSString *concatenate3 = [concatenate2 stringByAppendingString:[result2 objectForKey:@"id"]];
                                     NSString *concatenate4 = [concatenate3 stringByAppendingString:@"&email="];
                                     NSString *concatenate5 = [concatenate4 stringByAppendingString:emailIDFinal];
                                     NSString *concatenate6 = [concatenate5 stringByAppendingString:@"&age="];
                                     NSString *concatenate7 = [concatenate6 stringByAppendingString:@"18to60"];
                                     
                                     NSString *newString = [concatenate7 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                     
                                     NSURL *theURL = [NSURL URLWithString:newString];
                                     NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
                                     [theRequest setHTTPMethod:@"GET"];
                                     
                                     [NSURLConnection sendAsynchronousRequest:theRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                         if(data != nil){
                                             NSString *noti = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                             //NSString *newStr = [noti substringWithRange:NSMakeRange(0, [noti length]-4)];
                                             NSLog(@"trimmedString:: %@", noti);
                                             if (noti.length > 0) {
                                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                                                 message:@"User registered successfully!!"
                                                                                                delegate:self
                                                                                       cancelButtonTitle:@"OK"
                                                                                       otherButtonTitles:nil];
                                                 [alert show];
                                                 
                                                 [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"loginWithoutFacebook"];
                                                 [[NSUserDefaults standardUserDefaults] synchronize];
                                                 _signInWithoutFB.hidden = YES;
                                                 
                                                 NSString *userName = [result2 objectForKey:@"name"];
                                                 NSString *userNameSend = [userName stringByReplacingOccurrencesOfString:@" " withString:@""];
                                                 
                                                 //////////////////////////////////////////////
                                                 NSString *URL = @"http://live-sw-africa.pantheon.io/is_valid";
                                                 NSURL *theURL = [NSURL URLWithString:URL];
                                                 NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
                                                 [theRequest setHTTPMethod:@"POST"];
                                                 [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                                                 [theRequest setValue:@"MEDTELAPP2013" forHTTPHeaderField:@"X_MEDTELAPP_KEY"];
                                                 
                                                 NSString *authuser = @"username=";
                                                 NSString *authpass = @"&pass=";
                                                 NSString *concatenate1 = [authuser stringByAppendingString:[result2 objectForKey:@"id"]];
                                                 NSString *concatenate2 = [authpass stringByAppendingString:[result2 objectForKey:@"id"]];
                                                 NSString *Post = [concatenate1 stringByAppendingString:concatenate2];
                                                 
                                                 NSLog(@"UDID:: %@", Post);
                                                 //NSString *post = [URL stringByAppendingString:stringWithoutSpaces];
                                                 NSData *postData = [Post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                                                 [theRequest setHTTPBody:postData];
                                                 
                                                 [NSURLConnection sendAsynchronousRequest:theRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                                     // if(data != nil){
                                                     NSString *noti = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                     //NSString *newStr = [noti substringWithRange:NSMakeRange(0, [noti length]-4)];
                                                     NSLog(@"trimmedString:: %@", noti);
                                                     if(data!=nil){
                                                         if([noti  isEqual: @"0"]){
                                                             _loginError.hidden = NO;
                                                         }else{
                                                             _loginError.hidden = YES;
                                                             [userDefault setValue:noti forKey:@"website"];
                                                             [userDefault setValue:userNameSend forKey:@"email"];
                                                             [userDefault setValue:[result2 objectForKey:@"id"] forKey:@"password"];
                                                             [userDefault setValue:@"1" forKey:@"login"];
                                                             [userDefault synchronize];
                                                             WebsiteViewController *viewController = [[WebsiteViewController alloc] initWithNibName:@"WebsiteViewController" bundle:nil];
                                                             [self.navigationController pushViewController:viewController animated:YES];
                                                         }
                                                         
                                                         FBSDKLoginManager *loginmanager= [[FBSDKLoginManager alloc]init];
                                                         [loginmanager logOut];
                                                         
                                                         [SVProgressHUD dismiss];
                                                     }else{
                                                         // [self _showAlert2:@"Por favor,conectarse a Internet"];
                                                         _loginError.text = @"No internet connection";
                                                         _loginError.hidden = NO;
                                                         [SVProgressHUD dismiss];
                                                     }
                                                 }];
                                                 
                                             }else{
                                                 
                                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                                                 message:@"User already registered!!"
                                                                                                delegate:self
                                                                                       cancelButtonTitle:@"OK"
                                                                                       otherButtonTitles:nil];
                                                 [alert show];
                                                 
                                                 [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"loginWithoutFacebook"];
                                                 [[NSUserDefaults standardUserDefaults] synchronize];
                                                 _signInWithoutFB.hidden = YES;
                                                 
                                                 NSString *userName = [result2 objectForKey:@"name"];
                                                 NSString *userNameSend = [userName stringByReplacingOccurrencesOfString:@" " withString:@""];
                                                 
                                                 //////////////////////////////////////////////
                                                 NSString *URL = @"http://live-sw-africa.pantheon.io/is_valid";
                                                 NSURL *theURL = [NSURL URLWithString:URL];
                                                 NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
                                                 [theRequest setHTTPMethod:@"POST"];
                                                 [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                                                 [theRequest setValue:@"MEDTELAPP2013" forHTTPHeaderField:@"X_MEDTELAPP_KEY"];
                                                 
                                                 NSString *authuser = @"username=";
                                                 NSString *authpass = @"&pass=";
                                                 NSString *concatenate1 = [authuser stringByAppendingString:[result2 objectForKey:@"id"]];
                                                 NSString *concatenate2 = [authpass stringByAppendingString:[result2 objectForKey:@"id"]];
                                                 NSString *Post = [concatenate1 stringByAppendingString:concatenate2];
                                                 
                                                 NSLog(@"UDID:: %@", Post);
                                                 //NSString *post = [URL stringByAppendingString:stringWithoutSpaces];
                                                 NSData *postData = [Post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                                                 [theRequest setHTTPBody:postData];
                                                 
                                                 [NSURLConnection sendAsynchronousRequest:theRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                                     // if(data != nil){
                                                     NSString *noti = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                     //NSString *newStr = [noti substringWithRange:NSMakeRange(0, [noti length]-4)];
                                                     NSLog(@"trimmedString:: %@", noti);
                                                     if(data!=nil){
                                                         if([noti  isEqual: @"0"]){
                                                             _loginError.hidden = NO;
                                                         }else{
                                                             _loginError.hidden = YES;
                                                             [userDefault setValue:noti forKey:@"website"];
                                                             [userDefault setValue:userNameSend forKey:@"email"];
                                                             [userDefault setValue:[result2 objectForKey:@"id"] forKey:@"password"];
                                                             [userDefault setValue:@"1" forKey:@"login"];
                                                             [userDefault synchronize];
                                                             WebsiteViewController *viewController = [[WebsiteViewController alloc] initWithNibName:@"WebsiteViewController" bundle:nil];
                                                             [self.navigationController pushViewController:viewController animated:YES];
                                                         }
                                                         
                                                         FBSDKLoginManager *loginmanager= [[FBSDKLoginManager alloc]init];
                                                         [loginmanager logOut];
                                                         
                                                         [SVProgressHUD dismiss];
                                                     }else{
                                                         // [self _showAlert2:@"Por favor,conectarse a Internet"];
                                                         _loginError.text = @"No internet connection";
                                                         _loginError.hidden = NO;
                                                         [SVProgressHUD dismiss];
                                                     }
                                                 }];
                                                 
                                             }
                                             FBSDKLoginManager *loginmanager= [[FBSDKLoginManager alloc]init];
                                             [loginmanager logOut];
                                             [SVProgressHUD dismiss];
                                         }else{
                                             // [self _showAlert2:@"Por favor,conectarse a Internet"];
                                             [SVProgressHUD dismiss];
                                             _loginError.text = @"No internet connection";
                                             _loginError.hidden = NO;
                                         }
                                     }];
                                 }
                             }];
                            
                        } else
                        {
                            NSLog(@"Not granted");
                        }
                        
                        NSLog(@"Response:: %@", result.grantedPermissions);
                        [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
                    }
                }
            }];
        }else if(buttonIndex == 1){
            SignUpViewController *viewcontroller = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
            [self.navigationController pushViewController:viewcontroller animated:YES];
        }
    }
    
}

- (IBAction)signInWithoutFB:(id)sender {
    email = _emailET.text;
    pass = _passwordET.text;
    if(_emailET.text.length == 0){
        _emailET.layer.borderColor = [UIColor redColor].CGColor;
        UIColor *color = [UIColor redColor];
        _emailET.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
        _passwordET.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
    } else if (_passwordET.text.length == 0){
        _emailET.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _passwordET.layer.borderColor = [UIColor redColor].CGColor;
        UIColor *color = [UIColor redColor];
        _passwordET.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    }else{
        _emailET.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _passwordET.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self Login];
    }
}

@end
