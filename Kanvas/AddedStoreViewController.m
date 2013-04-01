//
//  AddedStoreViewController.m
//  Kanvas
//
//  Created by Liam Fox on 2/26/13.
//  Copyright (c) 2013 Liam Fox. All rights reserved.
//

#import "AddedStoreViewController.h"
#import "KanvasLocationManager.h"

@interface AddedStoreViewController ()

@end

@implementation AddedStoreViewController

@synthesize data;
@synthesize newPlace;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        data = [NSDictionary new];
        storeDB = [NSUserDefaults standardUserDefaults];
        scale = [UIScreen mainScreen].scale;

        //https://maps.googleapis.com/maps/api/place/photo?photoreference=CnRuAAAAYh91JK1kGh60HVFiCfzmlsLjnzohzRlMHTUaFDstS7zXzkAi2eGFLrSFb5y3NsRAYUyrGYax_KMBEbv6YrZoIuZsyYGu5k8cL7AZrtIcNRb1-OzBMtwpziUv4FibtlCqdG8GSqrFQ8K9KeBClTD7qhIQQCaKsziafna-94Qli8feRhoUEqS2vx4KZStj7omsk_PktmxJRqw&sensor=false&maxheight=200&maxwidth=2000&key=AIzaSyB43o_vea3U3EfI_Si3VCZQF-KOMjG00uc
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    unavailable = [UIImage imageNamed:@"unavailable.png"];
//    NSLog(@"scale: %f", [UIScreen mainScreen].scale);
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
//    CGSize newSize = CGSizeMake(unavailable.size.width, unavailable.size.height);
//    CGImageRef imageRef = storeImage.CGImage;
//    
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(unavailable.size.width/2, unavailable.size.height/2), NO, 0);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    // Set the quality level to use when rescaling
//    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
//    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, unavailable.size.height/2);
//    
//    CGContextConcatCTM(context, flipVertical);
//    // Draw into the context; this scales the image
//    CGContextDrawImage(context, newRect, imageRef);
//    
//    // Get the resized image from the context and a UIImage
//    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
//    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
//    
//    CGImageRelease(newImageRef);
//    UIGraphicsEndImageContext();

    
    storePic = [[UIImageView alloc] initWithImage:unavailable];
    [self search];

    storePic.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 0.5*storePic.frame.size.width)/2, 20, storePic.frame.size.width/2, storePic.frame.size.height/2);
    
         
    UITextView *storeName = [[UITextView alloc] initWithFrame:CGRectMake(30, 225, 260, 50)];
    storeName.text = [data objectForKey:@"name"];
    storeName.textAlignment = NSTextAlignmentCenter;
    storeName.editable = NO;
    storeName.font = [UIFont fontWithName:@"Helvetica" size:16];
    storeName.backgroundColor = [UIColor clearColor];
    
    UITextView *storeAddress = [[UITextView alloc] initWithFrame:CGRectMake(30, 270, 260, 50)];
    storeAddress.text = [data objectForKey:@"vicinity"];
    storeAddress.textAlignment = NSTextAlignmentCenter;
    storeAddress.editable = NO;
    storeAddress.font = [UIFont fontWithName:@"Helvetica" size:16];
    storeAddress.backgroundColor = [UIColor clearColor];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addButton setFrame:CGRectMake(30, 320, 260, 50)];
    UILabel *addLabel = [[UILabel alloc] initWithFrame:addButton.frame];
    addLabel.text = @"Add to \"My Stores\"";
    addLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [addButton setTitle:@"Add to \"My Stores\"" forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addPressed) forControlEvents:UIControlEventTouchUpInside];
    spinner.center = storePic.center;

    
    
    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPressed)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *poweredByGoogle = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"google.png"] style:UIBarButtonItemStylePlain target: nil action: nil];
    
    //self.tableView.tableHeaderView = mSearchBar;
    [self setToolbarItems:@[space,poweredByGoogle]];

    [self.tableView addSubview:storeName];
    [self.tableView addSubview:storeAddress];
    [self.tableView addSubview:storePic];
    [self.tableView addSubview:spinner];
    [self.tableView setScrollEnabled:NO];
    if (newPlace) {
        //[self.navigationItem setRightBarButtonItem:addButton];
        [self.tableView addSubview:addButton];
        self.navigationItem.title = @"Add a Store";
    } else {
        self.navigationItem.title = @"Details...";
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    NSMutableArray *regions = [NSMutableArray new];
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
    

}



