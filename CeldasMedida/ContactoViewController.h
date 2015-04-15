//
//  ContactoViewController.h
//  CeldasMedida
//
//  Created by alumno on 4/14/15.
//  Copyright (c) 2015 A00814298. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lbNombre;
@property (weak, nonatomic) IBOutlet UILabel *lbEmail;
@property (weak, nonatomic) IBOutlet UILabel *lbTelefono;

@property (weak, nonatomic) NSString *nom;
@property (weak, nonatomic) NSString *email;
@property (weak, nonatomic) NSString *tel;

- (IBAction)actMail:(id)sender;

@end
