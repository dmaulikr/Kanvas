//
//  KanvasTableViewController.m
//  Kanvas
//
//  Created by Liam Fox on 2/26/13.
//  Copyright (c) 2013 Liam Fox. All rights reserved.
//

#import "KanvasTableViewController.h"
#import "AddedStoreViewController.h"
#import "AddingStoreViewController.h"


@interface KanvasTableViewController ()

@end

@implementation KanvasTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        storeDB = [NSUserDefaults standardUserDefaults];
//        UILabel *tableFooter = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
//        tableFooter.text = @"(Only 10 locations can be monitored at once.)";
//        tableFooter.textAlignment = NSTextAlignmentCenter;
//        tableFooter.font = [UIFont fontWithName:@"Helvetica" size:14];
//        tableFooter.backgroundColor = [UIColor clearColor];

        
        
        self.navigationItem.title = @"My Stores";
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        //storeTableView.tableHeaderView = tableHeader;
        
        if ([[storeDB objectForKey:@"highestIndex"] intValue] >= 0) {
            //self.tableView.tableFooterView = tableFooter;
            self.tableView.scrollEnabled = YES;
        } else {
            self.tableView.scrollEnabled = NO;
            //UIImageView *overhere = [uiima]
        }
       // storeTableView.editing = YES;
        
        CGRect tbFrame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-44, [[UIScreen mainScreen] bounds].size.width, 44.01);
        toolBar = [[UIToolbar alloc] initWithFrame:tbFrame];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewStore)];

      //  self.navigationController.navigationItem.rightBarButtonItem = edit;
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        //[self.view addSubview:toolBar];
        [self.navigationController.toolbar setBarStyle:UIBarStyleDefault];
        //[self.navigationController.toolbar setCenter:CGPointMake(0, 100)];
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController setToolbarHidden:YES];
        [self setToolbarItems:@[space, add]];
                
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[storeDB objectForKey:@"highestIndex"] intValue] < 0) {
        UITextView *instruction = [[UITextView alloc] initWithFrame:CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        instruction.text = @"No grocery stores are in your list! To add one, press the \"+\" in the toolbar below.";
        instruction.textAlignment = NSTextAlignmentCenter;
        instruction.editable = NO;
        instruction.backgroundColor = [UIColor clearColor];
        instruction.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        [self.tableView addSubview:instruction];
    } else if ([self.tableView.subviews count] > 0){
        for (UITextView *i in self.tableView.subviews) {
            [i removeFromSuperview];
        }
    }
    [self.tableView reloadData];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addNewStore
{
    AddingStoreViewController *newStore = [AddingStoreViewController new];
    [self.navigationController pushViewController:newStore animated:YES];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}

- (void)editList
{
    [self.tableView setEditing:YES animated:YES];
}

#pragma mark - Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([storeDB objectForKey:@"highestIndex"]) {
        return [[storeDB objectForKey:@"highestIndex"] integerValue] + 1;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Store"];
    [c setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    NSNumber *n = [NSNumber numberWithInt:[indexPath row]];
    c.textLabel.text = [[storeDB objectForKey:[n stringValue]] objectForKey:@"name"];
    c.detailTextLabel.text = [[storeDB objectForKey:[n stringValue]] objectForKey:@"vicinity"];
    return c;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddedStoreViewController *myAddedStoreViewController = [[AddedStoreViewController alloc] initWithStyle:UITableViewStyleGrouped];
    NSDictionary *temp = [NSDictionary new];
    temp = [storeDB objectForKey:[NSString stringWithFormat:@"%d", [indexPath row]]];
    myAddedStoreViewController.data = temp;
    myAddedStoreViewController.newPlace = NO;
    
    [self.navigationController pushViewController:myAddedStoreViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *removalIndexString = [NSString stringWithFormat:@"%d", [indexPath row]];
    NSInteger highestIndex = [[storeDB objectForKey:@"highestIndex"] intValue];
    
    [[KanvasLocationManager sharedKLM] removeGroceryStoreToBeMonitored:[storeDB objectForKey:removalIndexString]];
    
    [storeDB removeObjectForKey:removalIndexString];
    
    if (highestIndex == [indexPath row]) {
        NSString *newIndex = [NSString stringWithFormat:@"%d", highestIndex - 1];
        [storeDB setObject:newIndex forKey:@"highestIndex"];
    } else {
        for (int i = [indexPath row] + 1; i <= highestIndex; i++) {
            NSString *iString1 = [NSString stringWithFormat:@"%d", i];
            NSString *iString2 = [NSString stringWithFormat:@"%d", i - 1];
            NSDictionary *store = [storeDB objectForKey:iString1];
            [storeDB removeObjectForKey:iString1];
            [storeDB setObject:store forKey:iString2];
        }
        NSString *newIndex = [NSString stringWithFormat:@"%d", highestIndex - 1];
        [storeDB setObject:newIndex forKey:@"highestIndex"];
    }
    [storeDB synchronize];
    
    
    
    [self.tableView reloadData];
   // [self.tableView setEditing:NO];
    [self.navigationController setEditing:NO];
}

@end
