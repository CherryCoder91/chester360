//
//  PanoFeatureViewController.m
//  Chester 360
//
//  Created by James Pickup on 12/03/2013.
//  Copyright (c) 2013 James Pickup. All rights reserved.
//

#import "PanoFeatureViewController.h"
#import "PanoramaViewController.h"

@interface PanoFeatureViewController ()

@end

@implementation PanoFeatureViewController

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

    self.featureTitle.text = [_myFeatureDictionary objectForKey:@"featuretitle"];
    self.featureImage.image = [UIImage imageNamed: [NSString stringWithFormat:@"%@.png", self.featureTitle.text]];
    self.featureText.text = [_myFeatureDictionary objectForKey:@"featuretext"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
