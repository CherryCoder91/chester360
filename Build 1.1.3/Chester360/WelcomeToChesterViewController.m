//
//  WelcomeToChesterViewController.m
//  Chester360
//
//  Created by James Pickup on 25/02/2013.
//  Copyright (c) 2013 James Pickup. All rights reserved.
//

#import "WelcomeToChesterViewController.h"

@interface WelcomeToChesterViewController ()

@end

@implementation WelcomeToChesterViewController

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
    
}

-(void)viewDidAppear:(BOOL)animated{
    [_scroller setScrollEnabled:YES];
    [_scroller setContentSize:CGSizeMake(300,900)]; //must be in view did appear to work
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
