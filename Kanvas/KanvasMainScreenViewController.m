//
//  KanvasMainScreenViewController.m
//  Kanvas
//
//  Created by Liam Fox on 3/25/13.
//  Copyright (c) 2013 Liam Fox. All rights reserved.
//

#import "KanvasMainScreenViewController.h"

@interface KanvasMainScreenViewController ()

@end

@implementation KanvasMainScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.navigationController setToolbarHidden:YES animated:animated];

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"highestIndex"] isEqual:@"-1"])
    {
        if ([[[self.view subviews] objectAtIndex:1] tag] == 3) {
            [[[self.view subviews] objectAtIndex:1] removeFromSuperview];
            UITextView *welcomeText = [[UITextView alloc] initWithFrame:CGRectMake(0, 170, [UIScreen mainScreen].bounds.size.width, 240)];
            welcomeText.text = @"Welcome to Kanvas! To start never forgetting your bags again, tap the \"My Stores\" button.";
            welcomeText.backgroundColor = [UIColor clearColor];
            welcomeText.font = [UIFont fontWithName:@"AmericanTypewriter-Light" size:28];
            welcomeText.textAlignment = NSTextAlignmentCenter;
            welcomeText.editable = NO;
            welcomeText.tag = 2;
            [self.view addSubview:welcomeText];
        }
    } else if ([[[self.view subviews] objectAtIndex:1] tag] == 2) {
        [[[self.view subviews] objectAtIndex:1] removeFromSuperview];
        UITextView *welcomeText = [[UITextView alloc] initWithFrame:CGRectMake(0, 170, [UIScreen mainScreen].bounds.size.width, 240)];
        welcomeText.text = @"Welcome to Kanvas! To edit the list of grocery stores you want to track, tap the \"My Stores\" button.";
        welcomeText.backgroundColor = [UIColor clearColor];
        welcomeText.font = [UIFont fontWithName:@"Helvetica-Bold" size:28];
        welcomeText.textAlignment = NSTextAlignmentCenter;
        welcomeText.editable = NO;
        welcomeText.tag = 3;
        [self.view addSubview:welcomeText];
    }
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.navigationController setToolbarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
