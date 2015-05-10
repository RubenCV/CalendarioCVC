//
//  EventoViewController.m
//  CeldasMedida
//
//  Created by Ruben Cantu on 4/21/15.
//  Copyright (c) 2015 A00814298. All rights reserved.
//

#import "EventoViewController.h"
#import "NSString+HTML.h"
#import "GlobalCalendar.h"
#import <EventKit/EventKit.h>

@interface EventoViewController ()

@property (strong, nonatomic) NSString *emailString;

@end

GlobalCalendar *myCalendar;

@implementation EventoViewController

@synthesize dateString;
@synthesize dateStartString;
@synthesize dateEndString;
@synthesize summaryString;
@synthesize placeString;
@synthesize titleString;
@synthesize informesString;
@synthesize descriptionString;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Evento";
    myCalendar = [GlobalCalendar sharedSingleton];
    MWFeedItem *item = [[myCalendar itemsToDisplay] objectAtIndex:_eventIndex];
    
    // Default Values
    titleString = @"Evento CVC";
    dateString = @"Horario Pendiente.";
    placeString = @"ITESM";
    descriptionString = @"Descripcion Pendiente.";
    informesString = @"8358 2000 ext 3614\ncvc.mty@servicios.itesm.mx";
    _emailString = @"cvc.mty@servicios.itesm.mx";
    
    // Titulo
    if (item.title)
        titleString =  item.title;
    
    // Fecha
    if (item.summary)
    {
        NSString *haystack = [item.summary stringByConvertingHTMLToPlainText];
        NSString *prefix = @"Cuándo: ";
        NSString *suffix = @"CST";
        haystack = [haystack stringByReplacingOccurrencesOfString:@" de " withString:@" "];
        if ([haystack rangeOfString:suffix].location == NSNotFound) suffix = @"CDT";
        if ([haystack rangeOfString:suffix].location == NSNotFound) suffix = @"Quién: ";
        if ([haystack rangeOfString:suffix].location == NSNotFound) suffix = @"Dónde: ";
        if ([haystack rangeOfString:suffix].location == NSNotFound) suffix = @"Estado del Evento: ";
        if ([haystack rangeOfString:suffix].location == NSNotFound) suffix = @"Descripción del evento: ";
        if ([haystack rangeOfString:suffix].location == NSNotFound) suffix = @"Informes: ";
        if ([haystack rangeOfString:prefix].location != NSNotFound && [haystack rangeOfString:suffix].location != NSNotFound)
        {
            NSRange prefixRange = [haystack rangeOfString:prefix];
            NSRange suffixRange = [[haystack substringFromIndex:prefixRange.location+prefixRange.length] rangeOfString:suffix];
            NSRange needleRange = NSMakeRange(prefixRange.location+prefix.length, suffixRange.location);
            NSString *needle = [haystack substringWithRange:needleRange];
            
            NSString *auxiliarString = needle;
            prefix = @" a ";
            if ([auxiliarString rangeOfString:prefix].location == NSNotFound) prefix = @" al ";
            if ([auxiliarString rangeOfString:prefix].location != NSNotFound)
            {
                NSRange prefixRange = [auxiliarString rangeOfString:prefix];
                NSString *needle = [auxiliarString substringFromIndex:prefixRange.location+prefixRange.length];
                dateStartString = [@"Empieza: " stringByAppendingString: [auxiliarString substringWithRange:NSMakeRange(0, [auxiliarString rangeOfString:prefix].location)]];
                if (needle.length > 7)
                    dateEndString = [@"Finaliza: " stringByAppendingString: needle];
                else
                    dateEndString = [@"Finaliza: " stringByAppendingString: [[dateStartString substringWithRange:NSMakeRange(9,15)] stringByAppendingString: [@" " stringByAppendingString: needle]]];
                
                // Quitar doble espacio.
                dateEndString = [dateEndString stringByReplacingOccurrencesOfString:@"  "
                                                                         withString:@" "];
                
                // Anexar dia de comienzo y dia para finalizar.
                dateString = [dateStartString stringByAppendingString: [@"\n" stringByAppendingString: dateEndString]];
            }
            else
                dateString = [@"Empieza: " stringByAppendingString: auxiliarString];
        }
        else
        {
            haystack = item.summary;
            prefix = @"Cuándo: ";
            if ([haystack rangeOfString:@"<"].location != NSNotFound && [haystack rangeOfString:prefix].location != NSNotFound)
            {
                NSRange range = [haystack rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"<"]];
                haystack = [haystack substringWithRange:NSMakeRange(prefix.length, range.location-prefix.length)];
                dateString = [@"Empieza: " stringByAppendingString: haystack];
            }
        }
    }
    
    // Lugar
    if (item.summary)
    {
        NSString *haystack = [item.summary stringByConvertingHTMLToPlainText];
        NSString *prefix = @"Dónde: ";
        NSString *suffix = @"Estado";
        if ([haystack rangeOfString:prefix].location != NSNotFound && [haystack rangeOfString:suffix].location != NSNotFound)
        {
            NSRange prefixRange = [haystack rangeOfString:prefix];
            NSRange suffixRange = [[haystack substringFromIndex:prefixRange.location+prefixRange.length] rangeOfString:suffix];
            NSRange needleRange = NSMakeRange(prefixRange.location+prefixRange.length, suffixRange.location);
            NSString *needle = [haystack substringWithRange:needleRange];
            placeString = needle;
        }
    }
    
    // Descripcion
    if (item.summary)
    {
        NSString *haystack = [item.summary stringByConvertingHTMLToPlainText];
        NSString *prefix = @"Descripción del evento: ";
        NSString *suffix = @"Informes";
        if ([haystack rangeOfString:prefix].location != NSNotFound && [haystack rangeOfString:suffix].location != NSNotFound)
        {
            NSRange prefixRange = [haystack rangeOfString:prefix];
            NSRange suffixRange = [[haystack substringFromIndex:prefixRange.location+prefixRange.length] rangeOfString:suffix];
            NSRange needleRange = NSMakeRange(prefixRange.location+prefixRange.length, suffixRange.location);
            NSString *needle = [haystack substringWithRange:needleRange];
            descriptionString = needle;
        }
        else
            descriptionString = item.title;
    }
    
    // Informes
    if (item.summary)
    {
        NSString *haystack = [item.summary stringByConvertingHTMLToPlainText];
        NSString *prefix = @"Informes ";
        if ([haystack rangeOfString:prefix].location != NSNotFound)
        {
            NSRange prefixRange = [haystack rangeOfString:prefix];
            NSString *needle = [haystack substringFromIndex:prefixRange.location+prefixRange.length];
            
            // Saltar linea cuando empieza el telefono.
            needle = [needle stringByReplacingOccurrencesOfString:@" 83"
                                                       withString:@"\n83"];
            // Agregar espacio despues de ext.
            needle = [needle stringByReplacingOccurrencesOfString:@"ext."
                                                       withString:@"ext "];
            needle = [needle stringByReplacingOccurrencesOfString:@"Ext."
                                                       withString:@"ext "];
            needle = [needle stringByReplacingOccurrencesOfString:@"Ext "
                                                       withString:@"ext "];
            informesString = needle;
            
            // Reconocer el email.
            _emailString = needle;
            prefixRange = [_emailString rangeOfString:@" ext "];
            _emailString = [_emailString substringFromIndex:prefixRange.location+prefixRange.length];
            _emailString = [_emailString substringWithRange:NSMakeRange(5, _emailString.length-5)];
            
        }
    }
    
    // Asigno strings a textViews y labels.
    _lbTitulo.text = titleString;
    _tvDescripcion.text = descriptionString;
    _tvInformes.text = informesString;
    _tvLugar.text = placeString;
    _tvFecha.text = dateString;
    
    // Quito propiedad seleccionable.
    _tvDescripcion.selectable = NO;
    _tvLugar.selectable = NO;
    _tvInformes.selectable = NO;
    _tvFecha.selectable = NO;
    
    // Si no tiene horario aisgnado, ocultar boton de agregar iCal.
    if([dateString isEqualToString:@"Horario Pendiente."])
        _btCalendario.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mail:(id)sender
{
    NSString *s = @"mailto:";
    s = [s stringByAppendingString:_emailString];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:s]];
    
    NSLog(@"%@", s);
}

