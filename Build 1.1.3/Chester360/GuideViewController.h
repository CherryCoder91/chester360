//
//  GuideViewController.h
//  Chester360
//
//  Created by James Pickup on 22/02/2013.
//  Copyright (c) 2013 James Pickup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface GuideViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ADBannerViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *mainGuideIntroPhotoView;
- (void)PrototypeAnnouncement;
@property (weak, nonatomic) IBOutlet UITableView *Chester360TableView;

@property (nonatomic, retain) IBOutlet ADBannerView *myAddView;

@end
