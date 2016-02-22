//
//  WebsiteTabViewController.m
//  Chester360
//
//  Created by James Pickup on 18/02/2013.
//  Copyright (c) 2013 James Pickup. All rights reserved.
//

#import "WebsiteTabViewController.h"
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


@interface WebsiteTabViewController (){
    float originalWebViewHeightWithiADShowing;
    float originalWebViewHeightWithiADHidden;
}
@end

@implementation WebsiteTabViewController

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
	
    // Feed web URL into UIWebView
    NSString *urlAddress = @"http://www.visitchester.com";          //string URL
    NSURL *url = [NSURL URLWithString:urlAddress];                  //Create a URL object.
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];   //URL Requst Object
    [self.webView loadRequest:requestObj];                          //Load the request in the UIWebView.
    
    //iAd
    _WebsiteiADBanner.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [_activityIndicator startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [_activityIndicator stopAnimating];
}

#pragma - iAD Handling
-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [banner setHidden:FALSE];
    CGRect newFrame;
    if(IS_IPHONE_5){
        newFrame = CGRectMake(0, 94, self.webView.frame.size.width, 405);
    } else {
        newFrame = CGRectMake(0, 94, self.webView.frame.size.width, 317);
    }
    
    [self.webView setFrame:newFrame];
    [UIView commitAnimations];
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [banner setHidden:TRUE];
    CGRect newFrame;
    
    if(IS_IPHONE_5){
        newFrame = CGRectMake(0, 44, self.webView.frame.size.width, 455);
    } else {
        newFrame = CGRectMake(0, 44, self.webView.frame.size.width, 367);
    }
    
    [self.webView setFrame:newFrame];
    [UIView commitAnimations];
}


@end
