//
//  AddedStoreViewController.h
//  Kanvas
//
//  Created by Liam Fox on 2/26/13.
//  Copyright (c) 2013 Liam Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface AddedStoreViewController : UITableViewController <CLLocationManagerDelegate> {
    UIActivityIndicatorView *spinner;
    NSDictionary *data;
    UIImage *storeImage;
    NSUserDefaults *storeDB;
    CLLocationManager *locationManager;
    UIImage *unavailable;
    UIImageView *storePic;
    CGFloat scale;

}
@property (nonatomic, retain) NSDictionary *data;
@property (nonatomic) BOOL newPlace;

@end
