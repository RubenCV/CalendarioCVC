//
//  ViewControllerCalendario.m
//  CeldasMedida
//
//  Created by Ruben Cantu on 3/26/15.
//  Copyright (c) 2015 A00814298. All rights reserved.
//

#import "DSLCalendarView.h"
#import "ViewControllerCalendario.h"
#import "NSString+HTML.h"
#import "GlobalCalendar.h"

@interface ViewControllerCalendario () <DSLCalendarViewDelegate>

@property (nonatomic, weak) IBOutlet DSLCalendarView *calendarView;

@end

GlobalCalendar *myCalendar;

@implementation ViewControllerCalendario

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    myCalendar = [GlobalCalendar sharedSingleton];
    
    self.calendarView.delegate = self;
    

    /*
     ESTE ES UN TEST, CUANDO SE CARGA LA VISTA DE CONTROLLER CALENDARIO PODEMOS ACCESAR A myCalendar itemsToDisplay.
     */
    MWFeedItem *item = [[myCalendar itemsToDisplay] objectAtIndex:0];
    if (item) {
        
        // Process
        NSString *itemTitle = item.title ? [item.title stringByConvertingHTMLToPlainText] : @"[No Title]";
        NSString *itemSummary = item.summary ? [item.summary stringByConvertingHTMLToPlainText] : @"[No Summary]";
        
        NSLog(itemTitle);
        NSLog(itemSummary);
    }
    else{
        NSLog(@"No items");
    }
    
    
    
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
    [self performSegueWithIdentifier: @"test" sender: self];
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

/*
 Plan B:
 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://cvc.mty.itesm.mx/go.php?page=https://www.google.com/calendar/embed?height=530&wkst=1&hl=es&bgcolor=%23FFFFFF&src=b3ap19ompkd8filsmib6i6svbg%40group.calendar.google.com&color=%23182C57&ctz=America%2FMexico_City"]];
 */

