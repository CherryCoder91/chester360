//
//  JAPanoView.m
//  PanoTest
//
//  Created by Javier Alonso Gutiérrez on 16/02/12 and thereafter modified by James Pickup.
//

#import "JAPanoView.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "PanoramaViewController.h"
#import "PanoFeatureViewController.h"


@interface JAPanoView(){
    UIImageView *_image1,*_image2,*_image3,*_image4,*_image5,*_image6;
	CGFloat _referenceSide;
	CGFloat _previousZoomFactor;
    float rollAcceleration; 
    float pitchAccelleration;
    NSString* myPanoLabelText;
    BOOL gyroActive;
    BOOL gyroAvailible;
}

@end

@implementation JAPanoView

@synthesize zoomFactor=_zoomFactor;
@synthesize hAngle=_hAngle;
@synthesize vAngle=_vAngle;
@synthesize leftLimit=_leftLimit;
@synthesize rightLimit=_rightLimit;
@synthesize upLimit=_upLimit;
@synthesize downLimit=_downLimit;
@synthesize minZoom=_minZoom;
@synthesize maxZoom=_maxZoom;

-(void)setZoomFactor:(float)zoomFactor{
	//a limit of 0 gets a factor of 0,5
	//a limit of 100 gets a factor of 4
	float minFactor=(_minZoom*3.5/100.0)+0.5;
	float maxFactor=(_maxZoom*3.5/100.0)+0.5;
	if (zoomFactor>maxFactor) {
		zoomFactor=maxFactor;
	}else if (zoomFactor<minFactor) {
		zoomFactor=minFactor;
	}
	_zoomFactor=(zoomFactor)*_referenceSide;
}

-(float)zoomFactor{
	return (_zoomFactor/_referenceSide);
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		[self defaultValues];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
	if (self) {
		[self defaultValues];
	}
	return self;
}

-(void)defaultValues{
	if (self.bounds.size.width>self.bounds.size.height) {
		_referenceSide=self.bounds.size.width/2;
	}else {
		_referenceSide=self.bounds.size.height/2;
	}
	CGRect rect = CGRectMake(0, 0, _referenceSide*2, _referenceSide*2);
	
	// Initialization code.
	_image1=[[UIImageView alloc] initWithFrame:rect];
	_image2=[[UIImageView alloc] initWithFrame:rect];
	_image3=[[UIImageView alloc] initWithFrame:rect];
	_image4=[[UIImageView alloc] initWithFrame:rect];
	_image5=[[UIImageView alloc] initWithFrame:rect];
	_image6=[[UIImageView alloc] initWithFrame:rect];
	CGPoint centerPoint=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
	_image1.center=centerPoint;
	_image2.center=centerPoint;
	_image3.center=centerPoint;
	_image4.center=centerPoint;
	_image5.center=centerPoint;
	_image6.center=centerPoint;
	_image1.contentMode=UIViewContentModeScaleToFill;
	_image2.contentMode=UIViewContentModeScaleToFill;
	_image3.contentMode=UIViewContentModeScaleToFill;
	_image4.contentMode=UIViewContentModeScaleToFill;
	_image5.contentMode=UIViewContentModeScaleToFill;
	_image6.contentMode=UIViewContentModeScaleToFill;
	[self addSubview:_image1];
	[self addSubview:_image2];
	[self addSubview:_image3];
	[self addSubview:_image4];
	[self addSubview:_image5];
	[self addSubview:_image6];
    self.userInteractionEnabled=YES;
    // above doesn't include buttons so do:
    _image1.userInteractionEnabled = YES;
    _image2.userInteractionEnabled = YES;
    _image3.userInteractionEnabled = YES;
    _image4.userInteractionEnabled = YES;
    _image5.userInteractionEnabled = YES;
    _image6.userInteractionEnabled = YES;

    
	_zoomFactor=_referenceSide;
	_hAngle=0;
	_vAngle=0;
	_leftLimit=0;
	_rightLimit=0;
	_upLimit=M_PI_2;
	_downLimit=M_PI_2;
	_minZoom=5;
	_maxZoom=100;
	
	UIPanGestureRecognizer *panGR=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    //panGR.delegate=self;
	[self addGestureRecognizer:panGR];
	UIPinchGestureRecognizer *pinchGR=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didPinch:)];
    //pinchGR.delegate=self;
	[self addGestureRecognizer:pinchGR];
    //Double tap gesture recogniser for zoom
    UITapGestureRecognizer *dtapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureRecognizer:)];
    //dtapGestureRecognize.delegate=self;
    [self addGestureRecognizer:dtapGestureRecognize];
    dtapGestureRecognize.numberOfTapsRequired = 2;
    
    //Will play background sound when loaded
   [self playSound];
    
    //Instantiate GYRO functionality to run in thread
    //gyroactive determines whether gryo should chnage screen
    gyroActive = NO;
    //gyro availible is for error message when pressing button on old device
    gyroAvailible = YES;
    motionManager = [[CMMotionManager alloc] init];
    motionManager.deviceMotionUpdateInterval = 1.0/60.0;
    [motionManager startDeviceMotionUpdates];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:(1.0/60.0) target:self selector:@selector(ModifyPanoramaWithGyroscopeValues) userInfo:nil repeats:YES];
    
    if([motionManager isGyroAvailable])
    {
        if([motionManager isGyroActive] == NO)
        {
            [motionManager setGyroUpdateInterval:0.1];
            [motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue]
                                       withHandler:^(CMGyroData *gyroData, NSError *error)
             {
                 NSString* rotationRateX = [[NSString alloc] initWithFormat:@"%.02f",gyroData.rotationRate.x];
                 pitchAccelleration = [rotationRateX floatValue];
                 
                 NSString *rotationRateY = [[NSString alloc] initWithFormat:@"%.02f",gyroData.rotationRate.y];
                 rollAcceleration = [rotationRateY floatValue];
             }];
        }
    }
    else //if no gyro
    {
        gyroAvailible = NO;
    }
}




