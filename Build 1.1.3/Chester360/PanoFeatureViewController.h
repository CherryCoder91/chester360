//
//  PanoFeatureViewController.h
//  Chester 360
//
//  Created by James Pickup on 12/03/2013.
//  Copyright (c) 2013 James Pickup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PanoFeatureViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *featureImage;
@property (weak, nonatomic) IBOutlet UILabel *featureTitle;
@property (weak, nonatomic) IBOutlet UITextView *featureText;
@property NSDictionary *myFeatureDictionary;
@end
