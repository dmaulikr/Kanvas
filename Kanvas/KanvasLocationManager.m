//
//  KanvasLocationManager.m
//  Kanvas
//
//  Created by Liam Fox on 3/26/13.
//  Copyright (c) 2013 Liam Fox. All rights reserved.
//

#import "KanvasLocationManager.h"

@implementation KanvasLocationManager
static KanvasLocationManager* _sharedKLM = nil;
 
+ (KanvasLocationManager *)sharedKLM
{
	@synchronized([KanvasLocationManager class])
	{
		if (!_sharedKLM)
			[[self alloc] init];
        
		return _sharedKLM;
	}
    
	return nil;
}

+ (id)alloc
{
	@synchronized([KanvasLocationManager class])
	{
		NSAssert(_sharedKLM == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedKLM = [super alloc];
		return _sharedKLM;
	}
    
	return nil;
}

-(id)init {
	self = [super init];
	if (self != nil) {
        self.delegate = self;
	}
    
	return self;
}
- (CLLocationDegrees)getLatitude
{
    return self.location.coordinate.latitude;
}
- (CLLocationDegrees)getLongitude
{
    return self.location.coordinate.longitude;
}

- (void)addGroceryStoreToBeMonitored:(NSDictionary *)storeDictionary
{
//    NSMutableArray *regions = [NSMutableArray new];
//    
//    for (int g = 0; g <= [storeDB integerForKey:@"highestIndex"]; g++) {
//        [regions addObject:[self mapDBToRegion:[NSString stringWithFormat:@"%d", g]]];
//    }
//    [self initializeRegionMonitoringFor:regions];

    NSString *title = [storeDictionary valueForKey:@"name"];
        
    CLLocationDegrees latitude = [[[[storeDictionary valueForKey:@"geometry"] valueForKey:@"location" ] valueForKey:@"lat"] doubleValue];
    CLLocationDegrees longitude = [[[[storeDictionary valueForKey:@"geometry"] valueForKey:@"location" ] valueForKey:@"lng"] doubleValue];
        
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    CLLocationDistance regionRadius = 150;
    
    CLRegion *regionToBeMonitored = [[CLRegion alloc] initCircularRegionWithCenter:centerCoordinate radius:regionRadius identifier:title];
    
    [self startMonitoringForRegion:regionToBeMonitored];
    //return [[CLRegion alloc] initCircularRegionWithCenter:centerCoordinate radius:regionRadius identifier:title];
    


}

- (void)removeGroceryStoreToBeMonitored:(NSDictionary *)storeDictionary
{
    NSString *title = [storeDictionary valueForKey:@"name"];
    
    CLLocationDegrees latitude = [[[[storeDictionary valueForKey:@"geometry"] valueForKey:@"location" ] valueForKey:@"lat"] doubleValue];
    CLLocationDegrees longitude = [[[[storeDictionary valueForKey:@"geometry"] valueForKey:@"location" ] valueForKey:@"lng"] doubleValue];
    
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    CLLocationDistance regionRadius = 150;
    
    CLRegion *regionToStopMonitoring = [[CLRegion alloc] initCircularRegionWithCenter:centerCoordinate radius:regionRadius identifier:title];
    
    [self stopMonitoringForRegion:regionToStopMonitoring];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    UILocalNotification *d = [UILocalNotification new];
    d.alertBody = [NSString stringWithFormat:@"You're near %@. Don't forget your reusable bags.", region.identifier];
    d.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:d];
}

@end
