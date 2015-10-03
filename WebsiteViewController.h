//
//  WebsiteViewController.h
//  JUICEGURU
//
//  Created by user on 24/07/14.
//  Copyright (c) 2014 Digipowers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebsiteViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UIWebView *webViewIV;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
