//
//  WebsiteTabViewController.h
//  Chester360
//
//  Created by James Pickup on 18/02/2013.
//  Copyright (c) 2013 James Pickup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>



@interface WebsiteTabViewController : UIViewController <UIWebViewDelegate, ADBannerViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, retain) IBOutlet ADBannerView * WebsiteiADBanner;

@end
