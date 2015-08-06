//
//  PVCViewController.m
//  App CVC
//
//  Created by Jose Kovacevich on 4/8/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

#import "PVCViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface PVCViewController ()

@end

@implementation PVCViewController

NSArray *buttons;
NSMutableArray *botonesBorrar;

bool editarActividadActivado;

NSInteger pageCount;
NSMutableArray *pageViews;
NSMutableArray *semesterPages;

NSInteger semestres;
NSInteger numeroSemestre = 1;
NSInteger paginasBotones = 3;

NSMutableArray *actividadesSemestre; //Array de actividades, el index representa el semestre, cada objeto será un array de actividades

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Cosas relacionadas a la edicion de actividades
    botonesBorrar = [[NSMutableArray alloc] init];
    editarActividadActivado = NO;
    
    //Se registra la notificación para la persistencia
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aplicacionBackground:) name:UIApplicationDidEnterBackgroundNotification object:app];
    
    //Se establecen colores y cosas así
    /*[self.btnEliminar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnAgregar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.labelSemestre setTextColor:[UIColor whiteColor]];
    [self.labelTitulo setTextColor:[UIColor whiteColor]];*/
    
    //Se cargan las actividades
    [self cargarArchivo];
    
    semestres = actividadesSemestre.count;
    
    self.title = @"Plan de Vida y Carrera";
    // Do any additional setup after loading the view.
    
    //Propiedades de los scrollviews
    self.scrollView.delegate = self;
    self.semestreScrollView.delegate = self;
    
    self.semestreScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    //Se inicializan los botones
    [self inicializacionBotones];
    
    pageCount = paginasBotones;
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = pageCount;
    
    pageViews = [[NSMutableArray alloc] init];
    semesterPages = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < pageCount; i++) {
        [pageViews addObject:[NSNull null]];
    }
    
    for (NSInteger i = 0; i < semestres; i++) {
        [semesterPages addObject:[NSNull null]];
    }
}

