//
//  GlobalCalendar.m
//  CeldasMedida
//
//  Created by Antonio Vargas on 4/20/15.
//  Copyright (c) 2015 A00814298. All rights reserved.
//

#import "GlobalCalendar.h"
#import "NSString+HTML.h"
#import "MWFeedParser.h"

// Parser.
MWFeedParser *feedParser;
NSMutableArray *parsedItems;

// Display.
NSArray *itemsToDisplay;
NSDateFormatter *formatter;
NSMutableArray *eventDayList;

@implementation GlobalCalendar

// Parser.
@synthesize feedParser;
@synthesize itemsToDisplay;
@synthesize parsedItems;

// Calendario.
@synthesize formatter;
@synthesize eventDayList;
@synthesize eventTypeList;

// Noticias.
@synthesize newsIDList;
@synthesize newsTitles;
@synthesize newsImages;

static GlobalCalendar *shared = NULL;

+ (GlobalCalendar *)sharedSingleton
{
    @synchronized(shared)
    {
        if ( !shared || shared == NULL )
        {
            // Allocate the shared instance.
            shared = [[GlobalCalendar alloc] init];
        }
        return shared;
    }
}

@end

