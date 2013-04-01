//
//  KanvasTableViewController.h
//  Kanvas
//
//  Created by Liam Fox on 2/26/13.
//  Copyright (c) 2013 Liam Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KanvasLocationManager.h"
@interface KanvasTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
{
    UIToolbar *toolBar;
    NSUserDefaults *storeDB;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)addNewStore;
- (void)back;

@end
