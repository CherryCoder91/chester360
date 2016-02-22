//
//  PanoramaViewController.h
//  Chester360
//
//  Created by James Pickup on 26/02/2013.
//  Copyright (c) 2013 James Pickup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PanoramaViewController : UIViewController

@property NSDictionary *myPanoramaDictionary;
@property (nonatomic, strong) PanoramaViewController *received;

-(void)panoFeatureSegue;

@end
