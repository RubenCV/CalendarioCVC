//
//  GlobalCalendar.m
//  CeldasMedida
//
//  Created by Antonio Vargas on 4/20/15.
//  Copyright (c) 2015 A00814298. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWFeedParser.h"

// Parser.
extern MWFeedParser *feedParser;
extern NSMutableArray *parsedItems;

// Displaying.
extern NSDateFormatter *formatter;

// Singleton.
@interface GlobalCalendar : NSObject
{
    // Necesarios para el Parser.
    MWFeedParser *feedParser;
    NSArray *itemsToDisplay;
    NSMutableArray *parsedItems;
    
    // Necesarios para el calendario.
    NSDateFormatter *formatter;
    NSMutableArray *eventDayList;
    NSMutableArray *eventTypeList;
    
    // Necesarios para las noticias.
    NSMutableArray *newsIDList;
    NSMutableArray *newsTitles;
    NSMutableArray *newsImages;
}

// Propiedades Parser.
@property (nonatomic, retain) MWFeedParser *feedParser;
@property (nonatomic, retain) NSArray *itemsToDisplay;
@property (nonatomic, retain) NSMutableArray *parsedItems;

// Propiedades calendario.
@property (nonatomic, retain) NSDateFormatter *formatter;
@property (nonatomic, retain) NSMutableArray *eventDayList;
@property (nonatomic, retain) NSMutableArray *eventTypeList;

// Propiedades noticias.
@property (nonatomic, retain) NSMutableArray *newsIDList;
@property (nonatomic, retain) NSMutableArray *newsImages;
@property (nonatomic, retain) NSMutableArray *newsTitles;

@property (retain, nonatomic) id <MWFeedParserDelegate> delegado;

// Funciones.
+ (GlobalCalendar *)sharedSingleton;

@end