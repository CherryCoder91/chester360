//
//  PanoramaViewController.m
//  Chester360
//
//  Created by James Pickup on 26/02/2013.
//  Copyright (c) 2013 James Pickup. All rights reserved.
//

#import "PanoramaViewController.h"
#import "JAPanoView.h"
#import "SeeAndDoAttractionPageViewController.h"
#import "PanoFeatureViewController.h"

@interface PanoramaViewController (){
    JAPanoView *panoView;
    NSString *sFront;
    NSString *sRight;
    NSString *sLeft;
    NSString *sBack;
    NSString *sUp;
    NSString *sDown;
    NSString *myLabelText;
    NSString *stringlabelx;
    NSString *stringlabely;
    int labely;
    int labelx;
    NSString *cubeToPlaceLabelOn;
    NSString *sButtonX;
    NSString *sButtonY;
    int buttonX;
    int buttonY;
    NSString* buttonTitle;
    NSString* cubeToPlaceButtonOn;
}
@end

@implementation PanoramaViewController

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
    //reveal navbar
    [self.navigationController setNavigationBarHidden:NO];
    //set img URL values from the panorama from NSDictionary
    [self loadCubeVariables];  
    //Load pano view (UIView subclass)
	panoView=[[JAPanoView alloc] initWithFrame:CGRectMake(0, 0, 1, 11)];
    self.view=panoView;
    [panoView setFrontImage:[UIImage imageNamed:sFront]
                 rightImage:[UIImage imageNamed:sRight]
                  backImage:[UIImage imageNamed:sBack]
                  leftImage:[UIImage imageNamed:sLeft]
                   topImage:[UIImage imageNamed:sUp]
                bottomImage:[UIImage imageNamed:sDown]
                labelText:myLabelText];
    
    //create label within panorama
    //[panoView createPanoLabelWithlabelx:labelx labely:labely cubeNo:cubeToPlaceLabelOn];
    
    //createButton
    [panoView createPanoButtonWithTitle:buttonTitle withButtonX:buttonX withButtonY:buttonY cubeToPlaceOn:cubeToPlaceButtonOn];
    
    //set gryoscope button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Activate Gyroscope" style:UIBarButtonItemStylePlain target:self action:@selector(panoGyro)];
    panoView.parentController = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidDisappear:(BOOL)animated{
    //stop sound when we leave pano
    [panoView.audioPlayer stop];
}

-(void)loadCubeVariables {
    //gets all the values we will need from plist
    sFront = [_myPanoramaDictionary objectForKey:@"front image"];
    sRight = [_myPanoramaDictionary objectForKey:@"right image"];
    sLeft = [_myPanoramaDictionary objectForKey:@"left image"];
    sBack = [_myPanoramaDictionary objectForKey:@"back image"];
    sUp = [_myPanoramaDictionary objectForKey:@"up image"];
    sDown = [_myPanoramaDictionary objectForKey:@"down image"];
    myLabelText = [_myPanoramaDictionary objectForKey:@"title"];
    stringlabelx = [_myPanoramaDictionary objectForKey:@"labelx"];
    stringlabely = [_myPanoramaDictionary objectForKey:@"labely"];
    labelx = [stringlabelx intValue];
    labely = [stringlabely intValue];
    cubeToPlaceLabelOn = [_myPanoramaDictionary objectForKey:@"labelcubeface"];
    //values for button
    sButtonX = [_myPanoramaDictionary objectForKey:@"buttonx"];
    sButtonY = [_myPanoramaDictionary objectForKey:@"buttony"];
    buttonX = [sButtonX intValue];
    buttonY = [sButtonY intValue];
    buttonTitle = [_myPanoramaDictionary objectForKey:@"buttontitle"];
    cubeToPlaceButtonOn = [_myPanoramaDictionary objectForKey:@"buttoncubeface"];
}

-(void)panoGyro{
    [panoView switchGyroOnOrOff];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    PanoFeatureViewController *myPanoFeatureViewController= (PanoFeatureViewController *) segue.destinationViewController;  //sets view controller
    myPanoFeatureViewController.myFeatureDictionary = _myPanoramaDictionary;
}
-(void)panoFeatureSegue{
    [self performSegueWithIdentifier:@"panofeaturesegue" sender:self];
}


@end
