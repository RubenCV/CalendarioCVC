//
//  ChartViewController.h
//  CVC
//
//  Created by Francisco Canseco on 04/05/15.
//  Copyright (c) 2015 Francisco Canseco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLPieChart.h"
@interface ChartViewController : UIViewController
@property NSNumber *profe;
@property NSNumber *eco;
@property NSNumber *intel;
@property NSNumber *pers;
- (IBAction)back:(id)sender;
@property (nonatomic, retain) IBOutlet DLPieChart *pieChartView;
@end
