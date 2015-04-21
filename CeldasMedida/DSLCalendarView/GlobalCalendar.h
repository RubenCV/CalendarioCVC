//
//  GlobalCalendar.m
//  CeldasMedida
//
//  Created by Antonio Vargas on 4/20/15.
//  Copyright (c) 2015 A00814298. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "MWFeedParser.h"

//Global variable
extern NSString *var2;

// Parser
extern MWFeedParser *feedParser;
extern NSMutableArray *parsedItems;

// Displaying
//extern NSArray *itemsToDisplay;
extern NSDateFormatter *formatter;

@interface GlobalCalendar : NSObject {
    
    //Singleton
    NSString *var1;
    
    MWFeedParser *feedParser;
    NSMutableArray *parsedItems;
    NSMutableArray *eventDayList;
    
    NSArray *itemsToDisplay;
    NSDateFormatter *formatter;
    
}


// Properties
@property (nonatomic, retain) NSString *var1;

@property (nonatomic, retain) MWFeedParser *feedParser;
@property (nonatomic, retain) NSMutableArray *parsedItems;
@property (nonatomic, retain) NSMutableArray *eventDayList;
@property (nonatomic, retain) NSArray *itemsToDisplay;
@property (nonatomic, retain) NSDateFormatter *formatter;

@property (retain, nonatomic) id <MWFeedParserDelegate> delegado;

// Functions
+ (GlobalCalendar *)sharedSingleton;
+(NSString *)myData;
- (void) SetMainCalendar;

@end
