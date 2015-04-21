//
//  MasterViewController.m
//  CeldasMedida
//
//  Created by alumno on 05/03/15.
//  Copyright (c) 2015 A00814298. All rights reserved.
//

#import "MasterViewController.h"
#import "CustomTableViewCell.h"
#import "GlobalCalendar.h"


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

#pragma mark -
#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
    NSLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
    NSLog(@"Parsed Feed Info: “%@”", info.title);
    self.title = info.title;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *tmp = [NSString stringWithFormat:@"%lu", (unsigned long)myCalendar.itemsToDisplay.count];
    NSLog(tmp);
}

@end
