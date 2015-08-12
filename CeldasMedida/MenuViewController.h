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
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *actEventos;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *actNoticias;

- (IBAction)eventos:(id)sender;
- (IBAction)noticias:(id)sender;

- (IBAction)logout:(id)sender;

@end