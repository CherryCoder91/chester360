//
//  HowToUseViewController.m
//  Chester 360
//
//  Created by James Pickup on 30/05/2013.
//  Copyright (c) 2013 James Pickup. All rights reserved.
//

#import "HowToUseViewController.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface HowToUseViewController ()

@end

@implementation HowToUseViewController

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
    _GuideiADBannerView.delegate = self;
	[_GuideiADBannerView setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - iAD Handling

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [banner setHidden:FALSE];
    CGRect newFrame;
    if(IS_IPHONE_5){
        newFrame = CGRectMake(0, 51, self.howToUseView.frame.size.width, self.howToUseView.frame.size.height);
    } else {
        newFrame = CGRectMake(0, 51, self.howToUseView.frame.size.width, self.howToUseView.frame.size.height);
    }
    
    [self.howToUseView setFrame:newFrame];
    [UIView commitAnimations];
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [banner setHidden:TRUE];
    CGRect newFrame;
    
    if(IS_IPHONE_5){
        newFrame = CGRectMake(0, 0, self.howToUseView.frame.size.width, self.howToUseView.frame.size.height);
    } else {
        newFrame = CGRectMake(0, 0, self.howToUseView.frame.size.width, self.howToUseView.frame.size.height);
    }
    
    [self.howToUseView setFrame:newFrame];
    [UIView commitAnimations];
}





@end
