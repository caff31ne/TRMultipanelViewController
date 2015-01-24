//
//  ViewController.m
//  TRMultipanelViewControllerDemo
//
//  Created by Vitaly on 1/18/15.
//  Copyright (c) 2015 bondur. All rights reserved.
//

#import "ViewController.h"

#import <TRMultipanelViewController/TRMultipanelViewController.h>

@interface ViewController ()

@property (strong, nonatomic) TRMultipanelViewController* multipanel;

- (IBAction)leftPanelDidToggle:(id)sender;
- (IBAction)rightPanelDidToggle:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.multipanel setWidth:240 forSide:TRMultipanelSideTypeLeft];
    [self.multipanel setWidth:240 forSide:TRMultipanelSideTypeRight];
    [self.multipanel hideSide:TRMultipanelSideTypeRight animated:NO];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"multipanel"]) {
        self.multipanel = segue.destinationViewController;
        
        UICollectionViewController* centerController = [self.storyboard instantiateViewControllerWithIdentifier:@"centerController"];
        [self.multipanel setCenterController:centerController];

        UITableViewController* leftController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftController"];
        [self.multipanel setContentController:leftController
                                 forSide:TRMultipanelSideTypeLeft];
        
        UITableViewController* rightController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightController"];
        [self.multipanel setContentController:rightController
                                 forSide:TRMultipanelSideTypeRight];
    }
}

- (IBAction)leftPanelDidToggle:(id)sender {
    [self.multipanel toggleSide:TRMultipanelSideTypeLeft animated:YES];
}

- (IBAction)rightPanelDidToggle:(id)sender {
    [self.multipanel toggleSide:TRMultipanelSideTypeRight animated:YES];
}

@end
