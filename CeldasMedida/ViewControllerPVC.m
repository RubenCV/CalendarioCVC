//
//  ViewControllerPVC.m
//  CVC
//
//  Created by Francisco Canseco on 25/03/15.
//  Copyright (c) 2015 Francisco Canseco. All rights reserved.
//

#import "ViewControllerPVC.h"
#import "ChartViewController.h"

BOOL bOrientacion = NO;

@interface celda : NSObject <NSCoding>
@property NSString* meta;
@property NSString* objetivo;
@property NSString* accion;
@property NSString* indicador;
@property NSDate* inicio;
@property NSDate* fin;
@property NSInteger prof;
@property NSInteger est;

@end
@implementation celda
-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.meta forKey:@"meta"];
    [encoder encodeObject:self.objetivo forKey:@"objetivo"];
    [encoder encodeObject:self.accion forKey:@"accion"];
    [encoder encodeObject:self.indicador forKey:@"indicador"];
    [encoder encodeObject:self.inicio forKey:@"inicio"];
    [encoder encodeObject:self.fin forKey:@"fin"];
    [encoder encodeInteger:self.prof forKey:@"prof"];
    [encoder encodeInteger:self.est forKey:@"est"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
        self.meta = [decoder decodeObjectForKey:@"meta"];
        self.objetivo = [decoder decodeObjectForKey:@"objetivo"];
        self.accion = [decoder decodeObjectForKey:@"accion"];
        self.indicador = [decoder decodeObjectForKey:@"indicador"];
        self.inicio= [decoder decodeObjectForKey:@"inicio"];
        self.fin= [decoder decodeObjectForKey:@"fin"];
        self.prof = [decoder decodeIntegerForKey:@"prof"];
       self.est = [decoder decodeIntegerForKey:@"est"];
    return self;
}
@end
@interface ViewControllerPVC ()
@property (strong,nonatomic) NSDate *fechaIn;
@property (strong,nonatomic) NSDate *fechaOut;
@property  NSInteger fech;
@property  NSInteger profesion;
@property NSMutableArray *celdas;
@property celda* celdaAux;
@property NSInteger state;
@property NSInteger order;
@property NSInteger estado;
@property NSInteger celdaEscogida;
@property NSInteger acomodo;
@property NSInteger vista;
@property NSInteger yCoord;
@end

@implementation ViewControllerPVC

