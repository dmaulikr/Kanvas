//
//  KanvasAppDelegate.h
//  Kanvas
//
//  Created by Liam Fox on 2/26/13.
//  Copyright (c) 2013 Liam Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "KanvasTableViewController.h"
#import "KanvasMainScreenViewController.h"

@interface KanvasAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>
{
    KanvasTableViewController *storeList;
    KanvasMainScreenViewController *mainScreenViewController;
    NSUserDefaults *storeDB;
    //CLLocationManager *locationManager;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;


- (void)segueToStoreTable;

@end
