//
//  FirstAppDelegate.m
//  JUICEGURU
//
//  Created by user on 23/07/14.
//  Copyright (c) 2014 Digipowers. All rights reserved.
//

#import "FirstAppDelegate.h"
#import "WebsiteViewController.h"
#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBAudienceNetwork/FBAudienceNetwork.h>

@implementation FirstAppDelegate
@synthesize navController;
LoginViewController *viewController;
NSUserDefaults *userDefault;
NSString *email,*pass;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NSThread sleepForTimeInterval:5.0];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    userDefault = [NSUserDefaults standardUserDefaults];
    email = [userDefault objectForKey:@"email"];
    pass = [userDefault objectForKey:@"password"];
 //   NSString *loginCheck = [userDefault objectForKey:@"login"];
//    if(loginCheck != nil){
//        if([loginCheck isEqual:@"0"]){
//            [userDefault removeObjectForKey:@"password"];
//            [userDefault removeObjectForKey:@"email"];
//            viewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//            navController = [[UINavigationController alloc] initWithRootViewController:viewController];
//            navController.navigationBar.hidden = YES;
//            self.window.rootViewController = navController;
//            [[UIApplication sharedApplication] setStatusBarHidden:YES];
//            [self.window makeKeyAndVisible];
//            // [self Login];
//        }else{
//            [self Login];
//            viewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//            navController = [[UINavigationController alloc] initWithRootViewController:viewController];
//            navController.navigationBar.hidden = YES;
//            self.window.rootViewController = navController;
//            [[UIApplication sharedApplication] setStatusBarHidden:YES];
//            [self.window makeKeyAndVisible];
//         }
//    }else{
       viewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        navController.navigationBar.hidden = YES;
        self.window.rootViewController = navController;
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
       [self.window makeKeyAndVisible];
   // }
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
   // email = [userDefault objectForKey:@"email"];
   //  pass = [userDefault objectForKey:@"password"];
   //   userDefault = [NSUserDefaults standardUserDefaults];
   //     [self Login];
   //    NSString *strURL = @"http://live-juice-guru.gotpantheon.com/user/login";
   //    NSURL *url = [NSURL URLWithString:strURL];
   //    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
   //    [viewController.webView loadRequest:urlRequest];
    
   // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
       // NSString *newStr = [noti substringWithRange:NSMakeRange(4, [noti length]-4)];
        //NSLog(@"trimmedString:: %@", newStr);
        if(data!=nil){
            if([noti  isEqual: @"0"]){
                
            }else{
                [userDefault setValue:noti forKey:@"website"];
                [userDefault setValue:email forKey:@"email"];
                [userDefault setValue:pass forKey:@"password"];
                [userDefault setValue:@"1" forKey:@"login"];
                [userDefault synchronize];
                WebsiteViewController *viewController = [[WebsiteViewController alloc] initWithNibName:@"WebsiteViewController" bundle:nil];
                navController = [[UINavigationController alloc] initWithRootViewController:viewController];
                navController.navigationBar.hidden = YES;
                self.window.rootViewController = navController;
                [[UIApplication sharedApplication] setStatusBarHidden:YES];
                [self.window makeKeyAndVisible];

            }
            
        }else{
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Though our app offers some offline features , in order to stay actively connected to the smartWoman community in realtime you need an internet connection, please tap here to check your settings or wait till you have connection." message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];

            [alertView show];
        }
    }];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
    
}

@end
