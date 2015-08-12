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

@property BOOL loadedNoticias, loadedEventos;

@end

GlobalCalendar *myCalendar;

@implementation MenuViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(initParser)];
    self.navigationItem.leftBarButtonItem = reloadButton;
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
    
    myCalendar = [GlobalCalendar sharedSingleton];
    
    // Escribir el dia de hoy en el icono de calendario.
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSLocale *mxLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"es_MX"];
    [dateFormat setDateFormat:@"dd/MMM/yy"];
    [dateFormat setLocale:mxLocale];
    NSString *dateString = [[dateFormat stringFromDate:[NSDate date]] uppercaseString];
    self.lbDia.text = dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    // Inicializar el Parser.
    [self initParser];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initParser
{
    // Inicializo boleana que indica si ya se cargaron los datos necesarios.
    _loadedNoticias = NO;
    _loadedEventos = NO;
    [_actNoticias startAnimating];
    [_actEventos startAnimating];
    
    // Prepararse para el Parser.
    parsedItems = [[NSMutableArray alloc] init];
    myCalendar.itemsToDisplay = [NSArray array];
    
    // Inicializar el Parse con la liga feed de Google calendar.
    NSURL *feedURL = [NSURL URLWithString:@"https://www.google.com/calendar/feeds/b3ap19ompkd8filsmib6i6svbg%40group.calendar.google.com/public/basic"];
    feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
    feedParser.delegate = self;
    feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
    feedParser.connectionType = ConnectionTypeAsynchronously;
    [feedParser parse];
}


- (void)loadEventDays
{
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
        // iOS Español
        dateStartString = [dateStartString stringByReplacingOccurrencesOfString:@" de "
                                                                     withString:@"-"];
        // iOS English
        dateStartString = [dateStartString stringByReplacingOccurrencesOfString:@" "
                                                                     withString:@"-"];
        // Borrar basura del final del String.
        if (dateStartString.length > 12)
            dateStartString = [dateStartString substringWithRange:NSMakeRange(0, 10)];
        
        // Hot Fix: Sept -> Sep
        dateStartString = [dateStartString stringByReplacingOccurrencesOfString:@"Sept"
                                                                     withString:@"Sep"];
        
        NSDate *evento = [ddMMMyyyy dateFromString: dateStartString];

        // Si no es valido o es nulo.
        if (evento == nil)
        {
            evento = [NSDate date];
            NSLog(@"Warning! Hay eventos nulos!");
        }
        
        // Agregar a lista de eventos.
        [arrFechaEventos addObject:evento];
        
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

- (void)loadNewsID
{
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

- (void)loadNewsImages
{
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

- (void)feedParserDidStart:(MWFeedParser *)parser
{
    NSLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info
{
    NSLog(@"Parsed Feed Info: “%@”", info.title);
    //self.title = info.title;
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item
{
    NSLog(@"Parsed Feed Item: “%@”", item.title);
    if (item) [parsedItems addObject:item];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser
{
    myCalendar.itemsToDisplay =[parsedItems sortedArrayUsingDescriptors:
                                [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date"
                                                                                     ascending:NO]]];
    // Termine de cargar el Calendario.
    [_actEventos stopAnimating];
    _loadedEventos = YES;
    
    // Hacer el feed de los dias de evento, de las imagenes y encabezados de las noticias.
    [self loadEventDays];
    [self loadNewsID];
    [self loadNewsImages];
    NSLog(@"Finalizo el Parser costum CVC.");
    
    // Termine de cargar Noticias.
    [_actNoticias stopAnimating];
    _loadedNoticias = YES;
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error
{
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

// Boton eventos
- (IBAction)eventos:(id)sender
{
    if (_loadedEventos)
        [self performSegueWithIdentifier:@"Calendario" sender:self];
}

// Boton noticias
- (IBAction)noticias:(id)sender
{
    if (_loadedNoticias)
        [self performSegueWithIdentifier:@"Noticias" sender:self];
}


- (IBAction)logout:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end

@interface UINavigationController (Rotation_IOS6)
@end

@implementation UINavigationController (Rotation_IOS6)

-(BOOL)shouldAutorotate
{
    if([self.visibleViewController isMemberOfClass:NSClassFromString(@"MenuViewController")])
    {
        return UIInterfaceOrientationMaskPortrait;
    }
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [[self topViewController] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if([self.visibleViewController isMemberOfClass:NSClassFromString(@"MenuViewController")])
    {
        return (UIInterfaceOrientation)UIInterfaceOrientationMaskPortrait;
    }
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

@end

