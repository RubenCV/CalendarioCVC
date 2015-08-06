//
//  DetailCurriculumViewController.m
//  App CVC
//
//  Created by Mildred Gatica on 4/27/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

#import "DetailCurriculumViewController.h"

@interface DetailCurriculumViewController ()

@end

@implementation DetailCurriculumViewController


#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.title = [self.detailItem objectForKey:@"nombre"];
        self.lbNombre.text = [self.detailItem	objectForKey: @"nombre"];
        self.lbNombre.lineBreakMode = NSLineBreakByWordWrapping;
        self.lbNombre.numberOfLines = 0;
        
        self.txtDescription.text = [self.detailItem	objectForKey: @"descripcion"];
        self.txtDescription.textColor = [UIColor colorWithRed:(185.0/255.0) green:(237.0/255.0) blue:(255.0/255.0) alpha:1];
        self.txtDescription.font = [UIFont fontWithName:@"Helvetica Neue" size:17];
        [self.txtDescription sizeToFit];
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