#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
- (bool) shouldAutorotate {
    return TRUE;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeLeft]
                                forKey:@"orientation"];
    
    self.vista = 0;
    self.viewVista2.hidden = YES;
    
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillTerminate:)
     name:UIApplicationDidEnterBackgroundNotification object:app];
    self.uvAgrega.hidden = YES;
    self.uvDate.hidden = YES;
    self.celdas = [[NSMutableArray alloc] init];
    self.state = 0;
    self.btnEliminar.hidden = YES;
    self.infoCeldaOutlet.hidden = YES;
    self.acomodo=0;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"set"];
    self.celdas = [NSKeyedUnarchiver unarchiveObjectWithFile:appFile];
    if (self.celdas == nil){
        self.celdas = [[NSMutableArray alloc] init];
    }
    [self mostrar];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ChartViewController *viewControllerChart =[segue destinationViewController];
    NSInteger a,b,c,d,e;
    a=b=c=d=0;
    for (int i = 0; i < self.celdas.count ; i++){
        e = [self.celdas[i] prof];
        if (e==0){
            a++;
        }
        else{
            if (e==1){
                b++;
            }
            else{
                if (e==2){
                    c++;
                }
                else{
                    d++;
                }
            }
        }
    }
    viewControllerChart.profe = [NSNumber numberWithInteger:a];
    viewControllerChart.eco = [NSNumber numberWithInteger:b];
    viewControllerChart.pers = [NSNumber numberWithInteger:c];
    viewControllerChart.intel = [NSNumber numberWithInteger:d];
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)initialDate:(id)sender {
    self.uvDate.hidden = NO;
    [self.dtPicker setDate:self.fechaIn];
    [self.scroll bringSubviewToFront:self.uvDate];
    self.fech = 1;
}
- (IBAction)endDate:(id)sender {
    self.uvDate.hidden = NO;
    [self.scroll bringSubviewToFront:self.uvDate];
    [self.dtPicker setDate:self.fechaOut];
    self.fech = 2;
}
- (IBAction)cancelar:(id)sender {
    [self.scroll bringSubviewToFront:self.uvDate];
    self.uvAgrega.hidden = YES;
    self.uvDate.hidden = YES;
    if (self.state == 1&&self.uvAgrega.isHidden){
        self.state = 0;
        for (UIView *subview in self.scroll.subviews) {
            subview.alpha = 1;
        };
        
    }
    self.infoCeldaOutlet.hidden = YES;
    self.agregaOutlet.hidden = NO;
    self.btnEliminar.hidden = YES;
}
- (IBAction)guardar:(id)sender {
    if (self.state==0){
    self.celdaAux =[[celda alloc]init];
    self.celdaAux.prof = self.profesion;
    self.celdaAux.inicio = self.fechaIn;
    self.celdaAux.fin = self.fechaOut;
    self.celdaAux.meta = self.tfMeta.text;
    self.celdaAux.objetivo = self.tfObjetivo.text;
    self.celdaAux.accion = self.tvAccion.text;
    self.celdaAux.indicador = self.tvIndicador.text;
    self.celdaAux.est = self.estado;
    [self.celdas addObject:self.celdaAux];
    self.uvAgrega.hidden = YES;
    self.uvDate.hidden = YES;
    }
    else{
            self.celdaAux =[[celda alloc]init];
            self.celdaAux.prof = self.profesion;
            self.celdaAux.inicio = self.fechaIn;
            self.celdaAux.fin = self.fechaOut;
            self.celdaAux.meta = self.tfMeta.text;
            self.celdaAux.objetivo = self.tfObjetivo.text;
            self.celdaAux.accion = self.tvAccion.text;
            self.celdaAux.indicador = self.tvIndicador.text;
            self.celdaAux.est = self.estado;
            self.celdas[self.celdaEscogida] =self.celdaAux;
            self.uvAgrega.hidden = YES;
            self.uvDate.hidden = YES;
        if (self.state == 1&&self.uvAgrega.isHidden){
            self.state = 0;
            for (UIView *subview in self.scroll.subviews) {
                subview.alpha = 1;
            };
            
        }
        self.infoCeldaOutlet.hidden = YES;
        self.agregaOutlet.hidden = NO;
        self.btnEliminar.hidden = YES;
    }
    [self mostrar];
}
- (void)applicationWillTerminate:(UIApplication *)app
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"set"];
    [NSKeyedArchiver archiveRootObject:self.celdas toFile:appFile];
}
- (IBAction)agregar:(id)sender {
    if (self.state==0){
    self.tfMeta.text = @"";
    self.tfObjetivo.text = @"";
    self.tvAccion.text = @"";
    self.tvIndicador.text = @"";
    self.fechaIn =[NSDate date];
    self.fechaOut =[NSDate date];
    self.profesion = 0;
    self.estado = 0;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    self.lbFechaIn.text = [dateFormatter stringFromDate:[NSDate date]];
    self.lbFOut.text =  [dateFormatter stringFromDate:[NSDate date]];
    self.lbProfesion.text = @"Profesional";
    [self.btnprof setImage:[UIImage imageNamed:@"Briefcase.png"] forState:UIControlStateNormal];
    [self.btnEstadoOutlet setImage:[UIImage imageNamed:@"cancelButton.png"] forState:UIControlStateNormal];
    self.uvAgrega.hidden = NO;
    self.btnEliminar.hidden = YES;
    [self.scroll bringSubviewToFront:self.uvAgrega];
    }
}
- (IBAction)guardarFecha:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    if (self.fech == 1){
        self.fechaIn =self.dtPicker.date;
        self.lbFechaIn.text = [dateFormatter stringFromDate:self.dtPicker.date];
        if ([self.fechaIn compare: self.fechaOut]==NSOrderedDescending){
            self.fechaOut=self.fechaIn;
            self.lbFOut.text = [dateFormatter stringFromDate:self.dtPicker.date];
        }
    }
    else{
        self.fechaOut =self.dtPicker.date;
        self.lbFOut.text = [dateFormatter stringFromDate:self.dtPicker.date];
        if ([self.fechaIn compare: self.fechaOut]==NSOrderedDescending){
            self.fechaIn=self.fechaOut;
            self.lbFechaIn.text = [dateFormatter stringFromDate:self.dtPicker.date];
        }
    }
    self.fech = 0;
    self.uvDate.hidden = YES;
}
- (IBAction)btnProfesion:(id)sender {
    self.profesion = (self.profesion+1)%4;
    if (self.profesion == 0){
        [self.btnprof setImage:[UIImage imageNamed:@"Briefcase.png"] forState:UIControlStateNormal];
        self.lbProfesion.text = @"Profesional";
    }else{
        if (self.profesion == 1){
            [self.btnprof setImage:[UIImage imageNamed:@"oro.png"] forState:UIControlStateNormal];
            self.lbProfesion.text = @"Economico";
            
        }else{
            if (self.profesion == 2){
                [self.btnprof setImage:[UIImage imageNamed:@"peronal.png"] forState:UIControlStateNormal];
                self.lbProfesion.text = @"Personal";
                
            }else{
                [self.btnprof setImage:[UIImage imageNamed:@"brain.png"] forState:UIControlStateNormal];
                self.lbProfesion.text = @"Intelectual";
            }
        }
    }
}

