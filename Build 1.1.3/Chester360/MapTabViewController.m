//
//  MapTabViewController.m
//  Chester360
//
//  Created by James Pickup on 18/02/2013.
//  Copyright (c) 2013 James Pickup. All rights reserved.
//

#import "MapTabViewController.h"
#import "PanoramaViewController.h"

@interface MapTabViewController ()  {
    MKPlacemark *_zipAnnotation;  // my annotation variable
    NSMutableArray *tableArray;
    NSMutableDictionary *annotationDictionary;
    int disclosureTagValue;
}
@end

@implementation MapTabViewController

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
    [self.navigationController setNavigationBarHidden:YES];
    //load plist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"myData" ofType:@"plist"];
    tableArray = [NSArray arrayWithContentsOfFile:path];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    disclosureTagValue = 0;
    
    [self.navigationController setNavigationBarHidden:YES];
    //[self centerMap:@"CH12HU"]; //called in did appear as to early for map in dd load + reloads chester every time you switch tabs!
    [self temporaryCenterMaps]; //used while googles service is down to give my defined co-ordinates
    
    //Run through Plist and add map annotations at specified co-ordinates
    for (int i = 0; i<tableArray.count; i++) {
        //disclosureTagValue = i;
        annotationDictionary = [tableArray objectAtIndex:i];
        NSString *latitude = [annotationDictionary objectForKey:@"latitude"];
        double latitudeDouble = [latitude doubleValue];
        NSString *longitude = [annotationDictionary objectForKey:@"longitude"];
        double longitudeDouble = [longitude doubleValue];
        NSString *title = [annotationDictionary objectForKey:@"title"];
        NSString *subtitle = [annotationDictionary objectForKey:@"subtitle"];
        
        [self addAnnotation:latitudeDouble withLongitude:longitudeDouble withTitle:title withSubtitle:subtitle];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark -
#pragma mark Map Handling Methods

-(void)temporaryCenterMaps{
    //Centers map with FIXED co-ordinates I input
    MKCoordinateRegion mapRegion;       //iOS formatted region for map to display
    mapRegion.center.latitude=53.192737;                    //define the map region to display
    mapRegion.center.longitude=-2.891921;
    mapRegion.span.latitudeDelta=0.035;                     //specifies the map scale - bigger value = bigger scale
    mapRegion.span.longitudeDelta=0.035;
    [self.mapView setRegion:mapRegion animated:YES];        //redraws the map onto the parent view (animated)
}

- (void) centerMap:(NSString *)zipCode {
    
    //Centers map based on postcode using google internet service
    NSString *queryURL;                 //google URL to request
    NSString *queryResults;             //the results
    NSArray *queryData;                 //parsed results
    double lattitude;                   //stores latutude
    double longitude;                   //stores longitude
    MKCoordinateRegion mapRegion;       //iOS formatted region for map to display
    
    queryURL = [[NSString alloc]initWithFormat:@"http://maps.google.com/maps/geo?output=csv&q=%@", zipCode]; // holds url to call for results with zipcode value (google)
    queryResults = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:queryURL] encoding:NSUTF8StringEncoding error:nil];  //calls queryURL and sets queryResults value
    
    queryData = [queryResults componentsSeparatedByString:@","]; //fills array with csv results
    
    if([queryData count]==4){                                   //if four results (we expect only four)
        lattitude=[queryData[2] doubleValue];                   //take data from array and store as double-precision floating point numbers
        longitude=[queryData[3] doubleValue];
        //Core Location Co-ordinate 2D
        mapRegion.center.latitude=lattitude;                    //define the map region to display
        mapRegion.center.longitude=longitude;
        mapRegion.span.latitudeDelta=0.035;                     //specifies the map scale - bigger value = bigger scale
        mapRegion.span.longitudeDelta=0.035;
        [self.mapView setRegion:mapRegion animated:YES];        //redraws the map onto the parent view (animated)
    }
}

- (IBAction)ChangeMapStyle:(id)sender {
    //handles map style with segmented controll
    switch (((UISegmentedControl *)sender).selectedSegmentIndex) {  //method is called when segmented control value is changed
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
    }
}






#pragma mark -
#pragma mark Annotation Handling Methods


-(void)addAnnotation:(double)lattitude withLongitude:(double)longitude withTitle:(NSString *)title withSubtitle:(NSString *)subtitle{
    
    //Handles the adding off the anotation
    CLLocationCoordinate2D annotationCoord;
    annotationCoord.latitude = lattitude;
    annotationCoord.longitude = longitude;
    
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = annotationCoord;
    annotationPoint.title = title;
    annotationPoint.subtitle = subtitle;
    [self.mapView addAnnotation:annotationPoint];
}

-(MKAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(id<MKAnnotation>)annotation {  //is auto called when creating annotation
    
    //Handles the annotations view (popup)
    MKAnnotationView *view = nil;                       // If you are showing the users location on the map you don't want to change it
    if (annotation != mapView.userLocation) {           // This is not the users location indicator (the blue dot)
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotationIdentifier"];
        view.canShowCallout = YES; // So that the callout can appear
        UIButton *disclosureButton = [UIButton buttonWithType: UIButtonTypeDetailDisclosure];                                               //creating UIButton
        view.rightCalloutAccessoryView = disclosureButton;                                                                                  //places button at right
        
        
        
        for (int i = 0; i<tableArray.count; i++)
        {
            annotationDictionary = [tableArray objectAtIndex:i];
            NSString *title = [annotationDictionary objectForKey:@"title"];
            
            if (title == view.annotation.title)
            {
                //i is tag value we want
                disclosureButton.tag = i;
            }
        }
      
    
        //disclosureButton.tag = disclosureTagValue;
        disclosureTagValue ++;

        
                [disclosureButton addTarget:self action:@selector(loadPano:) forControlEvents:UIControlEventTouchUpInside];       //sets method to call
    }
    
    return view;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    //Unused
}





#pragma mark -
#pragma mark Seque Transition Handling

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    //Preperation for segue handling (passing of data to new viewcontroller)
    PanoramaViewController *panoController= (PanoramaViewController *) segue.destinationViewController;  //sets view controller
    //passing data dictionary
    panoController.myPanoramaDictionary = annotationDictionary;
}


- (void)loadPano:(UIButton*)sender {
    
    NSInteger relevantInteger = sender.tag;
    annotationDictionary = [tableArray objectAtIndex:relevantInteger];
    
    [self performSegueWithIdentifier: @"map to panorama" sender: self];
    // More code here
}



@end
