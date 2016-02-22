//
//  JAPanoView.h
//  PanoTest
//
//  Created by Javier Alonso Gutiérrez on 16/02/12 and thereafter modified by James Pickup.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h> 
#import <AVFoundation/AVFoundation.h>


//GYRO
CMMotionManager *motionManager;
NSOperationQueue *opQ;
NSTimer *timer;


@interface JAPanoView : UIView //<UIGestureRecognizerDelegate>

@property (nonatomic) CGFloat zoomFactor;
@property (nonatomic) CGFloat hAngle, vAngle;
@property (nonatomic) CGFloat leftLimit, rightLimit, upLimit, downLimit; // angle limits
@property (nonatomic) CGFloat minZoom, maxZoom; // zoom limits
@property AVAudioPlayer *audioPlayer;
@property UIViewController *parentController;

@property (nonatomic, strong) UIButton *touchButton;

-(void)defaultValues;
-(void)render;
-(void)setFrontImage:(UIImage *)i1 rightImage:(UIImage *)i2 backImage:(UIImage *)i3 leftImage:(UIImage *)i4 topImage:(UIImage *)i5 bottomImage:(UIImage *)i6 labelText:(NSString*)myAttractonTitle;
//-(void)createPanoLabelWithlabelx:(int)labelx labely:(int)labely cubeNo:(NSString*)cubeToPlaceOn;
-(void)createPanoButtonWithTitle:(NSString*)buttonTitle withButtonX:(int)buttonX withButtonY:(int)buttonY cubeToPlaceOn:(NSString *)cubeToPlaceOn;
-(void)switchGyroOnOrOff;

@end
 