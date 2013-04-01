//
//  KanvasAppDelegate.m
//  Kanvas
//
//  Created by Liam Fox on 2/26/13.
//  Copyright (c) 2013 Liam Fox. All rights reserved.
//

#import "KanvasAppDelegate.h"
#import "KanvasLocationManager.h"
@implementation KanvasAppDelegate
@synthesize navController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    storeDB = [NSUserDefaults standardUserDefaults];
    NSString *defaultPrefsFile = [[NSBundle mainBundle] pathForResource:@"defaultPrefs" ofType:@"plist"];
    NSDictionary *defaultPreferences = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
    [storeDB registerDefaults:defaultPreferences];
    [storeDB synchronize];
    
    UIView *mainScreen = [[UIView alloc] initWithFrame:CGRectMake(0, -44, [[UIScreen mainScreen] bounds].size.height,[[UIScreen mainScreen] bounds].size.width)];
    [mainScreen setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"KBG.png"]]];
    
    UIImage *myStoresImage = [UIImage imageNamed:@"msb.png"];
    UIButton *myStores = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, myStoresImage.size.width/1.5, myStoresImage.size.height/1.5)];
    [myStores setImage:myStoresImage forState:UIControlStateNormal];
    [myStores addTarget:self action:@selector(segueToStoreTable) forControlEvents:UIControlEventTouchUpInside];
    myStores.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2, 420);
    
    [mainScreen addSubview:myStores];
    
    
    mainScreenViewController = [[KanvasMainScreenViewController alloc] initWithNibName:nil bundle:[NSBundle bundleWithIdentifier:@"Fox.Kanvas"]];
    navController = [[UINavigationController alloc] initWithRootViewController:mainScreenViewController];
    [mainScreenViewController setView:mainScreen];
    mainScreenViewController.navigationController.navigationBar.topItem.title = @"Kanvas";
    if ([[storeDB objectForKey:@"highestIndex"] isEqual:@"-1"])
    {
        UITextView *welcomeText = [[UITextView alloc] initWithFrame:CGRectMake(0, 170, [UIScreen mainScreen].bounds.size.width, 240)];
        welcomeText.text = @"Welcome to Kanvas! To start never forgetting your bags again, tap the \"My Stores\" button.";
        welcomeText.backgroundColor = [UIColor clearColor];
        welcomeText.font = [UIFont fontWithName:@"Helvetica-Bold" size:28];
        welcomeText.textAlignment = NSTextAlignmentCenter;
        welcomeText.editable = NO;
        welcomeText.tag = 2;
        [mainScreenViewController.view addSubview:welcomeText];
    } else {
        UITextView *welcomeText = [[UITextView alloc] initWithFrame:CGRectMake(0, 170, [UIScreen mainScreen].bounds.size.width, 240)];
        welcomeText.text = @"Welcome to Kanvas! To change whether or not a store is being monitored, tap the \"My Stores\" button.";
        welcomeText.backgroundColor = [UIColor clearColor];
        welcomeText.font = [UIFont fontWithName:@"Helvetica-Bold" size:28];
        welcomeText.textAlignment = NSTextAlignmentCenter;
        welcomeText.editable = NO;
        welcomeText.tag = 3;
        [mainScreenViewController.view addSubview:welcomeText];
    }
    
    
    navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //[navController setToolbarHidden:NO];
    storeList = [KanvasTableViewController new];
    NSLog(@"this %@ is the highest index", [storeDB objectForKey:@"highestIndex"]);

//    NSMutableArray *regions = [NSMutableArray new];
//    
//    locationManager = [CLLocationManager new];
//    locationManager.delegate = self;
//    if ([storeDB objectForKey:@"highestIndex"] && [storeDB objectForKey:@"highestIndex"] >= 0) {
//        for (int g = 0; g <= [storeDB integerForKey:@"highestIndex"]; g++) {
//            [regions addObject:[self mapDBToRegion:[NSString stringWithFormat:@"%d", g]]];
//        }
//        [self initializeRegionMonitoringFor:regions];
//    } else {
//        //user is setting up
//    }

    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    


    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //self.window.backgroundColor = [UIColor whiteColor];
    [self.window setRootViewController:navController];
    [self.window makeKeyAndVisible];
    return YES;
}


//- (void) initializeRegionMonitoringFor:(NSMutableArray *)geofences
//{
//    if(![CLLocationManager regionMonitoringAvailable]) {
//        //warn user that this app will not work w.o loc services
//        return;
//    }
//    for(CLRegion *geofence in geofences) {
//        [locationManager startMonitoringForRegion:geofence];
//    }
//}

//- (CLRegion *)mapDBToRegion:(NSString *)regionIndex
//{
//    NSString *title = [[storeDB valueForKey:regionIndex] valueForKey:@"name"];
//    
//    CLLocationDegrees latitude = [[[storeDB valueForKey:regionIndex] valueForKey:@"latitude"] doubleValue];
//    CLLocationDegrees longitude = [[[storeDB valueForKey:regionIndex] valueForKey:@"longitude"] doubleValue];
//    
//    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
//    
//    CLLocationDistance regionRadius = 150;
//    
//    return [[CLRegion alloc] initCircularRegionWithCenter:centerCoordinate
//                                                   radius:regionRadius
//                                               identifier:title];
//}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[KanvasLocationManager sharedKLM] stopUpdatingLocation];

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[KanvasLocationManager sharedKLM] startUpdatingLocation];

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[KanvasLocationManager sharedKLM] startUpdatingLocation];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[KanvasLocationManager sharedKLM] stopUpdatingLocation];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    
    UILocalNotification *d = [UILocalNotification new];
    d.alertBody = [NSString stringWithFormat:@"You're near %@. Don't forget your reusable bags.",region.identifier];
    d.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:d];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"out of region");
    // [self showRegionAlert:@"Exiting Region" forRegion:region.identifier];
}

#pragma mark - Custom Methods
- (void)segueToStoreTable
{
    [navController pushViewController:storeList animated:YES];
}

@end
