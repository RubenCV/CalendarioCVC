//
//  NoticiarioTableViewController.m
//  CeldasMedida
//
//  Created by Ruben Cantu on 4/24/15.
//  Copyright (c) 2015 A00814298. All rights reserved.
//

#import "NoticiarioTableViewController.h"
#import "NoticiaViewController.h"
#import "NoticiaTableViewCell.h"
#import "NSString+HTML.h"
#import "GlobalCalendar.h"

@interface NoticiarioTableViewController ()

@end

GlobalCalendar *myCalendar;

@implementation NoticiarioTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    myCalendar = [GlobalCalendar sharedSingleton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return myCalendar.newsIDList.count;
}

// Checar esto
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Creo la cell.
    NoticiaTableViewCell *cell;
    
    // Checo si es par, para asignar que tipo de color sera.
    if (indexPath.row % 2 == 0)
        cell = [tableView dequeueReusableCellWithIdentifier:@"Noticia" forIndexPath:indexPath];
    else
        cell = [tableView dequeueReusableCellWithIdentifier:@"NoticiaB" forIndexPath:indexPath];
    
    // Cambio los atributos de la cell.
    cell.lbNoticia.text = myCalendar.newsTitles[indexPath.row];
    cell.imgvNoticia.image = myCalendar.newsImages[indexPath.row];
    
    // Retorno la cell.
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NoticiaViewController *nvc = [segue destinationViewController];
    nvc.idNoticia = myCalendar.newsIDList[indexPath.row];
}


@end