- (IBAction)agregarCal:(id)sender
{
    NSString *startEvent;
    NSDate *fechaInicio;
    
    // Declarar date formatter.
    NSDateFormatter *ddMMMyyyyHHmm = [[NSDateFormatter alloc] init];
    NSLocale *mxLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"es_MX"];
    ddMMMyyyyHHmm.dateFormat = @"dd-MMM-yyyy-HH:mm";
    ddMMMyyyyHHmm.locale = mxLocale;
    
    /// FECHA INICIO ///
    
    // Empiezo despues de "Empieza: xxx ".
    startEvent = [dateString substringFromIndex:13];
    
    // Quitar apartir de Finaliza.
    if ([startEvent rangeOfString:@"Finaliza: "].location != NSNotFound)
        startEvent = [startEvent substringWithRange:NSMakeRange(0, [startEvent rangeOfString:@"Finaliza: "].location-1)];
    
    // Poner en Formato.
    startEvent = [startEvent stringByReplacingOccurrencesOfString:@" "
                                                       withString:@"-"];
    
    // Si no tiene programada una hora, lo pondre a las 4 de la tarde.
    if (startEvent.length < 14)
        startEvent = [startEvent stringByAppendingString:@"16:00"];
    
    // Lo asigno en la variable de tipo NSDate.
    fechaInicio = [ddMMMyyyyHHmm dateFromString: startEvent];
    
    
    /// FECHA FIN ///
    NSString *endEvent = dateString;
    NSDate *fechaFin;
    
    // Checo si el evento me da la duracion.
    if ([endEvent rangeOfString:@"Finaliza: "].location != NSNotFound)
    {
        // Quitar apartir de Finaliza
        endEvent = [endEvent substringFromIndex:[endEvent rangeOfString:@"Finaliza: "].location + 14];
        
        // Poner en Formato.
        endEvent = [endEvent stringByReplacingOccurrencesOfString:@" "
                                                       withString:@"-"];
        
        endEvent = [endEvent substringWithRange:NSMakeRange(0, endEvent.length-2)];
        
        // Lo asigno en la variable de tipo NSDate.
        fechaFin = [ddMMMyyyyHHmm dateFromString: endEvent];
    }
    
    // Si no tiene fecha fin determinada, le asigno por default 1 hora.
    else
    {
        fechaFin = [fechaInicio dateByAddingTimeInterval:60*60];
    }
    
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
    {
        if (!granted){ return; }
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
        EKEvent *event = [EKEvent eventWithEventStore:store];
        event.title = titleString;
        event.startDate = fechaInicio;
        event.endDate = fechaFin;
        [event setCalendar:[store defaultCalendarForNewEvents]];
        NSError *err = nil;
        [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        
        NSString *mensaje = [[NSString alloc] initWithFormat: @"Evento guardado exitosamente."];
        UIAlertView *alerta = [[UIAlertView alloc] initWithTitle: @"Aviso"
                                                         message: mensaje
                                                        delegate: self
                                               cancelButtonTitle: @"OK"
                                               otherButtonTitles: nil];
        [alerta show];
            
        });
    }];
}

@end