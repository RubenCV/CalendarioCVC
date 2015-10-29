//
//  TipsCurriculumViewController.m
//  CeldasMedida
//
//  Created by Gilberto on 10/29/15.
//  Copyright (c) 2015 A00814298. All rights reserved.
//

#import "TipsCurriculumViewController.h"

@interface TipsCurriculumViewController ()

@end

@implementation TipsCurriculumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Georgia" size:20.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    self.lTitulo.alpha = 0.0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.lTitulo cache:YES];
    self.lTitulo.alpha = 1.0;
    [UIView commitAnimations];
    
    self.seg.alpha = 0.0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.seg cache:YES];
    self.seg.alpha = 1.0;
    [UIView commitAnimations];
    
    self.texto.alpha = 0.0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.texto cache:YES];
    self.texto.alpha = 1.0;
    [UIView commitAnimations];
    
    self.barra.alpha = 0.0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.barra cache:YES];
    self.barra.alpha = 1.0;
    [UIView commitAnimations];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)seccion:(id)sender {
    if (self.seg.selectedSegmentIndex == 0) {
        self.texto.text = @"+ Datos personales completos y actualizados\n\n+ La formacion Academica se anexa a partir de la carrera profesional.\n\n+ Revisar la ortografia y redaccion.";
        self.texto.textColor = [UIColor colorWithRed: 150.0/255 green:143.0/255 blue:151.0/255 alpha:1.0];
        self.texto.font = [UIFont fontWithName:@"Georgia-Italic" size:25.0];
    }
    if (self.seg.selectedSegmentIndex == 1) {
        self.texto.text = @"+ Destaca tu experiencia (Universitaria, Profesional, Actividades Extracurriculares, Proyectos Academicos, Servicio social u otros).\n\n+ Incluye logros obtenidos durante tu experiencia universitaria.\n\n+ Manejo de idiomas (puntaje TOEFL u otro idioma, Grado de conocimiento escrito, oral y/o hablado.)\n\n+ Grado o nivel de conocimiento de programas computacionales.\n\n+ Habilidaddes personales / Competencias";
        self.texto.textColor = [UIColor colorWithRed: 150.0/255 green:143.0/255 blue:151.0/255 alpha:1.0];
        self.texto.font = [UIFont fontWithName:@"Georgia-Italic" size:25.0];
    }
    self.texto.alpha = 0.0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.texto cache:YES];
    self.texto.alpha = 1.0;
    [UIView commitAnimations];
}
@end
