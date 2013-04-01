//
//  AddingStoreViewController.m
//  Kanvas
//
//  Created by Liam Fox on 2/26/13.
//  Copyright (c) 2013 Liam Fox. All rights reserved.
//

#import "AddingStoreViewController.h"
#import "AddedStoreViewController.h"
#import "KanvasLocationManager.h"
@interface AddingStoreViewController ()

@end

@implementation AddingStoreViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        foundStores = [NSArray new];
        
        searching = NO;
        mSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 220, 44)];
        mSearchBar.placeholder = @"Name of grocery store...";
        //searchBar.prompt = @"Search for a new grocery store to monitor";
        //searchBar.keyboardType = uikeyboardt
        mSearchBar.delegate = self;
//        UILabel *tableHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
//        tableHeader.text = @"Add a new store";
//        tableHeader.textColor = [UIColor blueColor];
//        tableHeader.textAlignment = NSTextAlignmentCenter;
//        tableHeader.font = [UIFont fontWithName:@"Helvetica-Bold" size:24];
//        tableHeader.backgroundColor = [UIColor clearColor];
//        gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchBarCancelButtonClicked:)];
//        if ([foundStores count] == 0) {
//            [self.tableView addGestureRecognizer:gestureRecognizer];
//        }
        
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *poweredByGoogle = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"google.png"] style:UIBarButtonItemStylePlain target: nil action: nil];
        //self.tableView.tableHeaderView = mSearchBar;
        [self setToolbarItems:@[space,poweredByGoogle]];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:mSearchBar];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([foundStores count] == 0) {
        UITextView *instruction = [[UITextView alloc] initWithFrame:CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        instruction.text = @"Search your favorite nearby grocery store.";
        instruction.textAlignment = NSTextAlignmentCenter;
        instruction.editable = NO;
        instruction.backgroundColor = [UIColor clearColor];
        instruction.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        [self.tableView addSubview:instruction];
        //NSLog(@"class %@", [[[self.tableView subviews] objectAtIndex:1] class]);
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
    if ([foundStores count] == 0) {
        return 0;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [foundStores count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (!searching) {
        NSInteger row = [indexPath row];
        static NSString *cellIdentifier = @"StoreCell";
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];

        
        cell.textLabel.text = [[foundStores objectAtIndex:row] objectForKey:@"name"];

        
        cell.textLabel.textAlignment = NSTextAlignmentRight;
        cell.detailTextLabel.text = [[foundStores objectAtIndex:row] objectForKey:@"vicinity"];
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        static NSString *cellIdentifier = @"LoadingCell";
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];

    }
//    if ([indexPath section] == 0) {
//        if ([indexPath row] == 0) {
//            UITextField *groceryName = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 185, 30)];
//            [groceryName setAdjustsFontSizeToFitWidth:YES];
//            [groceryName setReturnKeyType:UIReturnKeySearch];
//            [groceryName setPlaceholder:@"Bob's Grocery"];
//            cell.textLabel.text = @"Store Name";
//            [cell.contentView addSubview:groceryName];
//        } else if ([indexPath row] == 1) {
//            UITextField *groceryLocation = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 185, 30)];
//            [groceryLocation setAdjustsFontSizeToFitWidth:YES];
//            [groceryLocation setReturnKeyType:UIReturnKeySearch];
//            [groceryLocation setPlaceholder:@"123 Fake St."];
//            cell.textLabel.text = @"Address";
//            [cell.contentView addSubview:groceryLocation];
//        } else {
//            UITextField *localZipCode = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 185, 30)];
//            [localZipCode setAdjustsFontSizeToFitWidth:YES];
//            [localZipCode setReturnKeyType:UIReturnKeySearch];
//            [localZipCode setPlaceholder:@"000000"];
//            cell.textLabel.text = @"Zip Code";
//            [cell.contentView addSubview:localZipCode];
//        }
//    }

    // Configure the cell...
    
    return cell;
}



- (void)searchForString:(NSString *)nameOrAddress
{
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 80);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    NSString *key = @"placeholder key";
    NSString *nextPageToken = nil;
    CLLocationDegrees lat = [[KanvasLocationManager sharedKLM] getLatitude];
    CLLocationDegrees lon = [[KanvasLocationManager sharedKLM] getLongitude];
    int rad = 50000;
    
    nameOrAddress = [nameOrAddress stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *urlString;
    if (!nextPageToken) {
        urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=%@&location=%f,%f&radius=%d&sensor=true&types=grocery_or_supermarket&keyword=%@", key, lat, lon, rad, nameOrAddress];
    } else {
        urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?key=%@&location=%f,%f&radius=%d&sensor=true&type=grocery_or_supermarket&keyword=%@&pagetoken=%@", key, lat, lon, rad, nameOrAddress, nextPageToken];
    }
    
    NSLog(@"%@", urlString);
    
    NSURL *placesAPI = [NSURL URLWithString:urlString];
    NSURLRequest *req = [NSURLRequest requestWithURL:placesAPI];
    
    //NSLog(@"before a-sync");
    //tim = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:10.0] interval:1 target:self selector:@selector(showConnectionWarning) userInfo:nil repeats:NO];
    //[[NSRunLoop currentRunLoop] addTimer:tim forMode:NSDefaultRunLoopMode];
    [NSURLConnection sendAsynchronousRequest:req queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *res, NSData *jsonData, NSError *err) {
        
        if (jsonData == nil) {
            NSLog(@"Data was nil");
            dispatch_async(dispatch_get_main_queue(), ^{
                [spinner stopAnimating];
                searching = NO;
                UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Search Failed!" message:@"No results found. Please make sure you have an internet connection and that location services for Kanvas are enabled." delegate:nil cancelButtonTitle:@"Return" otherButtonTitles:nil];
                [a show];
            });
            return;
        }
        
        
        NSDictionary *JSONParse = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        if ([JSONParse objectForKey:@"next_page_token"]) {
            //   nextPageToken = [JSONParse objectForKey:@"next_page_token"];
        }
        
        NSArray *results = [NSArray arrayWithArray:[JSONParse objectForKey:@"results"]];
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [spinner stopAnimating];
            foundStores = results;
            if ([foundStores count] == 0) {
                UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Search Failed!" message:@"No results found. Make sure you're online." delegate:nil cancelButtonTitle:@"Return" otherButtonTitles:nil];
                [a show];
            } else {
                [[self.tableView.subviews objectAtIndex:1] removeFromSuperview];
            }
            searching = NO;
            [self.tableView removeGestureRecognizer:gestureRecognizer];
            [self.tableView reloadData];
        });
    }];
    
    searching = YES;
}

//- (void)didReturnWithSuccess:(BOOL)didSucceed
//{
//    if (!didSucceed) {
//        return;
//    }
//    
//    foundStores = 
//    
//}
//- (void)populateContentsArrayWithResults:(NSArray *)results {
//    for (int i = 0; i < [results count]; i++) {
//        
//    }
//}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AddedStoreViewController *myAddedStoreViewController = [[AddedStoreViewController alloc] initWithStyle:UITableViewStyleGrouped];
    myAddedStoreViewController.data = [foundStores objectAtIndex:[indexPath row]];
    myAddedStoreViewController.newPlace = YES;

    [self.navigationController pushViewController:myAddedStoreViewController animated:YES];
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
   

}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchBarCancelButtonClicked:)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    searching = YES;
    return YES;

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searching) {
        [searchBar resignFirstResponder];
        [self searchForString:searchBar.text];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if (searching) {
        searching = NO;
        [self.tableView removeGestureRecognizer:gestureRecognizer];
        [mSearchBar resignFirstResponder];
    }

}

@end
