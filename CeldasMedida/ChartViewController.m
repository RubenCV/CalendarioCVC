//
//  ChartViewController.m
//  CVC
//
//  Created by Francisco Canseco on 04/05/15.
//  Copyright (c) 2015 Francisco Canseco. All rights reserved.
//

#import "ChartViewController.h"

@interface ChartViewController ()

@end

@implementation ChartViewController
@synthesize pieChartView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
-(void)viewDidAppear:(BOOL)animated{
    [super didReceiveMemoryWarning];
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:4];
    [dataArray addObject:self.profe];
    [dataArray addObject:self.eco];
    [dataArray addObject:self.pers];
    [dataArray addObject:self.intel];
    [self.pieChartView clearsContextBeforeDrawing];
    [self.pieChartView renderInLayer:self.pieChartView dataArray:dataArray];
}
- (void)didReceiveMemoryWarning {
    
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)unwindToOriginalViewControllerSegue:(UIStoryboardSegue*)sender {
    ; //TODO: anything special you need, reference via sender
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