- (void) inicializacionBotones {
    //Definicion de los botones - Cambiar los placeholders segun se requiera e identificarlo usando tags (del 1 al 11 para cada funcion)
    UIButton *boton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [boton1 setBackgroundImage:[UIImage imageNamed:@"147.png"] forState:UIControlStateNormal];
    boton1.tag = 1;
    [boton1 addTarget:self action:@selector(agregarActividadNueva:) forControlEvents:UIControlEventTouchUpInside];
    [boton1 setTitle:@"1-4-7" forState:UIControlStateNormal];
    [boton1.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [boton1 setTitleEdgeInsets:UIEdgeInsetsMake(65, 0, 0, 0)];
    
    UIButton *boton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [boton2 setBackgroundImage:[UIImage imageNamed:@"modalidad.png"] forState:UIControlStateNormal];
    boton2.tag = 2;
    [boton2 addTarget:self action:@selector(agregarActividadNueva:) forControlEvents:UIControlEventTouchUpInside];
    [boton2 setTitle:@"Modalidad" forState:UIControlStateNormal];
    [boton2.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [boton2 setTitleEdgeInsets:UIEdgeInsetsMake(65, 0, 0, 0)];
    
    UIButton *boton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [boton3 setBackgroundImage:[UIImage imageNamed:@"concentracion.png"] forState:UIControlStateNormal];
    boton3.tag = 3;
    [boton3 addTarget:self action:@selector(agregarActividadNueva:) forControlEvents:UIControlEventTouchUpInside];
    [boton3 setTitle:@"Conc." forState:UIControlStateNormal];
    [boton3.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [boton3 setTitleEdgeInsets:UIEdgeInsetsMake(65, 0, 0, 0)];
    
    UIButton *boton4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [boton4 setBackgroundImage:[UIImage imageNamed:@"deportivas.png"] forState:UIControlStateNormal];
    boton4.tag = 4;
    [boton4 addTarget:self action:@selector(agregarActividadNueva:) forControlEvents:UIControlEventTouchUpInside];
    [boton4 setTitle:@"Deportes" forState:UIControlStateNormal];
    [boton4.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [boton4 setTitleEdgeInsets:UIEdgeInsetsMake(65, 0, 0, 0)];
    
    UIButton *boton5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [boton5 setBackgroundImage:[UIImage imageNamed:@"culturales.png"] forState:UIControlStateNormal];
    boton5.tag = 5;
    [boton5 addTarget:self action:@selector(agregarActividadNueva:) forControlEvents:UIControlEventTouchUpInside];
    [boton5 setTitle:@"Culturales" forState:UIControlStateNormal];
    [boton5.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [boton5 setTitleEdgeInsets:UIEdgeInsetsMake(65, 0, 0, 0)];
    
    UIButton *boton6 = [UIButton buttonWithType:UIButtonTypeCustom];
    [boton6 setBackgroundImage:[UIImage imageNamed:@"estudiantiles.png"] forState:UIControlStateNormal];
    boton6.tag = 6;
    [boton6 addTarget:self action:@selector(agregarActividadNueva:) forControlEvents:UIControlEventTouchUpInside];
    [boton6 setTitle:@"Estudiantil" forState:UIControlStateNormal];
    [boton6.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [boton6 setTitleEdgeInsets:UIEdgeInsetsMake(65, 0, 0, 0)];
    
    UIButton *boton7 = [UIButton buttonWithType:UIButtonTypeCustom];
    [boton7 setBackgroundImage:[UIImage imageNamed:@"idiomas.png"] forState:UIControlStateNormal];
    boton7.tag = 7;
    [boton7 addTarget:self action:@selector(agregarActividadNueva:) forControlEvents:UIControlEventTouchUpInside];
    [boton7 setTitle:@"Idiomas" forState:UIControlStateNormal];
    [boton7.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [boton7 setTitleEdgeInsets:UIEdgeInsetsMake(65, 0, 0, 0)];
    
    UIButton *boton8 = [UIButton buttonWithType:UIButtonTypeCustom];
    [boton8 setBackgroundImage:[UIImage imageNamed:@"pi.png"] forState:UIControlStateNormal];
    boton8.tag = 8;
    [boton8 addTarget:self action:@selector(agregarActividadNueva:) forControlEvents:UIControlEventTouchUpInside];
    [boton8 setTitle:@"P.I." forState:UIControlStateNormal];
    [boton8.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [boton8 setTitleEdgeInsets:UIEdgeInsetsMake(65, 0, 0, 0)];
    
    UIButton *boton9 = [UIButton buttonWithType:UIButtonTypeCustom];
    [boton9 setBackgroundImage:[UIImage imageNamed:@"ssc.png"] forState:UIControlStateNormal];
    boton9.tag = 9;
    [boton9 addTarget:self action:@selector(agregarActividadNueva:) forControlEvents:UIControlEventTouchUpInside];
    [boton9 setTitle:@"SSC" forState:UIControlStateNormal];
    [boton9.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [boton9 setTitleEdgeInsets:UIEdgeInsetsMake(65, 0, 0, 0)];
    
    UIButton *boton10 = [UIButton buttonWithType:UIButtonTypeCustom];
    [boton10 setBackgroundImage:[UIImage imageNamed:@"ssp.png"] forState:UIControlStateNormal];
    boton10.tag = 10;
    [boton10 addTarget:self action:@selector(agregarActividadNueva:) forControlEvents:UIControlEventTouchUpInside];
    [boton10 setTitle:@"SSP" forState:UIControlStateNormal];
    [boton10.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [boton10 setTitleEdgeInsets:UIEdgeInsetsMake(65, 0, 0, 0)];
    
    UIButton *boton11 = [UIButton buttonWithType:UIButtonTypeCustom];
    [boton11 setBackgroundImage:[UIImage imageNamed:@"rg.png"] forState:UIControlStateNormal];
    boton11.tag = 11;
    [boton11 addTarget:self action:@selector(agregarActividadNueva:) forControlEvents:UIControlEventTouchUpInside];
    [boton11 setTitle:@"Grad." forState:UIControlStateNormal];
    [boton11.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [boton11 setTitleEdgeInsets:UIEdgeInsetsMake(65, 0, 0, 0)];
    
    //Arreglo de los botones de la barra inferior
    buttons = [[NSArray alloc] initWithObjects:boton1, boton2, boton3, boton4, boton5, boton6, boton7, boton8, boton9, boton10, boton11, nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    CGSize semestrePageScrollViewSize = self.semestreScrollView.frame.size;
    
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * paginasBotones, pagesScrollViewSize.height);
    self.semestreScrollView.contentSize = CGSizeMake(semestrePageScrollViewSize.width * semestres, semestrePageScrollViewSize.height); //Linea para prueba
    
    [self loadVisibleButtonPages];
    [self loadVisibleSemesterPages];
}

- (void)loadVisibleSemesterPages {
    
    if (semestres <= 9 || self.labelSemestre.text.integerValue < semestres) {
        self.btnEliminar.enabled = NO;
        self.btnEliminar.hidden = YES;
    }
    else {
        self.btnEliminar.enabled = YES;
        self.btnEliminar.hidden = NO;
    }
    
    CGFloat anchoSemestre = self.semestreScrollView.frame.size.width;
    NSInteger semestreActual = (NSInteger)floor((self.semestreScrollView.contentOffset.x * 2.0f + anchoSemestre) / (anchoSemestre * 2.0f));
    
    NSInteger semestreAnterior = semestreActual - 1;
    NSInteger semestreSiguiente = semestreActual + 1;
    
    for (NSInteger i = 0; i < semestreAnterior; i++) {
        [self purgeSemesterPage:i];
    }
    
    for (NSInteger i = semestreAnterior; i <= semestreSiguiente; i++) {
        [self loadSemesterPages:i];
    }
    
    for (NSInteger i = semestreSiguiente + 1; i < semestres; i++) {
        [self purgeSemesterPage:i];
    }
}

- (void)loadVisibleButtonPages {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    CGFloat anchoSemestre = self.semestreScrollView.frame.size.width;
    NSInteger semestreActual = (NSInteger)floor((self.semestreScrollView.contentOffset.x * 2.0f + anchoSemestre) / (anchoSemestre * 2.0f));
    
    self.pageControl.currentPage = page;
    self.labelSemestre.text = [NSString stringWithFormat:@"%ld", ((long)semestreActual + 1)];
    
    if (semestreActual + 1 > 9) {
        self.btnEliminar.enabled = YES;
    }
    else {
        self.btnEliminar.enabled = NO;
    }
    
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    for (NSInteger i = 0; i < firstPage; i++) {
        [self purgeButtonsPage:i];
    }
    
    for (NSInteger i = firstPage; i <= lastPage; i++) {
        [self loadButtonsPage:i];
    }
    
    for (NSInteger i = lastPage + 1; i < paginasBotones; i++) {
        [self purgeButtonsPage:i];
    }
}

- (void)purgeSemesterPage:(NSInteger)page {
    
    if (page < 0 || page >= semestres) {
        return;
    }
    
    UIView *pageView = [semesterPages objectAtIndex:page];
    
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [semesterPages replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

- (void)purgeButtonsPage:(NSInteger)page {
    
    if (page < 0 || page >= paginasBotones) {
        return;
    }
    
    UIView *pageView = [pageViews objectAtIndex:page];
    
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

- (void)loadButtonsPage:(NSInteger)page {
    if (page < 0 || page >= paginasBotones) {
        return;
    }
    
    UIView *pageView = [pageViews objectAtIndex:page];
    
    if ((NSNull*)pageView == [NSNull null]) {
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        UIView *newView = [[UIView alloc] initWithFrame:frame];
        
        //newView.backgroundColor = [UIColor grayColor]; //Cambiar el color, un gris claro podría ser... se deja para después
        
        //TODO: encontrar una forma de determinar los indices de los botones de la pag actual
        //Formula matemática?
        
        //botones de la primera pagina
        if (page == 0) {
            UIButton *button1 = [buttons objectAtIndex:0];
            UIButton *button2 = [buttons objectAtIndex:1];
            UIButton *button3 = [buttons objectAtIndex:2];
            UIButton *button4 = [buttons objectAtIndex:3];
            
            button1.frame = CGRectMake(15,10, 50, 50);
            button2.frame = CGRectMake(95,10, 50, 50);
            button3.frame = CGRectMake(175,10, 50, 50);
            button4.frame = CGRectMake(255,10, 50, 50);
            
            [newView addSubview:button1];
            [newView addSubview:button2];
            [newView addSubview:button3];
            [newView addSubview:button4];
            
        }
        //botones de la segunda pagina
        else if (page == 1) {
            UIButton *button1 = [buttons objectAtIndex:4];
            UIButton *button2 = [buttons objectAtIndex:5];
            UIButton *button3 = [buttons objectAtIndex:6];
            UIButton *button4 = [buttons objectAtIndex:7];
            
            button1.frame = CGRectMake(15,10, 50, 50);
            button2.frame = CGRectMake(95,10, 50, 50);
            button3.frame = CGRectMake(175,10, 50, 50);
            button4.frame = CGRectMake(255,10, 50, 50);
            
            [newView addSubview:button1];
            [newView addSubview:button2];
            [newView addSubview:button3];
            [newView addSubview:button4];
            
        }
        else if (page == 2) {
            //TODO: agregar botones y cambiar sus posiciones, solo son 3 en esta view
            UIButton *button1 = [buttons objectAtIndex:8];
            UIButton *button2 = [buttons objectAtIndex:9];
            UIButton *button3 = [buttons objectAtIndex:10];;
            
            button1.frame = CGRectMake(54,10, 50, 50);
            button2.frame = CGRectMake(137,10, 50, 50);
            button3.frame = CGRectMake(216,10, 50, 50);
            
            [newView addSubview:button1];
            [newView addSubview:button2];
            [newView addSubview:button3];
            
        }
        
        [_scrollView addSubview:newView];
        [pageViews replaceObjectAtIndex:page withObject:newView];
    }
}

- (void)loadSemesterPages:(NSInteger)page {
    if (page < 0 || page >= semestres) {
        return;
    }
    
    UIView *pageView = [semesterPages objectAtIndex:page];
    
    if ((NSNull*)pageView == [NSNull null]) {
        //CGRect frame = self.semestreScrollView.bounds;
        CGRect frame;
        frame.size.width = self.semestreScrollView.bounds.size.width;
        frame.size.height = self.semestreScrollView.bounds.size.height;
        
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        
        
        //self.labelSemestre.text = [NSString stringWithFormat:@"%ld", (long)page];
        
        UIScrollView *newView = [[UIScrollView alloc] initWithFrame:frame];
        newView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        
        //Se agregan las actividades a cada semestre
        [self agregarActividadesExistentes:newView pageNo:page];
        
        [_semestreScrollView addSubview:newView];
        [semesterPages replaceObjectAtIndex:page withObject:newView];
    }
}

- (IBAction)agregarSemestre:(id)sender {
    //Se agrega un nuevo semestre al arreglo
    NSMutableArray *semestreNuevo = [[NSMutableArray alloc] init];
    [actividadesSemestre addObject:semestreNuevo];
    
    semestres++;
    CGFloat anchoSemestre = self.semestreScrollView.frame.size.width;
    
    //Se redibuja el la view
    CGSize tamanoActual = self.semestreScrollView.contentSize;
    tamanoActual.width += self.semestreScrollView.frame.size.width;
    
    self.semestreScrollView.contentSize = tamanoActual;
    
    [semesterPages addObject:[NSNull null]];
    
    [self loadVisibleSemesterPages];
    
    //Offset del contenido para el semestre (beta)
    [self.semestreScrollView setContentOffset:CGPointMake(((semestres - 1) * anchoSemestre), 0) animated:YES];
}

- (IBAction)eliminarSemestre:(id)sender {
    //Se muestra confirmacion
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"¿Eliminar?" message:@"¿Estas seguro que deseas borrar el semestre actual?" delegate:self cancelButtonTitle: @"Cancelar" otherButtonTitles:@"Eliminar", nil];
    
    alert.tag = 999;
    [alert show];
}

- (IBAction)eliminarActividad:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"¿Eliminar?" message:@"¿Estas seguro que deseas borrar la actividad seleccionada?" delegate:self cancelButtonTitle: @"Cancelar" otherButtonTitles:@"Eliminar", nil];
    
    alert.tag = sender.tag + 1000;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    //Para poder utilizar los tags para identificar las actividades con las cuales trabajar
    //se crean diferentes rangos de tags
    //
    //Tags 1 - 998: actividades a agregar
    //Tag 999 reservedao para eliminar el semestre actual
    //Tags > 1000 actividades a eliminar
    
    //Identificador del alert para las actividades a agregar
    if (alertView.tag < 998) {
        if (buttonIndex == 1) {
            //Semestre al cual guardar
            NSInteger semestreActual = [self.labelSemestre.text integerValue] - 1;
            NSMutableArray *actividades = [actividadesSemestre objectAtIndex:semestreActual];
        
            //Tamanño del texto (para validar que se haya escrito algo
            NSInteger tamanoTexto = [[alertView textFieldAtIndex:0].text length];
            
            if (tamanoTexto == 0) {
                UIAlertView *alertaErrorActividad = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No se han ingresado los datos solicitados." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Aceptar", nil];
                
                [alertaErrorActividad show];
            }
            else {
            
                NSString *nombreActividad;
                NSString *descripcionActividad;
                NSString *prefijo = @"";
        
                //Se determina el titulo en base al tag (si, es codigo repetitivo)
                switch (alertView.tag) {
                    case 1:
                        nombreActividad = @"Programa 1-4-7";
                        prefijo = @"Taller ";
                        break;
                    case 2:
                        nombreActividad = @"Modalidad";
                        prefijo = @"Modalidad ";
                        break;
                    case 3:
                        nombreActividad = @"Concentración";
                        break;
                    case 4:
                        nombreActividad = @"Actividad Deportiva";
                        break;
                    case 5:
                        nombreActividad = @"Actividad Cultural";
                        break;
                    case 6:
                        nombreActividad = @"Actividad Estudiantil";
                        break;
                    case 7:
                        nombreActividad = @"Idioma";
                        break;
                    case 8:
                        nombreActividad = @"Programa de Intercambio";
                        break;
                    case 9:
                        nombreActividad = @"Servicio Social Ciudadano";
                        break;
                    case 10:
                        nombreActividad = @"Servicio Social Profesional";
                        break;
                    case 11:
                        nombreActividad = @"Requisito de Graduación";
                        break;
                }
        
                descripcionActividad = [prefijo stringByAppendingString:[alertView textFieldAtIndex:0].text];
            
                NSString *tipo = [[NSString alloc] initWithFormat:@"%ld", (long)alertView.tag];
            
                //Se crea el objeto con los detalles
                NSDictionary *nuevaActividad = [[NSDictionary alloc] initWithObjectsAndKeys:nombreActividad, @"nombre", descripcionActividad, @"descripcion", tipo, @"tipoActividad", nil];
        
                [actividades addObject:nuevaActividad];
        
                [actividadesSemestre replaceObjectAtIndex:semestreActual withObject:actividades];
        
                //Se redibuja para apreciar el cambio (?)
                [self refreshPage:semestreActual];
            }
        }
    }
    
    //Identificador del alert para semestres
    else if (alertView.tag == 999) {
        if (buttonIndex == 1){
            //Se elimina del arreglo
            NSInteger semestreEliminar = [self.labelSemestre.text integerValue] - 1;
            [self purgeSemesterPage:semestreEliminar];
            
            semestres--;
            
            [semesterPages removeObjectAtIndex:semestreEliminar];
            [actividadesSemestre removeObjectAtIndex:semestreEliminar];
            
            //Se redibuja la view
            CGSize tamanoActual = self.semestreScrollView.contentSize;
            tamanoActual.width -= self.semestreScrollView.frame.size.width;
            
            self.semestreScrollView.contentSize = tamanoActual;
            
            [self recargarPVC];
        }
    }
    
    //Identificador para navegacion rapida
    else if (alertView.tag == 998) {
        if (buttonIndex == 1) {
            NSInteger semestreMostrar = [[alertView textFieldAtIndex:0].text integerValue];
            
            if (semestreMostrar > 0 && semestreMostrar <= semestres) {
                CGFloat anchoSemestre = self.semestreScrollView.frame.size.width;
                
                [self.semestreScrollView setContentOffset:CGPointMake(((semestreMostrar - 1) * anchoSemestre), 0) animated:YES];
            }
            else {
                UIAlertView *errorNav = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Semestre no válido" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Aceptar", nil];
                
                [errorNav show];
            }
        }
    }
    
    //Identificador del alert para actividades tag = actividad a borrar
    //Hay que restarle 1000 al tag
    else {
        if (buttonIndex == 1){
            NSInteger semestreActual = [self.labelSemestre.text integerValue] - 1;
            NSInteger actividadActual = alertView.tag - 1000;
            
            //Se elimina del arreglo
            NSMutableArray *actividadesSemestreActual = [actividadesSemestre objectAtIndex:semestreActual];
            [actividadesSemestreActual removeObjectAtIndex:actividadActual];
            [botonesBorrar removeLastObject];
            
            [actividadesSemestre replaceObjectAtIndex:semestreActual withObject:actividadesSemestreActual];
            
            //Se redibuja la view
            [self recargarPVC];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self loadVisibleButtonPages];
    [self loadVisibleSemesterPages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)agregarActividadesExistentes:(UIScrollView *)view pageNo:(NSInteger)semester {
    //Se va a encargar de obtener las actividades guardadas y ponerlas en el scrollview de cada semestre

    //Propiedades de las actividades
    NSInteger posX = 20;
    NSInteger posY = 20;
    NSInteger ancho = 280;
    NSInteger alto = 60; //Por default estaba en 50, valores para experimentar
    
    //Para fines de prueba, deberá de cargar las activiades de una base de datos o plist
    NSArray *actividades = [actividadesSemestre objectAtIndex:semester];
    NSInteger cantActividades = actividades.count;
    NSInteger altoView = 0;
    
    //Se determina el tamaño del ScrollView donde se desplegarán
    //NSInteger pagActividades = ceil(cantActividades / 5.0);
    if (cantActividades > 4) {
        altoView = (cantActividades - 4) * 80; //90 pts el tamaño por actividad
    }
    view.contentSize = CGSizeMake(view.frame.size.width, view.frame.size.height + altoView);
    
    //view.backgroundColor = [UIColor greenColor]; //Para fines de visualización de prueba, cambiar acorde al diseño

    //Se crean views para cada actividad
    for (NSInteger i = 0; i < cantActividades; i++) {
        CGRect actividad;
        actividad.size.width = ancho;
        actividad.size.height = alto;
    
        actividad.origin.x = posX;
        actividad.origin.y = posY;
    
        UIView *viewActividad = [[UIView alloc] initWithFrame:actividad];
        //viewActividad.backgroundColor = [UIColor colorWithRed:(214.0/255) green:(214.0/255) blue:(214.0/255) alpha:1];
        viewActividad.backgroundColor = [UIColor colorWithRed:(109.0/255) green:(218.0/255) blue:(255.0/255) alpha:1];
        
        NSDictionary *datosActividad = [actividades objectAtIndex:i];
        
        //Se crean titulos, subtitulos y se agrega la imagen correspondiente a la actividad
        //Imagen
        NSString *nombreImagen = [datosActividad objectForKey:@"tipoActividad"];
        nombreImagen = [nombreImagen stringByAppendingString:@"act.png"];
        UIImageView *thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 50, 50)];;
        thumbnail.image = [UIImage imageNamed:nombreImagen];
        
        //Titulo
        UILabel *tituloActividad = [[UILabel alloc] initWithFrame:CGRectMake(75, 3, 200, 18)];
        tituloActividad.font = [UIFont boldSystemFontOfSize:18];
        tituloActividad.text = [datosActividad objectForKey:@"nombre"];//@"Titulo Actividad"; //Obtener este string del NSDictionary
        tituloActividad.adjustsFontSizeToFitWidth = YES;
        tituloActividad.textAlignment = NSTextAlignmentCenter;
        
        //Subtitulo
        UILabel *subtituloActividad = [[UILabel alloc] initWithFrame:CGRectMake(75, 20, 200, 35)];
        subtituloActividad.text = [datosActividad objectForKey:@"descripcion"];//@"Detalles de la actividad van a ir aquí, se pueden ocupar hasta 2 lineas"; //Obtener estos string del NSDictionary
        subtituloActividad.textAlignment = NSTextAlignmentCenter;
        subtituloActividad.adjustsFontSizeToFitWidth = YES;
        subtituloActividad.font = [UIFont systemFontOfSize:14];
        subtituloActividad.lineBreakMode = NSLineBreakByWordWrapping;
        subtituloActividad.numberOfLines = 0;
        
        //Se agrega a cada actividad su boton de eliminar
        UIButton *botonEliminar = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [botonEliminar setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        botonEliminar.tag = i;
        botonEliminar.hidden = YES;
        [botonEliminar addTarget:self action:@selector(eliminarActividad:) forControlEvents:UIControlEventTouchUpInside];

        botonEliminar.frame = CGRectMake(3,3, 8, 8);
        
        [botonesBorrar addObject:botonEliminar];
        
        //Se agregan los componentes a la view
        [viewActividad addSubview:botonEliminar];
        [viewActividad addSubview:thumbnail];
        [viewActividad addSubview:tituloActividad];
        [viewActividad addSubview:subtituloActividad];
        
        
        viewActividad.layer.cornerRadius = 5;
        viewActividad.layer.masksToBounds = YES;
    
        //Se agrega la actividad al view principal
        [view addSubview:viewActividad];

        posY = posY + alto + 20;
    }
}

- (void)refreshPage:(NSInteger) page {
    [self purgeSemesterPage:page];
    [self loadVisibleSemesterPages];
}

- (void) recargarPVC {
    
    for (NSInteger i = 0; i < semestres; i++) {
        [self purgeSemesterPage:i];
    }
    
    [self loadVisibleSemesterPages];
}

- (IBAction)agregarActividadNueva:(UIButton *)sender {
    //Identificar cada accion mediante el tag y definir el titulo/mensaje a mostrar
    NSInteger idActividad = sender.tag;
    NSString *mensajeActividad;
    NSString *tituloActividad;
    
    UIAlertView *alertaNuevaActividad = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Aceptar", nil];
    alertaNuevaActividad.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    switch (idActividad) {
        case 1:
            tituloActividad = @"¿Taller a Cursar?";
            mensajeActividad = @"Número del taller (1-4-7) a cursar";
            [alertaNuevaActividad textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 2:
            tituloActividad = @"¿Modalidad a Inscribir?";
            mensajeActividad = @"Nombre de la modalidad a inscribir";
            break;
        case 3:
            tituloActividad = @"¿Concentración a Inscribir?";
            mensajeActividad = @"Nombre de la concentración a inscribir";
            break;
        case 4:
            tituloActividad = @"¿Actividad Deportiva?";
            mensajeActividad = @"Actividad deportiva a participar";
            break;
        case 5:
            tituloActividad = @"¿Actividad Cultural?";
            mensajeActividad = @"Actividad cultural a participar";
            break;
        case 6:
            tituloActividad = @"¿Actividad Estudiantil?";
            mensajeActividad = @"Actividad estudiantil a participar";
            break;
        case 7:
            tituloActividad = @"¿Idioma a Cursar?";
            mensajeActividad = @"Nombre del idioma a cursar";
            break;
        case 8:
            tituloActividad = @"¿Programa de Intercambio?";
            mensajeActividad = @"Nombre del programa de intercambio de interés";
            break;
        case 9:
            tituloActividad = @"¿Servicio Social Ciudadano a Realizar?";
            mensajeActividad = @"Nombre de actividad de servicio social ciudadano a realizar";
            break;
        case 10:
            tituloActividad = @"¿Servicio Social Profesional a Realizar?";
            mensajeActividad = @"Nombre de actividad de servicio profesional ciudadano a realizar";
            break;
        case 11:
            tituloActividad = @"¿Requisitos de Graduación?";
            mensajeActividad = @"Nombre del requisito de graduación a cumplir";
            break;
    }
    
    alertaNuevaActividad.tag = idActividad;
    [alertaNuevaActividad setTitle:tituloActividad];
    [alertaNuevaActividad setMessage:mensajeActividad];
    [alertaNuevaActividad show];
}

- (void)cargarArchivo {
    
    //Se crea el path al archivo
    NSArray *paths = NSSearchPathForDirectoriesInDomains ( NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex: 0];
    
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"datos.plist"];
    
    //Si existe, se carga
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName])
    {
        //Se actualiza el array;
        actividadesSemestre = [[NSMutableArray alloc] initWithContentsOfFile:fileName];
    }
    //Si no, se crea un array en blanco con 9 semestres (default)
    else {
        actividadesSemestre = [[NSMutableArray alloc] init];
        for (NSInteger z = 0; z < 9; z++) {
            NSMutableArray *semestreInicial = [[NSMutableArray alloc] init];
            [actividadesSemestre addObject:semestreInicial];
        }
    }
}

- (void) guardarArchivo {
    //Se crea el path al archivo
    NSArray *paths = NSSearchPathForDirectoriesInDomains ( NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex: 0];
    
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"datos.plist"];
    
    //Se guarda el archivo
    [actividadesSemestre writeToFile:fileName atomically:YES];
}

- (void)aplicacionBackground:(NSNotification *)notification {
    [self guardarArchivo];
}

- (IBAction) handleLongPress: (UILongPressGestureRecognizer *) sender {
    NSInteger cantBotonesBorrar = [botonesBorrar count];
        
    for (NSInteger i = 0; i < cantBotonesBorrar; i++) {
        UIButton *actual = [botonesBorrar objectAtIndex:i];
            
        actual.hidden = NO;
            
        [botonesBorrar replaceObjectAtIndex:i withObject:actual];
    }
    
    editarActividadActivado = YES;
}

- (IBAction) handleSinglePress: (UITapGestureRecognizer *) sender {
    if (editarActividadActivado) {
        NSInteger cantBotonesBorrar = [botonesBorrar count];
        
        for (NSInteger i = 0; i < cantBotonesBorrar; i++) {
            UIButton *actual = [botonesBorrar objectAtIndex:i];
            
            actual.hidden = YES;
            
            [botonesBorrar replaceObjectAtIndex:i withObject:actual];
        }
        
        editarActividadActivado = NO;
    }
}

- (IBAction) handleDoublePress: (UITapGestureRecognizer *) sender {
    UIAlertView *alertaCambioSemestre = [[UIAlertView alloc] initWithTitle:@"Ir a Semestre" message:@"Semestre al cual navegar" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Aceptar", nil];
    
    alertaCambioSemestre.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    alertaCambioSemestre.tag = 998;
    
    [alertaCambioSemestre textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    
    [alertaCambioSemestre show];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController) {
        [self guardarArchivo];
    }
}

@end
