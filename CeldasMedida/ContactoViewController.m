//
//  ContactoViewController.m
//  CeldasMedida
//
//  Created by alumno on 4/14/15.
//  Copyright (c) 2015 A00814298. All rights reserved.
//

#import "ContactoViewController.h"

@interface ContactoViewController ()

@end

@implementation ContactoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.lbNombre.text = self.nom;
    self.lbArea.text = self.area;
    self.lbArea.numberOfLines = 0;
    self.lbEmail.text = self.email;
    self.lbTelefono.text = self.tel;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actMail:(id)sender {
    NSString *s = @"mailto:";
    s = [s stringByAppendingString:self.email];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:s]];
    
    NSLog(@"%@", s);
}

@end
