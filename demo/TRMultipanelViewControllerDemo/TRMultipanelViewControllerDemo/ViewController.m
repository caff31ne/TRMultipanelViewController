//
//  ViewController.m
//  Created by Vitali Bondur on 1/18/15.
//

#import "ViewController.h"

#import "CollectionViewController.h"

#import <TRMultipanelViewController/TRMultipanelViewController.h>

@interface ViewController ()

@property (strong, nonatomic) TRMultipanelViewController* multipanel;

- (IBAction)leftPanelDidToggle:(id)sender;
- (IBAction)rightPanelDidToggle:(id)sender;

@end

@implementation ViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"multipanel"]) {
        self.multipanel = segue.destinationViewController;
        
        [self.multipanel setConnectCenterViewToSides:YES];
        [self.multipanel setWidth:240 forSide:TRMultipanelSideTypeLeft];
        [self.multipanel setWidth:240 forSide:TRMultipanelSideTypeRight];
        
        CollectionViewController* centerController = [self.storyboard instantiateViewControllerWithIdentifier:@"centerController"];
        centerController.updateAfterResize = self.multipanel.connectCenterViewToSides;
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