-(void)acomodar{
    if (self.acomodo==0){
    NSSortDescriptor *fechin = [[NSSortDescriptor alloc] initWithKey:@"inicio" ascending:YES];
    NSSortDescriptor *fechter = [[NSSortDescriptor alloc] initWithKey:@"fin" ascending:YES];
    
    [self.celdas sortUsingDescriptors:[NSArray arrayWithObjects:fechin, fechter, nil]];
    }
    if (self.acomodo==1){
        NSSortDescriptor *prof = [[NSSortDescriptor alloc] initWithKey:@"prof" ascending:YES];
        [self.celdas sortUsingDescriptors:[NSArray arrayWithObjects:prof, nil]];
    }
    if (self.acomodo==2){
        NSSortDescriptor *estado = [[NSSortDescriptor alloc] initWithKey:@"est" ascending:YES];
        [self.celdas sortUsingDescriptors:[NSArray arrayWithObjects:estado, nil]];
    }
    if (self.acomodo==3){
        NSSortDescriptor *fechin = [[NSSortDescriptor alloc] initWithKey:@"inicio" ascending:NO];
        NSSortDescriptor *fechter = [[NSSortDescriptor alloc] initWithKey:@"fin" ascending:NO];
        
        [self.celdas sortUsingDescriptors:[NSArray arrayWithObjects:fechin, fechter, nil]];
    }
    if (self.acomodo==4){
        NSSortDescriptor *meta = [[NSSortDescriptor alloc] initWithKey:@"meta" ascending:YES];
        
        [self.celdas sortUsingDescriptors:[NSArray arrayWithObjects:meta, nil]];
    }
}
- (BOOL)isSameDay:(NSDate*)date1 otherDay:(NSDate*)date2 {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}
- (void)mostrar{
    [self acomodar];
    NSLocale *mxLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"es_MX"];

    NSDate* hoy = [NSDate date];
    for (UIView *subview in self.scroll.subviews) {
        if (subview != self.uvAgrega&& subview != self.uvDate&&subview!= self.infoCeldaOutlet.superview)
            [subview removeFromSuperview];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setLocale:mxLocale];
    NSUInteger i;
    int xCoord=0;
   self.yCoord=0;
    int buttonWidth=640;
    int buttonHeight=70;
    int buffer = 3;
    if (self.vista == 0){
        self.viewVista2.hidden=YES;
    for (i = 0; i < self.celdas.count; i++)
    {
        NSInteger p =[self.celdas[i] prof];
        NSInteger e = [self.celdas[i] est];
        UIButton *v = [[UIButton alloc]init];
        UILabel *lb1 = [[UILabel alloc]init];
        UILabel *lb2 = [[UILabel alloc]init];
        UILabel *lb3 = [[UILabel alloc]init];
        UIImage *img;
        UIImage *img2;

        UIView *v2 = [[UIView alloc]init];
        UIView *v3 = [[UIView alloc]init];
        lb1.text = [self.celdas[i] meta];
        lb2.text = [dateFormatter stringFromDate:[self.celdas[i] inicio]];
        lb3.text = [dateFormatter stringFromDate:[self.celdas[i] fin]];
        v2.frame =CGRectMake(xCoord+240+25, 0+10,50,50 );
        v3.frame =CGRectMake(xCoord+540+25, 0+10,50,50 );
        UIGraphicsBeginImageContext(v2.frame.size);
        if (p == 0){
            [[UIImage imageNamed:@"Briefcase.png"] drawInRect:v2.bounds];
        }else{
            if (p== 1){
                [[UIImage imageNamed:@"oro"] drawInRect:v2.bounds];
                
            }else{
                if (p == 2){
                    [[UIImage imageNamed:@"peronal.png"] drawInRect:v2.bounds];
                    
                }else{
                    [[UIImage imageNamed:@"brain.png"] drawInRect:v2.bounds];
                }
            }
        }
        
        [lb1 setNumberOfLines:0];
        [lb1 sizeToFit];
        [lb2 setNumberOfLines:0];
        [lb2 sizeToFit];
        [lb3 setNumberOfLines:0];
        [lb3 sizeToFit];
        lb1.frame =CGRectMake(xCoord, 0,240,buttonHeight );
        lb2.frame =CGRectMake(xCoord+340, 0,100,buttonHeight );
        lb3.frame =CGRectMake(xCoord+440, 0,100,buttonHeight );
        lb1.textAlignment = NSTextAlignmentCenter;
        lb2.textAlignment = NSTextAlignmentCenter;
        lb3.textAlignment = NSTextAlignmentCenter;
        [[UIImage imageNamed:@"image.png"] drawInRect:self.view.bounds];
        img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        v2.contentMode = UIViewContentModeScaleAspectFit;
        v2.backgroundColor = [UIColor colorWithPatternImage:img];
        UIGraphicsBeginImageContext(v3.frame.size);
        if (e == 0){
            [[UIImage imageNamed:@"cancelButton.png"] drawInRect:v3.bounds];
        }else{
            [[UIImage imageNamed:@"acceptButton.png"] drawInRect:v3.bounds];
        }
        img2 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        v3.contentMode = UIViewContentModeScaleAspectFit;
        v3.backgroundColor = [UIColor colorWithPatternImage:img2];
        [v addSubview:lb1];
        [v addSubview:lb2];
        [v addSubview:lb3];
        [v addSubview:v2];
        [v addSubview:v3];
        v.frame     = CGRectMake(xCoord,self. yCoord,buttonWidth,buttonHeight );
        if ([[self.celdas[i] fin] compare:hoy] == NSOrderedAscending) {
            v.backgroundColor = [UIColor colorWithRed:0.953 green:0.471 blue:0.443 alpha:.5];
        } else if ([[self.celdas[i] inicio] compare:hoy] == NSOrderedDescending) {
            v.backgroundColor =[UIColor colorWithRed:.8 green:.8 blue:0.263 alpha:.5];
            
        } else {
             v.backgroundColor = [UIColor colorWithRed:0.553 green:0.776 blue:0.251 alpha:.5];        }
        if ([self isSameDay:hoy otherDay:[self.celdas[i] fin]]){
            v.backgroundColor = [UIColor colorWithRed:0.553 green:0.776 blue:0.251 alpha:.5];
        }
        v.layer.cornerRadius = 15;
        [v addTarget:self action:@selector(checkButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [v setTag:i];
        [self.scroll addSubview:v];
        
        self.yCoord += buttonHeight + buffer;
    }
    }
    else{
        self.viewVista2.hidden=NO;

        for (i = 0; i < self.celdas.count; i++)
        {
            UILabel *lb1 = [[UILabel alloc]init];
            UILabel *lb2 = [[UILabel alloc]init];
            UILabel *lb3 = [[UILabel alloc]init];
            UIButton *v = [[UIButton alloc]init];
            lb1.text = [self.celdas[i] objetivo];
            lb2.text = [self.celdas[i] accion];
            lb3.text = [self.celdas[i] indicador];
            
            [lb1 setNumberOfLines:0];
            [lb1 sizeToFit];
            [lb2 setNumberOfLines:0];
            [lb2 sizeToFit];
            [lb3 setNumberOfLines:0];
            [lb3 sizeToFit];
            lb1.frame =CGRectMake(xCoord, 0,200,buttonHeight );
            lb2.frame =CGRectMake(xCoord+200, 0,220,buttonHeight );
            lb3.frame =CGRectMake(xCoord+420, 0,220,buttonHeight );
            lb1.textAlignment = NSTextAlignmentCenter;
            lb2.textAlignment = NSTextAlignmentCenter;
            lb3.textAlignment = NSTextAlignmentCenter;
            [v addSubview:lb1];
            [v addSubview:lb2];
            [v addSubview:lb3];
            v.frame     = CGRectMake(xCoord, self.yCoord,buttonWidth,buttonHeight );
            if ([[self.celdas[i] fin] compare:hoy] == NSOrderedAscending) {
                v.backgroundColor = [UIColor colorWithRed:0.953 green:0.471 blue:0.443 alpha:.5];
            } else if ([[self.celdas[i] inicio] compare:hoy] == NSOrderedDescending) {
                v.backgroundColor =[UIColor colorWithRed:.8 green:.8 blue:0.263 alpha:.5];
                
            } else {
                v.backgroundColor = [UIColor colorWithRed:0.553 green:0.776 blue:0.251 alpha:.5];        }
            if ([self isSameDay:hoy otherDay:[self.celdas[i] fin]]){
                v.backgroundColor = [UIColor colorWithRed:0.553 green:0.776 blue:0.251 alpha:.5];
            }
            v.layer.cornerRadius = 15;
            [v addTarget:self action:@selector(checkButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [v setTag:i];
            [self.scroll addSubview:v];
            
            self.yCoord += buttonHeight + buffer;
        }
    }
    [self.scroll setContentSize:CGSizeMake(640, self.yCoord)];
}
- (void)checkButtonTapped:(id)sender
{
    NSInteger t = [sender tag];
    self.state = 1;
    for (UIView *subview in self.scroll.subviews) {
        if (subview.tag == t){
            subview.alpha = 1;
            self.infoCeldaOutlet.hidden = NO;
            self.agregaOutlet.hidden = YES;
            self.celdaEscogida=t;
            self.btnEliminar.hidden = NO;
            CGPoint cgp;
            NSInteger nsi;
            nsi=subview.center.y-129;
            if (nsi<0){
                nsi = 0;
            }
            if (nsi>self.yCoord-258){
                nsi = self.yCoord-258;
            }
            cgp.y = nsi;
            [self.scroll setContentOffset:cgp animated:YES];
        }
        else{
            if (subview != self.uvAgrega&& subview != self.uvDate&&subview!= self.infoCeldaOutlet.superview){
                   subview.alpha = .5;
               }
        }
    }
    
}
-(IBAction)handleSingleTap:(UIGestureRecognizer*)sender
{
    if (self.state == 1&&self.uvAgrega.isHidden){
        self.state = 0;
        for (UIView *subview in self.scroll.subviews) {
            subview.alpha = 1;
        }
        [self cancelar:sender];
        
    }
    self.infoCeldaOutlet.hidden = YES;
    self.agregaOutlet.hidden = NO;
    self.btnEliminar.hidden = YES;
    [self.view endEditing:YES];
}
 
- (IBAction)infoCelda:(id)sender {
    CGPoint cgp;
    [self.scroll setContentOffset:cgp animated:YES];
    self.tfMeta.text = [self.celdas[self.celdaEscogida] meta];
    self.tfObjetivo.text = [self.celdas[self.celdaEscogida] objetivo];
    self.tvAccion.text = [self.celdas[self.celdaEscogida] accion];
    self.tvIndicador.text = [self.celdas[self.celdaEscogida] indicador];
    self.fechaIn =[self.celdas[self.celdaEscogida] inicio];
    self.fechaOut =[self.celdas[self.celdaEscogida] fin];
    self.profesion = [self.celdas[self.celdaEscogida] prof];
    self.estado = [self.celdas[self.celdaEscogida] est];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    self.lbFechaIn.text = [dateFormatter stringFromDate:[self.celdas[self.celdaEscogida] inicio]];
    self.lbFOut.text =  [dateFormatter stringFromDate:[self.celdas[self.celdaEscogida] fin]];
    if (self.profesion == 0){
        [self.btnprof setImage:[UIImage imageNamed:@"Briefcase.png"] forState:UIControlStateNormal];
        self.lbProfesion.text = @"Profesional";
    }else{
        if (self.profesion == 1){
            [self.btnprof setImage:[UIImage imageNamed:@"oro.png"] forState:UIControlStateNormal];
            self.lbProfesion.text = @"Economico";
            
        }else{
            if (self.profesion == 2){
                [self.btnprof setImage:[UIImage imageNamed:@"peronal.png"] forState:UIControlStateNormal];
                self.lbProfesion.text = @"Personal";
                
            }else{
                [self.btnprof setImage:[UIImage imageNamed:@"brain.png"] forState:UIControlStateNormal];
                self.lbProfesion.text = @"Intelectual";
            }
        }
    }
    if (self.estado == 0){
        [self.btnEstadoOutlet setImage:[UIImage imageNamed:@"cancelButton.png"] forState:UIControlStateNormal];
    }else{
        [self.btnEstadoOutlet setImage:[UIImage imageNamed:@"acceptButton.png"] forState:UIControlStateNormal];
    }
    self.uvAgrega.hidden = NO;
    [self.scroll bringSubviewToFront:self.uvAgrega];
    
}
- (IBAction)btnEstado:(id)sender {
    self.estado = (self.estado+1)%2;
    if (self.estado == 0){
        [self.btnEstadoOutlet setImage:[UIImage imageNamed:@"cancelButton.png"] forState:UIControlStateNormal];
    }else{
        [self.btnEstadoOutlet setImage:[UIImage imageNamed:@"acceptButton.png"] forState:UIControlStateNormal];
    }
}
- (IBAction)elimina:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alerta" message:@"Estas seguro que quieres eliminar este evento?" delegate:self cancelButtonTitle:@"Borrar" otherButtonTitles:@"Cancelar", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        [self.celdas removeObjectAtIndex:self.celdaEscogida];
        [self mostrar];
        if (self.state == 1&&self.uvAgrega.isHidden){
            self.state = 0;
            for (UIView *subview in self.scroll.subviews) {
                subview.alpha = 1;
            };
            
        }
        self.infoCeldaOutlet.hidden = YES;
        self.agregaOutlet.hidden = NO;
        self.btnEliminar.hidden = YES;
        self.uvAgrega.hidden = YES;
        self.uvDate.hidden=YES;
        
    }
}
- (IBAction)descripcionSinAccion:(id)sender {
}

- (IBAction)acomodarFecha:(id)sender {
    self.acomodo = 0;
    [self mostrar];
}
- (IBAction)acomodarArea:(id)sender {
    self.acomodo = 1;
    [self mostrar];
}

- (IBAction)acomodarStatus:(id)sender {
    self.acomodo = 2;
    [self mostrar];
}

- (IBAction)acomodoFin:(id)sender {
    self.acomodo = 3;
    [self mostrar];
}

- (IBAction)vistaSeg:(id)sender {
    self.vista = (self.vista +1 )%2;
    [self mostrar];
}

- (IBAction)chart:(id)sender {
}

- (IBAction)acomodarAlfabeticamente:(id)sender {
    self.acomodo = 4;
    [self mostrar];
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        bOrientacion = YES;
        [[UIDevice currentDevice] setValue:
         [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                    forKey:@"orientation"];
        bOrientacion = NO;
    }
    [super viewWillDisappear:animated];
}

#pragma GCC diagnostic warning "-Wdeprecated-declarations"
@end

@interface UINavigationController (Rotation_IOS6)
@end

@implementation UINavigationController (Rotation_IOS6)

-(BOOL)shouldAutorotate
{
    if([self.visibleViewController isMemberOfClass:NSClassFromString(@"ViewControllerPVC")])
    {
        return UIInterfaceOrientationMaskLandscape;
    }
    return bOrientacion;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [[self topViewController] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if([self.visibleViewController isMemberOfClass:NSClassFromString(@"ViewControllerPVC")])
    {
        return (UIInterfaceOrientation)UIInterfaceOrientationMaskLandscape;
    }
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

@end