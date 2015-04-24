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

@interface EventoViewController ()

@end

GlobalCalendar *myCalendar;

@implementation EventoViewController

@synthesize dateString, dateStartString, dateEndString, summaryString, placeString, titleString, informesString, descriptionString;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Evento";
    myCalendar = [GlobalCalendar sharedSingleton];
    MWFeedItem *item = [[myCalendar itemsToDisplay] objectAtIndex:_eventIndex];
    
    // Default Values
    titleString = @"Evento CVC";
    dateString = @"Horario Pendiente.";
    placeString = @"Lugar:\nITESM";
    descriptionString = @"Descripcion Pendiente.";
    informesString = @"Informes:\n8358 2000 ext.3614\ncvc.mty@servicios.itesm.mx";
    
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
            placeString = [@"Lugar:\n" stringByAppendingString: needle];
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
            descriptionString = [@"Descripción del evento:\n" stringByAppendingString: needle];
        }
        else
            descriptionString = [@"Descripción del evento:\n" stringByAppendingString: item.title];
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
            informesString = [@"Informes:\n" stringByAppendingString: needle];
        }
    }
    
    // Asigno strings a labels.
    _lbTitulo.text = titleString;
    _lbDescripcion.text = descriptionString;
    _lbInformes.text = informesString;
    _lbLugar.text = placeString;
    _lbFecha.text = dateString;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
