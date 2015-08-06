//
//  TipsEntrevistaTableViewController.m
//  App CVC
//
//  Created by Jose Kovacevich on 4/8/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

#import "TipsEntrevistaTableViewController.h"
#import "DetailEntrevistaViewController.h"
#import "CustomTableViewCell.h"

@interface TipsEntrevistaTableViewController ()

@property NSArray *tipsEntrevista;

@end

@implementation TipsEntrevistaTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Tips para Entrevista";
    
    NSString *pathPList = [[NSBundle mainBundle] pathForResource: @"TipsEntrevista" ofType: @"plist"];
    self.tipsEntrevista = [[NSArray alloc] initWithContentsOfFile:pathPList];
    self.view.backgroundColor = [UIColor colorWithRed:(54.0/255.0) green:(109.0/255.0) blue:(127.0/255.0) alpha:1]; //Color para las celdas vacias
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tipsEntrevista.count;
}


- (CustomTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Cell" forIndexPath:indexPath];
    
    NSDictionary *object = self.tipsEntrevista[indexPath.row];
    //    cell.textLabel.text = [object description];
    
    cell.lbTip.text = [object	objectForKey: @"nombre"];
    cell.lbTip.lineBreakMode = NSLineBreakByWordWrapping;
    cell.lbTip.numberOfLines = 0;
    
    NSString *strImage = [object    objectForKey: @"imagen"];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *fullImgPath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:strImage]];
//    UIImage *imagen = [UIImage imageWithContentsOfFile:fullImgPath];
    
    cell.uiImage.image = [UIImage imageNamed: strImage];
    
    return cell;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetailEntrevista"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *object = self.tipsEntrevista[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}
@end
