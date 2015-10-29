//
//  TipsEntrevistaViewController.h
//  CeldasMedida
//
//  Created by Gilberto on 10/28/15.
//  Copyright (c) 2015 A00814298. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface TipsEntrevistaViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lTitulo;
@property (weak, nonatomic) IBOutlet UISegmentedControl *seg;
@property (weak, nonatomic) IBOutlet UITextView *texto;
@property (weak, nonatomic) IBOutlet UILabel *barra;
- (IBAction)seccion:(id)sender;
@end