#pragma mark -
#pragma mark GyroHandling

-(void)ModifyPanoramaWithGyroscopeValues{
    if (gyroActive==YES) {
        
    //setting new angle to be old angle plus my change from accellerometer
    float newHAngle = self.hAngle+((rollAcceleration*-1)/60);
    float newVAngle = self.vAngle+((pitchAccelleration/50));

    //prevents cube from going over 180 vertically (upside down cube)
    if (newHAngle>0 && _rightLimit!=0) {
        if (newHAngle>_rightLimit) {
            newHAngle=_rightLimit;
        }
    }else if (newHAngle<0 && _leftLimit!=0) {
        // negative angle to the left, but limit is always positive (absolute value)
        if (newHAngle<(-_leftLimit)) {
            newHAngle=-_leftLimit;
        }
    }
    if (newVAngle>0 && _upLimit!=0) {
        if (newVAngle>_upLimit) {
            newVAngle=_upLimit;
        }
    }else if (newVAngle<0 && _downLimit!=0) {
        // negative angle to the bottom, but limit is always positive (absolute value)
        if (newVAngle<(-_downLimit)) {
            newVAngle=-_downLimit;
        }
    }
    
    //setting themain variables (necessary for next itteration of method)
    self.hAngle=newHAngle;
    self.vAngle=newVAngle;
   
    //redraw the cube if gyro is active
    
        [self render];
    }
}

-(void)setFrontImage:(UIImage *)i1 rightImage:(UIImage *)i2 backImage:(UIImage *)i3 leftImage:(UIImage *)i4 topImage:(UIImage *)i5 bottomImage:(UIImage *)i6 labelText:(NSString *)myAttractonTitle{
    //sets images + text to what I need
	_image1.image=i1;
	_image2.image=i2;
	_image3.image=i3;
	_image4.image=i4;
	_image5.image=i5;
	_image6.image=i6;
    myPanoLabelText = myAttractonTitle;
}




