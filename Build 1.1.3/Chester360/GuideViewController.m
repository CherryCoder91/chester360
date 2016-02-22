//
//  GuideViewController.m
//  Chester360
//
//  Created by James Pickup on 22/02/2013.
//  Copyright (c) 2013 James Pickup. All rights reserved.
//

#import "GuideViewController.h"


#define kSectionCount 1
#define kMainSection 0
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface GuideViewController (){
    NSArray * _guideTableArray; //holds the strings to populate the tableview
}
@end

@implementation GuideViewController

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
    _guideTableArray = @[@"Welcome to Chester", @"See & Do", @"Shopping"];//, @"Restaurants", @"Nightlife", @"University"];
    _myAddView.delegate = self;
    }

-(void)viewDidAppear:(BOOL)animated{
    [_Chester360TableView setContentSize:CGSizeMake(300,450)]; //must be in view did appear to work
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark -
#pragma mark TableView datasource protocols 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return kSectionCount;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_guideTableArray count];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //[[UITableViewHeaderFooterView appearance] setTintColor:[UIColor clearColor]]; //sets the background color of the section header
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:
                                 CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.height)];
    sectionHeaderView.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:
                            CGRectMake(0, 0, sectionHeaderView.frame.size.width, 22)];
    [headerLabel setFont:[UIFont systemFontOfSize:13]];
    
    headerLabel.textAlignment = NSTextAlignmentCenter;
    CALayer* layer = [headerLabel layer];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderColor = [UIColor darkGrayColor].CGColor;
    bottomBorder.borderWidth = 1;
    bottomBorder.frame = CGRectMake(-1, layer.frame.size.height-1, layer.frame.size.width+1, 1);
    [bottomBorder setBorderColor:[UIColor blackColor].CGColor];
    [layer addSublayer:bottomBorder];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.borderColor = [UIColor darkGrayColor].CGColor;
    topBorder.borderWidth = 1;
    topBorder.frame = CGRectMake(-1, 00, layer.frame.size.width+1, 1);
    [topBorder setBorderColor:[UIColor blackColor].CGColor];
    [layer addSublayer:topBorder];
    
    [sectionHeaderView addSubview:headerLabel];
    headerLabel.text = @"Chester From Every Angle";
    
    return sectionHeaderView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chesterCell"];
    
    switch (indexPath.section) {
        case kMainSection:
            cell.textLabel.text=_guideTableArray[indexPath.row];
            break;
        default:
            cell.textLabel.text =@"Uknown";
            break;
    }   
    
    UIImage *cellImage;
    //cell image is based on cell title
    cellImage=[UIImage imageNamed:[NSString stringWithFormat:@"%@%@", cell.textLabel.text, @".png"]];
    cell.imageView.image=cellImage;
    return  cell;
}

#pragma mark -
#pragma mark TableView delegate protocols

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

            switch (indexPath.row) {
                case 0:
                    NSLog(@"0");
                    [self performSegueWithIdentifier:@"WelcomeToChesterSegue" sender:self];
                    break;
                case 1:
                    [self performSegueWithIdentifier:@"See&DoSegue" sender:self];
                    break;
                case 2:
                    [self performSegueWithIdentifier:@"ShoppingSegue" sender:self];
                    break;
                case 3:
                    [self PrototypeAnnouncement];
                    break;
                case 4:
                    [self PrototypeAnnouncement];
                    break;
                case 5:
                    [self PrototypeAnnouncement];
                default:
                    break;
            }
}

#pragma mark -
#pragma mark UIAlertMethod

-(void)PrototypeAnnouncement{
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc]
                   initWithTitle:@"Sorry!" message:@"This feature of the application is not part of the prototype design and does not do anything OR is yet to be implemented" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    alertDialog.alertViewStyle=UIAlertViewStyleDefault;
    [alertDialog show];
}


#pragma mark - iAddHandling

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [banner setHidden:FALSE];
    CGRect newFrame;
    if(IS_IPHONE_5){
        newFrame = CGRectMake(0, self.Chester360TableView.frame.origin.y, self.Chester360TableView.frame.size.width, 246);
    } else {
        newFrame = CGRectMake(0, self.Chester360TableView.frame.origin.y, self.Chester360TableView.frame.size.width, 158);
    }
    
    [self.Chester360TableView setFrame:newFrame];
    [UIView commitAnimations];
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [banner setHidden:TRUE];
    CGRect newFrame;
    
    if(IS_IPHONE_5){
        newFrame = CGRectMake(0, self.Chester360TableView.frame.origin.y, self.Chester360TableView.frame.size.width, 296);
    } else {
        newFrame = CGRectMake(0, self.Chester360TableView.frame.origin.y, self.Chester360TableView.frame.size.width, 208);
    }
    
    [self.Chester360TableView setFrame:newFrame];
    [UIView commitAnimations];
}


@end
