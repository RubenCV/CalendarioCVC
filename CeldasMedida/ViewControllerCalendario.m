//
//  ViewControllerCalendario.m
//  CeldasMedida
//
//  Created by Ruben Cantu on 3/26/15.
//  Copyright (c) 2015 A00814298. All rights reserved.
//

#import "DSLCalendarView.h"
#import "ViewControllerCalendario.h"

@interface ViewControllerCalendario () <DSLCalendarViewDelegate>

@property (nonatomic, weak) IBOutlet DSLCalendarView *calendarView;

@end

@implementation ViewControllerCalendario

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.calendarView.delegate = self;
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
        // AQUI DEBERIA MANDARME A OTRO VIEW, PARA EL SIGUIENTE DIA:
        NSLog( @"Dia: %ld Mes: %ld  Año: %ld", (long)range.startDay.day, (long)range.startDay.month, (long) range.startDay.year );
    }
    else {
        NSLog( @"No selection" );
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

