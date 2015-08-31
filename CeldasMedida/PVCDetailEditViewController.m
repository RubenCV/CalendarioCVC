//
//  PVCDetailEditViewController.m
//  CeldasMedida
//
//  Created by Ruben Cantu on 8/30/15.
//  Copyright (c) 2015 A00814298. All rights reserved.
//

#import "PVCDetailEditViewController.h"
#import "PVCDetailViewController.h"

@interface PVCDetailEditViewController ()

@end

@implementation PVCDetailEditViewController

NSMutableDictionary *data;
NSString *path;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _lbTitulo.text = _nombActividad;
    _lbTipo.text = _tipoActividad;

    //Create ImageButton
    UIImage *saveBtnIcon = [UIImage imageNamed:@"Guardar.png"];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setFrame:CGRectMake(0, 0, saveBtnIcon.size.width*.80, saveBtnIcon.size.height*.80)];
    [saveButton setBackgroundImage:saveBtnIcon forState:UIControlStateNormal];
    
    [saveButton addTarget:self action:@selector(guardar) forControlEvents:UIControlEventTouchUpInside];
    
    //Create BarButton using ImageButton
    UIBarButtonItem *saveBarBtn = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    
    //Add BarButton to NavigationBar
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:saveBarBtn, nil];
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)iniValores
{
    NSMutableDictionary *savedValue;
    
    //Inicializar Duracion
    _value = [NSString stringWithFormat:@"%@Sem%ldDur", _nombActividad, (long)_semestre];
    savedValue = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    if ([savedValue objectForKey:_value])
        _tfDuracion.text = [savedValue objectForKey:_value];
    
    //Inicializar Meta
    _value = [NSString stringWithFormat:@"%@Sem%ldMet", _nombActividad, (long)_semestre];
    savedValue = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    if ([savedValue objectForKey:_value])
        _tfMeta.text = [savedValue objectForKey:_value];
    
    //Inicializar Descripcion
    _value = [NSString stringWithFormat:@"%@Sem%ldDes", _nombActividad, (long)_semestre];
    savedValue = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    if ([savedValue objectForKey:_value])
        _tvDescripcion.text = [savedValue objectForKey:_value];
    
    //Inicializar Indicador
    _value = [NSString stringWithFormat:@"%@Sem%ldInd", _nombActividad, (long)_semestre];
    savedValue = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    if ([savedValue objectForKey:_value])
        _tvIndicador.text = [savedValue objectForKey:_value];
}

- (void)guardar
{
    //Guardar Duracion
    _value = [NSString stringWithFormat:@"%@Sem%ldDur", _nombActividad, (long)_semestre];
    [data setObject: _tfDuracion.text forKey:_value];
    [data writeToFile:path atomically:YES];
    
    //Guardar Meta
    _value = [NSString stringWithFormat:@"%@Sem%ldMet", _nombActividad, (long)_semestre];
    [data setObject: _tfMeta.text forKey:_value];
    [data writeToFile:path atomically:YES];
    
    //Guardar Descripcion
    _value = [NSString stringWithFormat:@"%@Sem%ldDes", _nombActividad, (long)_semestre];
    [data setObject: _tvDescripcion.text forKey:_value];
    [data writeToFile:path atomically:YES];
    
    //Guardar Indicador
    _value = [NSString stringWithFormat:@"%@Sem%ldInd", _nombActividad, (long)_semestre];
    [data setObject: _tvIndicador.text forKey:_value];
    [data writeToFile:path atomically:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
