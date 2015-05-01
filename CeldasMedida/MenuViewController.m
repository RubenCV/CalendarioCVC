//
//  MenuViewController.m
//  CeldasMedida
//
//  Created by Ruben Cantu on 4/26/15.
//  Copyright (c) 2015 A00814298. All rights reserved.
//

#import "GlobalCalendar.h"
#import "NSString+HTML.h"
#import "MenuViewController.h"

@interface MenuViewController ()

@end

GlobalCalendar *myCalendar;

@implementation MenuViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    myCalendar = [GlobalCalendar sharedSingleton];
    
    //HOY
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSLocale *mxLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"es_MX"];
    [dateFormat setDateFormat:@"dd/MMM/yy"];
    [dateFormat setLocale:mxLocale];
    NSString *dateString = [[dateFormat stringFromDate:[NSDate date]] uppercaseString];
    self.lbDia.text = dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    parsedItems = [[NSMutableArray alloc] init];
    myCalendar.itemsToDisplay = [NSArray array];
    
    // Parse
    NSURL *feedURL = [NSURL URLWithString:@"https://www.google.com/calendar/feeds/b3ap19ompkd8filsmib6i6svbg%40group.calendar.google.com/public/basic"];
    feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
    
    feedParser.delegate = self;
    feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
    feedParser.connectionType = ConnectionTypeAsynchronously;
    [feedParser parse];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadEventDays {
    // Declarar arreglo de fechas y tipos de eventos.
    NSMutableArray *arrFechaEventos = [[NSMutableArray alloc] init];
    NSMutableArray *arrTipoEventos = [[NSMutableArray alloc] init];

    // Declarar date formatter.
    NSDateFormatter *ddMMMyyyy = [[NSDateFormatter alloc] init];
    NSLocale *mxLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"es_MX"];
    [ddMMMyyyy setLocale:mxLocale];
    ddMMMyyyy.timeStyle = NSDateFormatterNoStyle;
    ddMMMyyyy.dateFormat = @"dd-MMM-yyyy";
    
    NSString *dateStartString;
    MWFeedItem *item;
    
    // Agregar las fechas de todos los eventos al arreglo
    for(int i = 0; i < parsedItems.count; i++)
    {
        item = [[myCalendar itemsToDisplay] objectAtIndex:i];
        NSString *haystack = [item.summary stringByConvertingHTMLToPlainText];
        NSString *prefix = @"Cuándo: ";
        NSString *suffix = @"CST";
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
            
            // Enlgish
            prefix = @" a ";
            
            // Spanish
            if ([auxiliarString rangeOfString:prefix].location == NSNotFound) prefix = @" al ";
            
            if ([auxiliarString rangeOfString:prefix].location != NSNotFound)
            {
                dateStartString = [auxiliarString substringWithRange:NSMakeRange(0, [auxiliarString rangeOfString:prefix].location)];
            }
            else
                dateStartString = auxiliarString;
        }
        else
        {
            haystack = item.summary;
            prefix = @"Cuándo: ";
            if ([haystack rangeOfString:@"<"].location != NSNotFound && [haystack rangeOfString:prefix].location != NSNotFound)
            {
                NSRange range = [haystack rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"<"]];
                haystack = [haystack substringWithRange:NSMakeRange(prefix.length, range.location-prefix.length)];
                dateStartString = haystack;
            }
        }
        
        if (dateStartString.length > 16){ //19
            dateStartString = [dateStartString substringWithRange:NSMakeRange(4, dateStartString.length-5)];
            if (dateStartString.length > 12){ //9
                dateStartString = [dateStartString substringWithRange:NSMakeRange(0, dateStartString.length-5)];
            }
        }
        else if(!([[dateStartString substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"0"] ||
                  [[dateStartString substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"1"] ||
                  [[dateStartString substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"2"] ||
                  [[dateStartString substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"3"] ||
                  [[dateStartString substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"4"] ||
                  [[dateStartString substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"5"] ||
                  [[dateStartString substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"6"] ||
                  [[dateStartString substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"7"] ||
                  [[dateStartString substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"8"] ||
                  [[dateStartString substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"9"]))
        {
            dateStartString = [dateStartString substringWithRange:NSMakeRange(4, dateStartString.length-5)];
        }
        // Spanish
        dateStartString = [dateStartString stringByReplacingOccurrencesOfString:@" de "
                                                                     withString:@"-"];
        // English
        dateStartString = [dateStartString stringByReplacingOccurrencesOfString:@" "
                                                                     withString:@"-"];
        if (dateStartString.length > 12)
            dateStartString = [dateStartString substringWithRange:NSMakeRange(0, 10)];
        
        NSDate *evento = [ddMMMyyyy dateFromString: dateStartString];
        [arrFechaEventos addObject:evento];
        [arrFechaEventos addObject:dateStartString];
        
        // Tipo de Evento
        NSString *eventoString = [[item.title stringByAppendingString:item.summary]uppercaseString];
        
        // TIPO 1 = Reclutamiento.
        eventoString = [eventoString stringByReplacingOccurrencesOfString:@"RECLUTAMIENTO"
                                                                        withString:@" TIPO1 "];
        // TIPO 2 = Platica / Conferencia.
        eventoString = [eventoString stringByReplacingOccurrencesOfString:@"PLÁTICA"
                                                               withString:@" TIPO2 "];
        eventoString = [eventoString stringByReplacingOccurrencesOfString:@"CONFERENCIA"
                                                               withString:@" TIPO2 "];
        
        arrTipoEventos[i] = @"0";
        if ([eventoString rangeOfString:@"TIPO1"].location != NSNotFound) arrTipoEventos[i] = @"1";
        else if ([eventoString rangeOfString:@"TIPO2"].location != NSNotFound) arrTipoEventos[i] = @"2";
    }
    
    myCalendar.eventTypeList = arrTipoEventos;
    myCalendar.eventDayList = arrFechaEventos;
}

- (void)loadNewsID {
    // Declarar arreglo de eventos.
    NSMutableArray *arrNoticiasID = [[NSMutableArray alloc] init];
    NSMutableArray *arrNoticiasTitulos = [[NSMutableArray alloc] init];
    
    NSString *cvcString = @"https://cvc.itesm.mx/portal/page/portal/CVC/02/01/Noticias";
    NSURL *cvcURL = [NSURL URLWithString:cvcString];
    NSError *error;
    NSString *cvcPage = [NSString stringWithContentsOfURL:cvcURL
                                                 encoding:NSASCIIStringEncoding
                                                    error:&error];
    
    cvcPage = [cvcPage stringByReplacingOccurrencesOfString:@"/ex_general_img/A"
                                                 withString:@" $$StartN$$ "];
    cvcPage = [cvcPage stringByReplacingOccurrencesOfString:@".jpg"
                                                 withString:@" $$EndN$$ "];
    
    cvcPage = [cvcPage stringByReplacingOccurrencesOfString:@" border=\"0\"><B> "
                                                 withString:@" $$StartT$$ "];
    cvcPage = [cvcPage stringByReplacingOccurrencesOfString:@" </B></FONT></A></TD"
                                                 withString:@" $$EndT$$ "];
    
    NSString *haystack;
    NSString *prefix = @" $$StartN$$ ";
    NSString *suffix = @" $$EndN$$ ";
    NSString *prefixT = @" $$StartT$$ ";
    NSString *suffixT = @" $$EndT$$ ";
    
    for(int i = 0; i < 10; i++)
    {
        haystack = cvcPage;
        
        if ([haystack rangeOfString:prefix].location != NSNotFound && [haystack rangeOfString:suffix].location != NSNotFound)
        {
            // ID
            NSRange prefixRange = [haystack rangeOfString:prefix];
            NSRange suffixRange = [[haystack substringFromIndex:prefixRange.location+prefixRange.length] rangeOfString:suffix];
            NSRange needleRange = NSMakeRange(prefixRange.location+prefix.length, suffixRange.location);
            NSString *needle = [haystack substringWithRange:needleRange];
            cvcPage = [haystack substringFromIndex:[haystack rangeOfString:suffix].location+suffix.length];
            [arrNoticiasID addObject:needle];
            // Titulo
            prefixRange = [cvcPage rangeOfString:prefixT];
            suffixRange = [[cvcPage substringFromIndex:prefixRange.location+prefixRange.length] rangeOfString:suffixT];
            needleRange = NSMakeRange(prefixRange.location+prefixT.length, suffixRange.location);
            needle = [cvcPage substringWithRange:needleRange];
            
            // Quito cursivas y negritas.
            
            needle = [needle stringByReplacingOccurrencesOfString:@"<i>"
                                                       withString:@""];
            
            needle = [needle stringByReplacingOccurrencesOfString:@"</i>"
                                                       withString:@""];
            
            needle = [needle stringByReplacingOccurrencesOfString:@"<b>"
                                                       withString:@""];
            
            needle = [needle stringByReplacingOccurrencesOfString:@"</b>"
                                                       withString:@""];
            // Si hay mas cod. HTML lo borro.
            
            needle = [needle stringByReplacingOccurrencesOfString:@"<"
                                            withString:@" $$NewEnd$$ "];
            if ([needle rangeOfString:@" $$NewEnd$$ "].location != NSNotFound)
            {
                suffixRange = [needle rangeOfString:@" $$NewEnd$$ "];
                needle = [needle substringWithRange:NSMakeRange(0, suffixRange.location)];
            }
            
            // Almacena el titulo en el arreglo.
            
            [arrNoticiasTitulos addObject:needle];
        }
        
    }
    
    myCalendar.newsIDList = arrNoticiasID;
    myCalendar.newsTitles = arrNoticiasTitulos;
}

- (void)loadNewsImages {
    
    NSMutableArray *arrImages = [[NSMutableArray alloc] init];
    NSString *link = @"https://cvc.itesm.mx/ex_general_img/A";
    NSString *ext = @".jpg";
    
    for(int i = 0; i < myCalendar.newsIDList.count; i++)
    {
        NSString *urlAux;
        urlAux = [link stringByAppendingString:myCalendar.newsIDList[i]];
        urlAux = [urlAux stringByAppendingString:ext];
        
        NSURL *nsurl = [NSURL URLWithString: urlAux ];
        NSData *data = [[NSData alloc] initWithContentsOfURL: nsurl];
        
        [arrImages addObject:[UIImage imageWithData: data]];
    }
    
    myCalendar.newsImages = arrImages;
}

#pragma mark -
#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
    NSLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
    NSLog(@"Parsed Feed Info: “%@”", info.title);
    //self.title = info.title;
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    NSLog(@"Parsed Feed Item: “%@”", item.title);
    if (item) [parsedItems addObject:item];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
    NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    //[self updateTableWithParsedItems];
    myCalendar.itemsToDisplay =[parsedItems sortedArrayUsingDescriptors:
                                [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date"
                                                                                     ascending:NO]]];
    [self loadEventDays];
    [self loadNewsID];
    [self loadNewsImages];
    NSLog(@"Finalizo el Parser costum CVC.");
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
    NSLog(@"Finished Parsing With Error: %@", error);
    if (parsedItems.count == 0) {
        self.title = @"Failed"; // Show failed message in title
    } else {
        // Failed but some items parsed, so show and inform of error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parsing Incomplete"
                                                        message:@"There was an error during the parsing of this feed. Not all of the feed items could parsed."
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    }
    myCalendar.itemsToDisplay =[parsedItems sortedArrayUsingDescriptors:
                                [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date"
                                                                                     ascending:NO]]];
    
    
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
@end
