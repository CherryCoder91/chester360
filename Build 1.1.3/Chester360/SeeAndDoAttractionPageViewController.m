//
//  SeeAndDoAttractionPageViewController.m
//  Chester360
//
//  Created by James Pickup on 25/02/2013.
//  Copyright (c) 2013 James Pickup. All rights reserved.
//

#import "SeeAndDoAttractionPageViewController.h"
#import "JAPanoView.h"
#import "PanoramaViewController.h"

@interface SeeAndDoAttractionPageViewController (){

}

@end

@implementation SeeAndDoAttractionPageViewController

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
    //setting title
    self.attractionTitleLabel.text = [_myAttractionDictionary objectForKey:@"title"];
    //setting Subtitle
    self.attractionSubtitleLabel.text = [_myAttractionDictionary objectForKey:@"subtitle"];
    //Setting Image Based on attraction title
    self.attractionImage.image = [UIImage imageNamed: [NSString stringWithFormat:@"%@.png", self.attractionTitleLabel.text]];
    //setting the TextView
    self.attractionTextView.text = [_myAttractionDictionary objectForKey:@"details"];
}

-(void)viewDidAppear:(BOOL)animated{
    //setting size of scroll view for it to fnction proporley (must be in VewDidLoad
    [_myUIScrollView setScrollEnabled:YES];
    [_myUIScrollView setContentSize:CGSizeMake(300,1400)]; //must be in view did appear to work
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    PanoramaViewController *panoController= (PanoramaViewController *) segue.destinationViewController;  //sets view controller
    //passing data dictionary
    panoController.myPanoramaDictionary = _myAttractionDictionary;
}





#pragma mark -
#pragma mark Load Panorama 360

- (IBAction)loadCube_btn:(id)sender {
    [self performSegueWithIdentifier: @"Load Panorama" sender: self];
}
- (IBAction)callPanorama:(id)sender {
    [self loadCube_btn:sender];
}


@end
