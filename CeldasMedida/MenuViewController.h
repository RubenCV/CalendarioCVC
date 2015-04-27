//
//  MenuViewController.h
//  CeldasMedida
//
//  Created by Ruben Cantu on 4/26/15.
//  Copyright (c) 2015 A00814298. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedParser.h"

@interface MenuViewController : UIViewController
<MWFeedParserDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lbDia;

- (IBAction)facebook:(id)sender;
- (IBAction)google:(id)sender;
- (IBAction)linkedin:(id)sender;
- (IBAction)twitter:(id)sender;
- (IBAction)youtube:(id)sender;



@end