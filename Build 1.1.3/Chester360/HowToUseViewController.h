//
//  HowToUseViewController.h
//  Chester 360
//
//  Created by James Pickup on 30/05/2013.
//  Copyright (c) 2013 James Pickup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>



@interface HowToUseViewController : UIViewController <ADBannerViewDelegate>

@property (nonatomic, retain) IBOutlet ADBannerView * GuideiADBannerView;
@property (weak, nonatomic) IBOutlet UITextView *howToUseView;

@end
