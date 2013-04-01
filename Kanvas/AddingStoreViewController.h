//
//  AddingStoreViewController.h
//  Kanvas
//
//  Created by Liam Fox on 2/26/13.
//  Copyright (c) 2013 Liam Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddingStoreViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UISearchBarDelegate>
{
    UISearchBar *mSearchBar;
    BOOL searching;
    NSArray *foundStores;
    UIActivityIndicatorView *spinner;
    UITapGestureRecognizer *gestureRecognizer;;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@property (nonatomic, retain) NSDictionary *storeAdded;

@end
