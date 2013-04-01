//
//  KanvasLocationManager.h
//  Kanvas
//
//  Created by Liam Fox on 3/26/13.
//  Copyright (c) 2013 Liam Fox. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface KanvasLocationManager : CLLocationManager <CLLocationManagerDelegate> 

+ (KanvasLocationManager *)sharedKLM;

- (void)addGroceryStoreToBeMonitored:(NSDictionary *)storeDictionary;
- (void)removeGroceryStoreToBeMonitored:(NSDictionary *)storeDictionary;

- (CLLocationDegrees)getLatitude;
- (CLLocationDegrees)getLongitude;
@end
