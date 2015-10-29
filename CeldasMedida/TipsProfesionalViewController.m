//
//  TipsProfesionalViewController.m
//  CeldasMedida
//
//  Created by Gilberto on 10/29/15.
//  Copyright (c) 2015 A00814298. All rights reserved.
//

#import "TipsProfesionalViewController.h"

@interface TipsProfesionalViewController ()

@end

@implementation TipsProfesionalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Georgia" size:15.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
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
        self.texto.text = @"+ Va mas alla de un conocimiento tecnico.\n\n+ Se relaciona con la pulcritud.\n\n+ Es un reflejo cuidadoso de vestimenta e higiene personal.\n\n+ Educacion y buena cultura general.";
        self.texto.textColor = [UIColor colorWithRed: 150.0/255 green:143.0/255 blue:151.0/255 alpha:1.0];
        self.texto.font = [UIFont fontWithName:@"Georgia-Italic" size:25.0];
    }
    if (self.seg.selectedSegmentIndex == 1) {
        self.texto.text = @"Factores que integran tu imagen:\n\n+ Comunicacion\n\n+ Apariencia\n\n+ Comportamiento";
        self.texto.textColor = [UIColor colorWithRed: 150.0/255 green:143.0/255 blue:151.0/255 alpha:1.0];
        self.texto.font = [UIFont fontWithName:@"Georgia-Italic" size:25.0];
    }
    if (self.seg.selectedSegmentIndex == 2) {
        self.texto.text = @"+ Seriedad\n\n+ Honestidad\n\n+ Capacidad Profesional";
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
