//
//  TipsEntrevistaViewController.m
//  CeldasMedida
//
//  Created by Gilberto on 10/28/15.
//  Copyright (c) 2015 A00814298. All rights reserved.
//

#import "TipsEntrevistaViewController.h"

@interface TipsEntrevistaViewController ()

@end

@implementation TipsEntrevistaViewController

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
        self.texto.text = @"+ Investiga a la empresa\n\n+ Anticipa preguntas (preparate para responder preguntas tipicas)\n\n+ Prepara tus respuestas.\n\n+ Prepara, actualiza y repasa tu curriculo.";
        self.texto.textColor = [UIColor colorWithRed: 150.0/255 green:143.0/255 blue:151.0/255 alpha:1.0];
        self.texto.font = [UIFont fontWithName:@"Georgia-Italic" size:25.0];
    }
    if (self.seg.selectedSegmentIndex == 1) {
        self.texto.text = @"+ Vestimenta formal.\n\n+ Asiste puntual a la entrevista.\n\n+ Apaga tu celular.\n\n+ Actitud / Comunicacion No verbal. (positivo, tranquilo, prudencia, seguridad, mira a los ojos, empatia).\n\n+ Evita interrupciones.\n\n+ Estructura tus ideas\n\n+ No seas inseguro ni caigas en ser demasiado jovinal.\n\n+ Sigue la pauta del entrevistador.\n\n+ Se honesto. No mientas por tratar de ser perfecto.\n\n+ Demuestra Interes por el trabajo.\n\n+ Finaliza la entrevista en forma grata (agradece).";
        self.texto.textColor = [UIColor colorWithRed: 150.0/255 green:143.0/255 blue:151.0/255 alpha:1.0];
        self.texto.font = [UIFont fontWithName:@"Georgia-Italic" size:25.0];
    }
    if (self.seg.selectedSegmentIndex == 2) {
        self.texto.text = @"+ Envia una nota de agradecimiento.\n\n+ Segumiento prudente al proceso de seleccion en el que te entrevistaron. No exagerar.";
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
