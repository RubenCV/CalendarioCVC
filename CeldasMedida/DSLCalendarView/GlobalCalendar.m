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

NSString *var2; // global variable
MWFeedParser *feedParser;
NSMutableArray *parsedItems;

// Displaying
NSArray *itemsToDisplay;
NSMutableArray *eventDayList;
NSDateFormatter *formatter;


@implementation GlobalCalendar

@synthesize var1;
@synthesize feedParser;
@synthesize formatter;
@synthesize parsedItems;
@synthesize eventDayList;
@synthesize newsIDList;
@synthesize newsImages;
@synthesize newsTitles;
@synthesize itemsToDisplay;

static GlobalCalendar *shared = NULL;



- (id)init
{
    if ( self = [super init] )
    {
        // initialize your singleton variable here (i.e. set to initial value that you require)
        
        var1 = @"My Cool Singleton";
    }
    return self;
    
}


+ (GlobalCalendar *)sharedSingleton
{
    @synchronized(shared)
    {
        if ( !shared || shared == NULL )
        {
            // allocate the shared instance, because it hasn't been done yet
            shared = [[GlobalCalendar alloc] init];
            
            
        }
        
        return shared;
    }
}


+(NSString *)myData{
    return @"DataString";
}

- (void) SetMainCalendar{
    NSLog(@"SetMainCalendar");
}

+ (NSInteger)GetItemsToDisplayCount{
    return itemsToDisplay.count;
}



@end


