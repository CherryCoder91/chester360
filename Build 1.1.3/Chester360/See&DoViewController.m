//
//  See&DoViewController.m
//  Chester360
//
//  Created by James Pickup on 25/02/2013.
//  Copyright (c) 2013 James Pickup. All rights reserved.
//

#import "See&DoViewController.h"
#import "SeeAndDoAttractionPageViewController.h"

#define kSectionCount 1
#define kMainSection 0

@interface See_DoViewController (){
    NSInteger mySelectedTableIndexInteger;
    NSMutableArray *tableArray;
    NSDictionary *tableDictionary;
}
@end

@implementation See_DoViewController

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
    
    //load plist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"myData" ofType:@"plist"];
    tableArray = [NSArray arrayWithContentsOfFile:path];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark -
#pragma mark TableView datasource protocols

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //how many sections
    return kSectionCount;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //Number of rows based on size of array (automatic)
    return [tableArray count];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    //[[UITableViewHeaderFooterView appearance] setTintColor:[UIColor blackColor]]; //sets the background color of the section header
    return @"Things to see and do...";
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //populate cells
    tableDictionary = [tableArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"See&DoCell"];
    
    switch (indexPath.section) {
        case kMainSection:
            cell.textLabel.text=[tableDictionary objectForKey:@"title"];
            cell.detailTextLabel.text=[tableDictionary objectForKey:@"subtitle"];
            break;
        default:
            cell.textLabel.text =@"Unknown";
            break;
    }
    
    UIImage *cellImage;
    cellImage=[UIImage imageNamed:[tableDictionary objectForKey:@"table icon"]];
    cell.imageView.image=cellImage;
    return  cell;
}




#pragma mark -
#pragma mark TableView delegate protocols

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    tableDictionary = [tableArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"SeeAndDoAttractionPageSegue" sender:indexPath];
}




#pragma mark -
#pragma mark Passing Data on : prepare for segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    SeeAndDoAttractionPageViewController *sdvc = (SeeAndDoAttractionPageViewController *) segue.destinationViewController;  //sets view controller
    //passing data dictionary
    sdvc.myAttractionDictionary = tableDictionary;
}



@end