- (void)search
{
    
    NSString *key = @"placeholder key";

    if (![data objectForKey:@"photos"]) {
        [spinner stopAnimating];
        return;
    }
    
    NSString *photoRef = [[[data objectForKey:@"photos"] objectAtIndex:0] objectForKey:@"photo_reference"];
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?key=%@&sensor=true&maxwidth=1600&photoreference=%@", key, photoRef];

    
    NSLog(@"%@", urlString);
    
    NSURL *placesAPI = [NSURL URLWithString:urlString];
    NSURLRequest *req = [NSURLRequest requestWithURL:placesAPI];
    
    [NSURLConnection sendAsynchronousRequest:req queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *res, NSData *imageData, NSError *err) {
        
        if (!imageData) {
            NSLog(@"Data was nil");
            dispatch_async(dispatch_get_main_queue(), ^{
                [spinner stopAnimating];
            });
            return;
        }
        
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [spinner stopAnimating];
            storeImage = [[UIImage alloc] initWithData:imageData];
            
            CGRect newRect = CGRectIntegral(CGRectMake(0, 0, storePic.frame.size.width, storePic.frame.size.height));
            CGImageRef imageRef = storeImage.CGImage;
            
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(storePic.frame.size.width, storePic.frame.size.height), NO, 0);
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            // Set the quality level to use when rescaling
            CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
            CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, storePic.frame.size.height);
            
            CGContextConcatCTM(context, flipVertical);
            // Draw into the context; this scales the image
            CGContextDrawImage(context, newRect, imageRef);
            
            // Get the resized image from the context and a UIImage
            CGImageRef newImageRef = CGBitmapContextCreateImage(context);
            UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
            CGImageRelease(newImageRef);
            UIGraphicsEndImageContext();
            
            NSLog(@"px: %f", unavailable.scale);
            storePic = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:newImageRef scale:storePic.image.scale orientation:UIImageOrientationUp]];
            [storePic setFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - storePic.frame.size.width)/2, 20, storePic.frame.size.width, storePic.frame.size.height)];
            [self.view addSubview:storePic];
        });
    }];
}

- (void)backPressed
{
    [spinner stopAnimating];
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}
- (void)addPressed
{
    NSNumber *highestIndex;
    if ([storeDB objectForKey:@"highestIndex"])
    {
        highestIndex =  [NSNumber numberWithInt:[[storeDB objectForKey:@"highestIndex"] intValue]];
    } else {
        highestIndex = [NSNumber numberWithInt:-1];
    }
    
    if (highestIndex == [NSNumber numberWithInt:9]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Kanvas can only monitor 10 stores at once. If you wish to add this store, you must delete a store from your list." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
    
    highestIndex = [NSNumber numberWithInt:[highestIndex integerValue] + 1];
    [spinner stopAnimating];
    [storeDB setObject:data forKey:[highestIndex stringValue]];
    [storeDB setObject:highestIndex forKey:@"highestIndex"];
    [storeDB synchronize];
    [[KanvasLocationManager sharedKLM] addGroceryStoreToBeMonitored:data];
    [self.navigationController popToRootViewControllerAnimated:YES];
    if ([KanvasLocationManager regionMonitoringAvailable]) {
        NSString *added = [data objectForKey:@"name"];
        NSString *addedMessage = [NSString stringWithFormat:@"Kanvas will now alert you when you're near %@!", added];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:addedMessage delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alert show];
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
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
//
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
//    
//    return [[CLRegion alloc] initCircularRegionWithCenter:centerCoordinate
//                                                   radius:regionRadius
//                                               identifier:title];
//}
//- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
//{
//    
//    UILocalNotification *d = [UILocalNotification new];
//    d.alertBody = [NSString stringWithFormat:@"You're near %@. Don't forget your reusable bags.",region.identifier];
//    d.soundName = UILocalNotificationDefaultSoundName;
//    [[UIApplication sharedApplication] presentLocalNotificationNow:d];
//}

@end
