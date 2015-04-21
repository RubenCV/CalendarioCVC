//
//  MasterViewController.m
//  CeldasMedida
//
//  Created by alumno on 05/03/15.
//  Copyright (c) 2015 A00814298. All rights reserved.
//

#import "MasterViewController.h"
#import "GlobalCalendar.h"
#import "NSString+HTML.h"


@interface MasterViewController ()

@end

GlobalCalendar *myCalendar;


@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    myCalendar = [GlobalCalendar sharedSingleton];
    //[myCalendar feedParser].delegate = self;
    
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
    // Declarar arreglo de eventos.
    NSMutableArray *arrFechaEventos = [[NSMutableArray alloc] init];
    
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
            prefix = @" a ";
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

        if (dateStartString.length > 16){
        dateStartString = [dateStartString substringWithRange:NSMakeRange(4, dateStartString.length-5)];
            if (dateStartString.length > 12){
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
        
        dateStartString = [dateStartString stringByReplacingOccurrencesOfString:@" "
                                                               withString:@"-"];

        NSDate *evento = [ddMMMyyyy dateFromString: dateStartString];
        [arrFechaEventos addObject:evento];
        [arrFechaEventos addObject:dateStartString];
    }
    
    myCalendar.eventDayList = arrFechaEventos;
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
    //[self updateTableWithParsedItems];
    myCalendar.itemsToDisplay =[parsedItems sortedArrayUsingDescriptors:
                           [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date"
                                                                                ascending:NO]]];

    
}

@end
