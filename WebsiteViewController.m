//
//  WebsiteViewController.m
//  JUICEGURU
//
//  Created by user on 24/07/14.
//  Copyright (c) 2014 Digipowers. All rights reserved.
//

#import "WebsiteViewController.h"
#import "LoginViewController.h"
#import "UIImage+animatedGIF.h"
#include<unistd.h>
#include<netdb.h>

@interface WebsiteViewController ()

@end

@implementation WebsiteViewController
@synthesize activityIndicator;
NSUserDefaults *userDefault;
UIWebView *webView3;

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
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"637" ofType:@"gif"];
//    NSData *gifData = [NSData dataWithContentsOfFile:path];
//    webView3 = [[UIWebView alloc] initWithFrame:CGRectMake(123, 255, 50, 37)];
//    webView3.backgroundColor = [UIColor redColor];
//    webView3.scalesPageToFit = YES;
//    [webView3 loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
//    [self.view addSubview:webView3];
    
    NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"638" withExtension:@"gif"];
    self.imageView.image = [UIImage animatedImageWithAnimatedGIFURL:url2];
    
    userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString *WebSite = [userDefault objectForKey:@"website"];
  //  NSString *strURL = @"http://dev-juice-guru.gotpantheon.com/user/login";
    NSURL *url = [NSURL URLWithString:WebSite];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:urlRequest];
    NSString *currentURL2 = [_webView stringByEvaluatingJavaScriptFromString:@"window.location.href"];
    NSLog(@"%@",currentURL2);
    
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"oneCheck"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
  //  activityIndicator.hidden = NO;
    NSString *currentURL;
    NSString *currentURL2 = [_webView stringByEvaluatingJavaScriptFromString:@"window.location.href"];
    currentURL = [[NSString alloc] initWithFormat:@"%@", webView.request.URL];
    NSLog(@"%@",currentURL);
    NSLog(@"%@",currentURL2);
    //webView3.hidden = NO ;
     _imageView.hidden = NO;
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    webView3.hidden = YES ;
    _imageView.hidden = YES;
    
    char *hostname;
    struct hostent *hostinfo;
    hostname = "google.com";
    hostinfo = gethostbyname (hostname);
    if (hostinfo == NULL){
        NSLog(@"-> no connection!\n");
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Though our app offers some offline features , in order to stay actively connected to the smartWoman community in realtime you need an internet connection, please tap here to check your settings or wait till you have connection." message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alertView.tag = 10;
        [alertView show];
        
    }
    
    else{
        NSLog(@"-> connection established!\n");
    }

}


- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10) {
        switch(buttonIndex){
            case 0:
               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=ACCESSIBILITY"]];
                break;
                default:
                break;
        }
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSURL *currentURL = [[webView request] URL];
    NSString *finalUrl = [currentURL description];
    NSLog(@"%@",[currentURL description]);
    _imageView.hidden = YES;
    
    NSString *oneCheck = [[NSUserDefaults standardUserDefaults] objectForKey:@"oneCheck"];
    
    if ([oneCheck isEqual:@"0"]) {
    if([finalUrl isEqual:@"http://live-sw-africa.pantheon.io/welcome-to-smartwomanfrt"]){
        
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"oneCheck"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        LoginViewController *viewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self.navigationController pushViewController:viewController animated:YES];
        [userDefault setValue:@"0" forKey:@"login"];
        [userDefault synchronize];
       }
    }
    webView3.hidden = YES ;
   // activityIndicator.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
