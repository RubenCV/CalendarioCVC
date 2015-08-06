//
//  DetailCurriculumViewController.h
//  App CVC
//
//  Created by Mildred Gatica on 4/27/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCurriculumViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *lbNombre;
@property (strong, nonatomic) IBOutlet UITextView *txtDescription;

@end
