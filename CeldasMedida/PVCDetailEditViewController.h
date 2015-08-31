//
//  PVCDetailEditViewController.h
//  CeldasMedida
//
//  Created by Ruben Cantu on 8/30/15.
//  Copyright (c) 2015 A00814298. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PVCDetailEditViewController : UIViewController

//
@property (nonatomic) NSInteger semestre;
@property (strong, nonatomic) NSString *tipoActividad;
@property (strong, nonatomic) NSString *nombActividad;
@property (strong, nonatomic) NSString *value;

//
@property (strong, nonatomic) IBOutlet UILabel *lbTitulo;
@property (strong, nonatomic) IBOutlet UILabel *lbTipo;
@property (strong, nonatomic) IBOutlet UITextField *tfDuracion;
@property (strong, nonatomic) IBOutlet UITextField *tfMeta;
@property (strong, nonatomic) IBOutlet UITextView *tvDescripcion;
@property (strong, nonatomic) IBOutlet UITextView *tvIndicador;

@end
