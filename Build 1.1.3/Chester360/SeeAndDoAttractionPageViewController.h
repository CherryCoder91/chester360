//
//  SeeAndDoAttractionPageViewController.h
//  Chester360
//
//  Created by James Pickup on 25/02/2013.
//  Copyright (c) 2013 James Pickup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeeAndDoAttractionPageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *myUIScrollView;
@property (weak, nonatomic) IBOutlet UILabel *attractionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *attractionSubtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *attractionImage;
@property (weak, nonatomic) IBOutlet UITextView *attractionTextView;
@property (weak, nonatomic) IBOutlet UIButton *attraction360Button;
@property NSDictionary *myAttractionDictionary;
- (IBAction)callPanorama:(id)sender;

//for panorama
@property (weak, nonatomic) NSString *sFront;
@property (weak, nonatomic) NSString *sRight;
@property (weak, nonatomic) NSString *sLeft;
@property (weak, nonatomic) NSString *sBack;
@property (weak, nonatomic) NSString *sUp;
@property (weak, nonatomic) NSString *sDown;
@end
