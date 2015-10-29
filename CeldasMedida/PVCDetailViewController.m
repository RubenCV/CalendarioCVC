//
//  PVCDetailViewController.m
//  CeldasMedida
//
//  Created by Ruben Cantu on 8/30/15.
//  Copyright (c) 2015 A00814298. All rights reserved.
//

#import "PVCDetailViewController.h"
#import "PVCDetailEditViewController.h"

@interface PVCDetailViewController ()

@end

@implementation PVCDetailViewController

NSMutableDictionary *data;
NSString *path;

- (void)viewDidLoad {
    [super viewDidLoad];
    _value = [NSString stringWithFormat:@"%@Sem%ld%@", _nombActividad, (long)_semestre, _tipoActividad];
    _lbTitulo.text = _nombActividad;
    _lbTipo.text = _tipoActividad;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(genericSegue)];
    
    //Get the documents directory path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    /*
     AQUI DEBERIA RECIBIR LA MATRICULA DEL ALUMNO PARA QUE SEA UNICA PARA EL
     NSString pathString = _matricula + .plist
     */
    
    path = [documentsDirectory stringByAppendingPathComponent:@"matricula.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) {
        path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"matricula.plist"] ];
    }
    
    if ([fileManager fileExistsAtPath: path]) {
        data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    }
    else {
        // If the file doesn’t exist, create an empty dictionary
        data = [[NSMutableDictionary alloc] init];
    }
    
    //Cargar Valores
    [self iniValores];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self iniValores];
}

- (void)iniValores
{
    NSMutableDictionary *savedValue;
    
    //Inicializar Duracion
    _value = [NSString stringWithFormat:@"%@Sem%ldDur%@", _nombActividad, (long)_semestre, _tipoActividad];
    savedValue = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    if ([savedValue objectForKey:_value])
        _tvDuracion.text = [savedValue objectForKey:_value];
    
    //Inicializar Meta
    _value = [NSString stringWithFormat:@"%@Sem%ldMet%@", _nombActividad, (long)_semestre, _tipoActividad];
    savedValue = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    if ([savedValue objectForKey:_value])
        _tvMeta.text = [savedValue objectForKey:_value];
    
    //Inicializar Descripcion
    _value = [NSString stringWithFormat:@"%@Sem%ldDes%@", _nombActividad, (long)_semestre, _tipoActividad];
    savedValue = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    if ([savedValue objectForKey:_value])
        _tvDescripcion.text = [savedValue objectForKey:_value];
    
    //Inicializar Indicador
    _value = [NSString stringWithFormat:@"%@Sem%ldInd%@", _nombActividad, (long)_semestre, _tipoActividad];
    savedValue = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    if ([savedValue objectForKey:_value])
        _tvIndicador.text = [savedValue objectForKey:_value];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Editar"]) {
        PVCDetailEditViewController *pvcde = [segue destinationViewController];
        pvcde.nombActividad = _nombActividad;
        pvcde.tipoActividad = _tipoActividad;
        pvcde.semestre = _semestre;
    }
}

#pragma mark - Navigation
- (void)genericSegue
{
    [self performSegueWithIdentifier:@"Editar" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end