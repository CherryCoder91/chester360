//
//  MapTabViewController.h
//  Chester360
//
//  Created by James Pickup on 18/02/2013.
//  Copyright (c) 2013 James Pickup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapTabViewController : UIViewController<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;    //mapView Outlet
- (void)centerMap:(NSString*)zipCode;                       //method to center map
- (void) addAnnotation:(double)lattitude withLongitude:(double)longitude withTitle:(NSString*)title withSubtitle:(NSString*)subtitle; //method to add annotation
- (IBAction)ChangeMapStyle:(id)sender;                      //method to listen for segmented control change

@end