-(void)switchGyroOnOrOff{
    //changes boolean based on previous value (inverts) and creates error UIAlert when unavailable
    if(gyroAvailible==YES){
        if (gyroActive ==YES) {
        gyroActive = NO;
        } else if (gyroActive ==NO){
        gyroActive = YES;
        }
    }
    if (gyroAvailible==NO){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Feature unavailable on this device" message:@"No Gyroscope has been detected on this device. An iPhone 4 or higher is needed for this feature." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}
    



#pragma mark -
#pragma mark CreatingLabel/Buttons

/* COMMENTED OUT AS NOT CURRENTLY WANTING TO ADD LABELS!
-(void)createPanoLabelWithlabelx:(int)labelx labely:(int)labely cubeNo:(NSString*)cubeToPlaceOn{
    //label feature
    UILabel *myPanoTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelx, labely, 300, 20)];
    [myPanoTitleLabel setText:myPanoLabelText];
    [myPanoTitleLabel setTextColor:[UIColor blackColor]];
    [myPanoTitleLabel setBackgroundColor:[UIColor clearColor]];
    [myPanoTitleLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
    
    //no decide which UIImage view to subview into baaed on plist
    if ([cubeToPlaceOn isEqual:@"front"]) {
        [_image1 addSubview:myPanoTitleLabel];
    } else if ([cubeToPlaceOn isEqual:@"right"]) {
        [_image2 addSubview:myPanoTitleLabel];
    } else if ([cubeToPlaceOn isEqual:@"back"]) {
        [_image3 addSubview:myPanoTitleLabel];
    } else if ([cubeToPlaceOn isEqual:@"left"]) {
        [_image4 addSubview:myPanoTitleLabel];
    } else if ([cubeToPlaceOn isEqual:@"top"]) {
        [_image5 addSubview:myPanoTitleLabel];
    } else if ([cubeToPlaceOn isEqual:@"bottom"]) {
        [_image6 addSubview:myPanoTitleLabel];
    }
}*/ 


-(void)createPanoButtonWithTitle:(NSString *)buttonTitle withButtonX:(int)buttonX withButtonY:(int)buttonY cubeToPlaceOn:(NSString *)cubeToPlaceOn{
    
        //create the button
        self.touchButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        self.touchButton.frame = CGRectMake(buttonX, buttonY, 150, 30);
        [self.touchButton setTitle:buttonTitle forState:UIControlStateNormal];
        //listen for clicks
        [self.touchButton addTarget:self action:@selector(buttonPressed:)
                   forControlEvents:UIControlEventTouchDown];
        //add the button to the view
            
    //no decide which UIImage view to subview into based on plist
    if ([cubeToPlaceOn isEqual:@"front"]) {
        [_image1 addSubview:self.touchButton];
    } else if ([cubeToPlaceOn isEqual:@"right"]) {
        [_image2 addSubview:self.touchButton];
    } else if ([cubeToPlaceOn isEqual:@"back"]) {
        [_image3 addSubview:self.touchButton];
    } else if ([cubeToPlaceOn isEqual:@"left"]) {
        [_image4 addSubview:self.touchButton];
    } else if ([cubeToPlaceOn isEqual:@"top"]) {
        [_image5 addSubview:self.touchButton];
    } else if ([cubeToPlaceOn isEqual:@"bottom"]) {
        [_image6 addSubview:self.touchButton];
    }
}

-(IBAction)buttonPressed:(id)sender{
        //calls view controller segue
        [self.parentController performSegueWithIdentifier:@"panofeaturesegue" sender:self];
}

-(void)render{
	
	CATransform3D transform3D = CATransform3DIdentity;
    transform3D.m34 = 1 / -_zoomFactor;
	transform3D=CATransform3DTranslate(transform3D, -_referenceSide*cosf(_hAngle), 0, _referenceSide*sinf(_hAngle));
	transform3D=CATransform3DRotate(transform3D, (M_PI/2)+_hAngle, 0, 1, 0);
	_image1.layer.transform=CATransform3DRotate(transform3D, _vAngle, cosf((M_PI/2)+_hAngle), 0, sinf((M_PI/2)+_hAngle));
	
	float tempHAngle=_hAngle;
	float tempVAngle=_vAngle;
	transform3D = CATransform3DIdentity;
    transform3D.m34 = 1 / -_zoomFactor;
	transform3D=CATransform3DTranslate(transform3D,
									   _referenceSide*sinf(-tempHAngle),
									   -_referenceSide*cosf(-tempHAngle)*sinf(-tempVAngle),
									   -(_referenceSide*cosf(-tempHAngle)*cosf(-tempVAngle)-_zoomFactor)
									   );
	transform3D=CATransform3DRotate(transform3D, tempHAngle, 0, 1, 0);
	_image1.layer.transform=CATransform3DRotate(transform3D, tempVAngle, cosf(tempHAngle), 0, sinf(tempHAngle));
    
	tempHAngle=_hAngle-(M_PI/2);
	tempVAngle=_vAngle;
	transform3D = CATransform3DIdentity;
    transform3D.m34 = 1 / -_zoomFactor;
	transform3D=CATransform3DTranslate(transform3D,
									   _referenceSide*sinf(-tempHAngle),
									   -_referenceSide*cosf(-tempHAngle)*sinf(-tempVAngle),
									   -(_referenceSide*cosf(-tempHAngle)*cosf(-tempVAngle)-_zoomFactor)
									   );
	transform3D=CATransform3DRotate(transform3D, tempHAngle, 0, 1, 0);
	_image2.layer.transform=CATransform3DRotate(transform3D, tempVAngle, cosf(tempHAngle), 0, sinf(tempHAngle));
	
	tempHAngle=_hAngle-(M_PI);
	tempVAngle=_vAngle;
	transform3D = CATransform3DIdentity;
    transform3D.m34 = 1 / -_zoomFactor;
	transform3D=CATransform3DTranslate(transform3D,
									   _referenceSide*sinf(-tempHAngle),
									   -_referenceSide*cosf(-tempHAngle)*sinf(-tempVAngle),
									   -(_referenceSide*cosf(-tempHAngle)*cosf(-tempVAngle)-_zoomFactor)
									   );
	transform3D=CATransform3DRotate(transform3D, tempHAngle, 0, 1, 0);
	_image3.layer.transform=CATransform3DRotate(transform3D, tempVAngle, cosf(tempHAngle), 0, sinf(tempHAngle));
	
	tempHAngle=_hAngle-(3*M_PI/2);
	tempVAngle=_vAngle;
	transform3D = CATransform3DIdentity;
    transform3D.m34 = 1 / -_zoomFactor;
	transform3D=CATransform3DTranslate(transform3D,
									   _referenceSide*sinf(-tempHAngle),
									   -_referenceSide*cosf(-tempHAngle)*sinf(-tempVAngle),
									   -(_referenceSide*cosf(-tempHAngle)*cosf(-tempVAngle)-_zoomFactor)
									   );
	transform3D=CATransform3DRotate(transform3D, tempHAngle, 0, 1, 0);
	_image4.layer.transform=CATransform3DRotate(transform3D, tempVAngle, cosf(tempHAngle), 0, sinf(tempHAngle));
	
	tempHAngle=_hAngle;
	tempVAngle=_vAngle-(M_PI/2);
	transform3D = CATransform3DIdentity;
    transform3D.m34 = 1 / -_zoomFactor;
	transform3D=CATransform3DTranslate(transform3D,
									   0,
									   -_referenceSide*sinf(-tempVAngle),
									   -(_referenceSide*cosf(-tempVAngle)-_zoomFactor)
									   );
	
	transform3D=CATransform3DRotate(transform3D, tempVAngle, 1,0,0);
	_image5.layer.transform=CATransform3DRotate(transform3D, tempHAngle, 0, 0, 1);
	
	tempHAngle=_hAngle;
	tempVAngle=_vAngle+(M_PI/2);
	transform3D = CATransform3DIdentity;
    transform3D.m34 = 1 / -_zoomFactor;
	transform3D=CATransform3DTranslate(transform3D,
									   0,
									   -_referenceSide*sinf(-tempVAngle),
									   -(_referenceSide*cosf(-tempVAngle)-_zoomFactor)
									   );
	
	transform3D=CATransform3DRotate(transform3D, tempVAngle, 1,0,0);
	_image6.layer.transform=CATransform3DRotate(transform3D, -tempHAngle, 0, 0, 1);
}

-(void)layoutSubviews{
	float tempZoomFactor=self.zoomFactor;
	if (self.bounds.size.width>self.bounds.size.height) {
		_referenceSide=self.bounds.size.width/2;
	}else {
		_referenceSide=self.bounds.size.height/2;
	}
	//recalculate zoomFactor as a function of dim
	self.zoomFactor=tempZoomFactor;
	CGRect rect = CGRectMake(0, 0, _referenceSide*2, _referenceSide*2);
	
	// Initialization code.
	_image1.frame=rect;
	_image2.frame=rect;
	_image3.frame=rect;
	_image4.frame=rect;
	_image5.frame=rect;
	_image6.frame=rect;
	CGPoint centerPoint=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
	_image1.center=centerPoint;
	_image2.center=centerPoint;
	_image3.center=centerPoint;
	_image4.center=centerPoint;
	_image5.center=centerPoint;
	_image6.center=centerPoint;
    
	[self render];
}




#pragma mark -
#pragma mark GestureRecognizers

-(void)didPan:(UIPanGestureRecognizer *)gestureRecognizer{
	if (gestureRecognizer.state==UIGestureRecognizerStateBegan ||
		gestureRecognizer.state==UIGestureRecognizerStateChanged) {
		CGPoint translation=[gestureRecognizer translationInView:self];
		float newHAngle = self.hAngle-(translation.x/(_zoomFactor/1.5));
		float newVAngle = self.vAngle+(translation.y/(_zoomFactor/1.5));
		if (newHAngle>0 && _rightLimit!=0) {
			if (newHAngle>_rightLimit) {
				newHAngle=_rightLimit;
			}
		}else if (newHAngle<0 && _leftLimit!=0) {
			// negative angle to the left, but limit is always positive (absolute value)
			if (newHAngle<(-_leftLimit)) {
				newHAngle=-_leftLimit;
			}
		}
		if (newVAngle>0 && _upLimit!=0) {
			if (newVAngle>_upLimit) {
				newVAngle=_upLimit;
			}
		}else if (newVAngle<0 && _downLimit!=0) {
			// negative angle to the bottom, but limit is always positive (absolute value)
			if (newVAngle<(-_downLimit)) {
				newVAngle=-_downLimit;
			}
		}
		self.hAngle=newHAngle;
		self.vAngle=newVAngle;
		[self render];
		[gestureRecognizer setTranslation:CGPointZero inView:self];
	}
}

-(void)didPinch:(UIPinchGestureRecognizer *)gestureRecognizer{
	if (gestureRecognizer.state==UIGestureRecognizerStateBegan) {
		_previousZoomFactor=self.zoomFactor;
	}
	if (gestureRecognizer.state==UIGestureRecognizerStateBegan ||
		gestureRecognizer.state==UIGestureRecognizerStateChanged) {
		float newFactor=_previousZoomFactor*gestureRecognizer.scale;
        self.zoomFactor=newFactor;
        [self render];
	}
}

- (void)doubleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    
    //switch between zoomed in and out
    if (self.zoomFactor>1) {
        self.zoomFactor=1;
        [self render];
    } else if (self.zoomFactor<4) {
        self.zoomFactor=4;
        [self render];
    }

}




#pragma mark -
#pragma mark Sounds Background

-(void)playSound{
    NSString *soundfile = [[NSBundle mainBundle]pathForResource:@"ChesterStreet" ofType:@"m4a"];
    _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:soundfile] error:nil];
    _audioPlayer.numberOfLoops=-1; //loops
    [_audioPlayer play];
}

-(void)halt{
    [_audioPlayer stop];
}


/*
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    // Disallow recognition of tap gestures in the segmented control.
    UIView *theView = touch.view;
    if (theView == self.touchButton) {//change it to your condition
        return NO;
    }
    return YES;
}
*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end
