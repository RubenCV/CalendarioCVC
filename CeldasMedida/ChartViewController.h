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
@property NSNumber *extCu;
@property NSNumber *esc;
@property NSNumber *aca;
@property NSNumber *serSoc;

@property (nonatomic, retain) IBOutlet DLPieChart *pieChartView;
@end
