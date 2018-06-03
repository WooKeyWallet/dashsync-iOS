//
//  DSDerivationPathsAddressesViewController.h
//  DashSync_Example
//
//  Created by Sam Westrich on 6/3/18.
//  Copyright © 2018 Andrew Podkovyrin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DashSync/DashSync.h>
#import <CoreData/CoreData.h>

@interface DSDerivationPathsAddressesViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property(nonatomic,strong) DSDerivationPath * derivationPath;

@end
