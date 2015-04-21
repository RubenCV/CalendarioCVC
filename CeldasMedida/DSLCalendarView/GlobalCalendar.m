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
NSDateFormatter *formatter;


@implementation GlobalCalendar

@synthesize var1;
@synthesize feedParser;
@synthesize formatter;
@synthesize parsedItems;
//@synthesize itemsToDisplay;

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
    
    return @"Hello world!";
}

- (void) SetMainCalendar{
    
    NSLog(@"SetMainCalendar");
    /*
    // init the web feed baby!
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    parsedItems = [[NSMutableArray alloc] init];
    itemsToDisplay = [NSArray array];
    
    
    // Parse
    NSURL *feedURL = [NSURL URLWithString:@"https://www.google.com/calendar/feeds/b3ap19ompkd8filsmib6i6svbg%40group.calendar.google.com/public/basic"];
    feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
    
    //feedParser.delegate = self.delegado;
    feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
    feedParser.connectionType = ConnectionTypeAsynchronously;
    [feedParser parse];
    
    // Lets update our items!
    itemsToDisplay = [parsedItems sortedArrayUsingDescriptors:
                           [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date"
                                                                                ascending:NO]]];
    
    */
    
    
    //NSLog(@"Initializing Global Calendar. It should happen once!");
    //NSLog(@"This means the calendar feed should be loaded also!");
    //NSString *inStr = [@([self GetItemsToDisplayCount]) stringValue];
    //NSLog(inStr);
}

+ (NSInteger)GetItemsToDisplayCount{
    return itemsToDisplay.count;
}



@end


