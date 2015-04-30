//
//  ViewControllerCalendario.m
//  CeldasMedida
//
//  Created by Ruben Cantu on 3/26/15.
//  Copyright (c) 2015 A00814298. All rights reserved.
//

#import "DSLCalendarView.h"
#import "ViewControllerCalendario.h"
#import "EventoViewController.h"
#import "NSString+HTML.h"
#import "GlobalCalendar.h"

@interface ViewControllerCalendario () <DSLCalendarViewDelegate>

@property (nonatomic, weak) IBOutlet DSLCalendarView *calendarView;
@property (strong, nonatomic) NSString *diaString;
@property (nonatomic) NSInteger eventIndex;

@end

GlobalCalendar *myCalendar;

@implementation ViewControllerCalendario

- (void)viewDidLoad
{
    [super viewDidLoad];
    myCalendar = [GlobalCalendar sharedSingleton];
    
    self.calendarView.delegate = self;
    
    // HOY
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MMMM-yyyy"];
    NSString *dateString = [[dateFormat stringFromDate:[NSDate date]] uppercaseString];
    NSRange dayRange = [dateString rangeOfString:@"/"];
    NSRange monthRange = [dateString rangeOfString:@"-"];
    self.lbDay.text = [dateString substringWithRange:NSMakeRange(0, dayRange.location)];
    self.lbMonth.text = [dateString substringWithRange:NSMakeRange(dayRange.location+1, dateString.length - monthRange.location)];
    self.lbYear.text = [dateString substringWithRange:NSMakeRange(dateString.length-4, 4)];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - DSLCalendarViewDelegate methods

- (void)calendarView:(DSLCalendarView *)calendarView didSelectRange:(DSLCalendarRange *)range {
    if (range != nil) {
        // Declarar date formatter.
        NSDateFormatter *ddMMyyyy = [[NSDateFormatter alloc] init];
        ddMMyyyy.timeStyle = NSDateFormatterNoStyle;
        ddMMyyyy.dateFormat = @"dd-MM-yyyy";
        
        NSString *dayString;
        dayString = [NSString stringWithFormat:@"%ld-%ld-%ld", (long)range.startDay.day, (long)range.startDay.month, (long) range.startDay.year];
        
        NSDate *dia = [ddMMyyyy dateFromString: dayString];
        
        
        NSDate *event;
        // Checar si el dia que seleccionado pertenece a un evento.
        for(int i = 0; i < myCalendar.eventDayList.count; i++)
        {
        
        event = [[myCalendar eventDayList] objectAtIndex:i];
        if(event == dia)
            {
                _eventIndex = (int)i/2;
                _diaString = dayString;
                [self performSegueWithIdentifier:@"Event" sender:self];
            }
        }
    }
    else {
        NSLog( @"Rango invalido" );
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Event"]) {
        EventoViewController *evc = [segue destinationViewController];
        evc.diaString = _diaString;
        evc.eventIndex = _eventIndex;
    }
}

- (DSLCalendarRange*)calendarView:(DSLCalendarView *)calendarView didDragToDay:(NSDateComponents *)day selectingRange:(DSLCalendarRange *)range {
    return [[DSLCalendarRange alloc] initWithStartDay:day endDay:day];
}

- (void)calendarView:(DSLCalendarView *)calendarView willChangeToVisibleMonth:(NSDateComponents *)month duration:(NSTimeInterval)duration {
    NSLog(@"Will show %@ in %.3f seconds", month, duration);
}

- (void)calendarView:(DSLCalendarView *)calendarView didChangeToVisibleMonth:(NSDateComponents *)month {
    NSLog(@"Now showing %@", month);
}

- (BOOL)day:(NSDateComponents*)day1 isBeforeDay:(NSDateComponents*)day2 {
    return ([day1.date compare:day2.date] == NSOrderedAscending);
}

@end

