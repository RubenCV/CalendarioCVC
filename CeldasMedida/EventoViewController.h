//
//  EventoViewController.h
//  CeldasMedida
//
//  Created by Ruben Cantu on 4/21/15.
//  Copyright (c) 2015 A00814298. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventoViewController : UIViewController

// Outlets.
@property (strong, nonatomic) IBOutlet UILabel *lbTitulo;
@property (strong, nonatomic) IBOutlet UITextView *tvFecha;
@property (strong, nonatomic) IBOutlet UITextView *tvLugar;
@property (strong, nonatomic) IBOutlet UITextView *tvInformes;
@property (strong, nonatomic) IBOutlet UITextView *tvDescripcion;
@property (strong, nonatomic) IBOutlet UIButton *btCalendario;

// Dia en el que aparece el evento en la vista calendario.
@property (strong, nonatomic) NSString *diaString;

// Propiedades relacionadas al dia del evento.
@property (strong, nonatomic) NSString *dateString;
@property (strong, nonatomic) NSString *dateStartString;
@property (strong, nonatomic) NSString *dateEndString;

// Propiedades del evento.
@property (nonatomic) NSInteger eventIndex;
@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSString *placeString;
@property (strong, nonatomic) NSString *summaryString;
@property (strong, nonatomic) NSString *informesString;
@property (strong, nonatomic) NSString *descriptionString;

// Botones
- (IBAction)mail:(id)sender;
- (IBAction)agregarCal:(id)sender;

@end