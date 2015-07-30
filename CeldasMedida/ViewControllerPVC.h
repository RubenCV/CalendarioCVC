//
//  ViewControllerPVC.h
//  CVC
//
//  Created by Francisco Canseco on 25/03/15.
//  Copyright (c) 2015 Francisco Canseco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerPVC : UIViewController
@property (strong, nonatomic) IBOutlet UIView *viewVista2;
- (IBAction)descripcionSinAccion:(id)sender;
- (IBAction)acomodarFecha:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *infoCeldaOutlet;
- (IBAction)acomodarArea:(id)sender;
- (IBAction)acomodarStatus:(id)sender;
- (IBAction)acomodoFin:(id)sender;
- (IBAction)vistaSeg:(id)sender;

- (IBAction)chart:(id)sender;

- (IBAction)acomodarAlfabeticamente:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnprof;
- (IBAction)infoCelda:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *agregaOutlet;
@property (strong, nonatomic) IBOutlet UILabel *lbProfesion;
- (IBAction)guardar:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *uvAgrega;
- (IBAction)btnProfesion:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnEstadoOutlet;
- (IBAction)btnEstado:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lbFechaIn;
@property (strong, nonatomic) IBOutlet UILabel *lbFOut;
- (IBAction)guardarFecha:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnEliminar;
- (IBAction)elimina:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UIDatePicker *dtPicker;
@property (strong, nonatomic) IBOutlet UITextField *tfMeta;
@property (strong, nonatomic) IBOutlet UIView *uvDate;
- (IBAction)cancelar:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *tfObjetivo;

@property (strong, nonatomic) IBOutlet UITextView *tvIndicador;
- (IBAction)agregar:(id)sender;
- (IBAction)endDate:(id)sender;
- (IBAction)initialDate:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *tvAccion;
@end

