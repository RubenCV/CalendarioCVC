//
//  RedesViewController.m
//  CeldasMedida
//
//  Created by Ruben Cantu on 8/12/15.
//  Copyright (c) 2015 A00814298. All rights reserved.
//

#import "RedesViewController.h"

@interface RedesViewController ()

@end

@implementation RedesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Boton facebook
- (IBAction)facebook:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/cvcmonterrey"]];
}

// Boton google+
- (IBAction)google:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://plus.google.com/112361602358516849606/posts"]];
}

// Boton linkedin
- (IBAction)linkedin:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.linkedin.com/groups/ITESM-Centro-Vida-Carrera-3737527?mostPopular=&gid=3737527"]];
}

// Boton twitter
- (IBAction)twitter:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/CVC_Monterrey"]];
}

// Boton youtube
- (IBAction)youtube:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.youtube.com/user/TecnologicoMonterrey"]];
}

// Boton pagina tec campus mty
- (IBAction)tec:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://micampus.mty.itesm.mx/"]];
}

// Boton pagina cvc campus mty
- (IBAction)cvc:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://cvc.mty.itesm.mx/"]];
}
@end
