//
//  EventoViewController.h
//  CeldasMedida
//
//  Created by Ruben Cantu on 4/21/15.
//  Copyright (c) 2015 A00814298. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventoViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *lbTitulo;
@property (strong, nonatomic) IBOutlet UILabel *lbDescripcion;
@property (strong, nonatomic) IBOutlet UILabel *lbInformes;
@property (strong, nonatomic) IBOutlet UILabel *lbFecha;
@property (strong, nonatomic) IBOutlet UILabel *lbLugar;

@property (nonatomic, strong) NSString *dateString, *dateStartString, *dateEndString, *summaryString, *placeString, *informesString, *titleString, *descriptionString;
@property (strong, nonatomic) NSString *diaString;
@property (nonatomic) NSInteger eventIndex;

@end
