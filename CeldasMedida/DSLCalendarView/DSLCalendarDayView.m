/*
 DSLCalendarDayView.h
 
 Copyright (c) 2012 Dative Studios. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 * Neither the name of the author nor the names of its contributors may be used
 to endorse or promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "DSLCalendarDayView.h"
#import "NSDate+DSLCalendarView.h"
#import "GlobalCalendar.h"
#import "NSString+HTML.h"

@interface DSLCalendarDayView ()

@end

GlobalCalendar *myCalendar;

@implementation DSLCalendarDayView
{
    __strong NSCalendar *_calendar;
    __strong NSDate *_dayAsDate;
    __strong NSDateComponents *_day;
    __strong NSString *_labelText;
}

#pragma mark - Initialisation
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        self.backgroundColor = [UIColor whiteColor];
        _positionInWeek = DSLCalendarDayViewMidWeek;
    }
    return self;
}


#pragma mark Properties

- (void)setSelectionState:(DSLCalendarDayViewSelectionState)selectionState
{
    _selectionState = selectionState;
    [self setNeedsDisplay];
}

- (void)setDay:(NSDateComponents *)day
{
    _calendar = [day calendar];
    _dayAsDate = [day date];
    _day = nil;
    _labelText = [NSString stringWithFormat:@"%ld", (long)day.day];
}

- (NSDateComponents*)day
{
    if (_day == nil)
    {
        _day = [_dayAsDate dslCalendarView_dayWithCalendar:_calendar];
    }
    return _day;
}

- (NSDate*)dayAsDate
{
    return _dayAsDate;
}

- (void)setInCurrentMonth:(BOOL)inCurrentMonth
{
    _inCurrentMonth = inCurrentMonth;
    [self setNeedsDisplay];
}


#pragma mark UIView methods
- (void)drawRect:(CGRect)rect
{
    if ([self isMemberOfClass:[DSLCalendarDayView class]])
    {
        [self drawBackground];
    }
}

#pragma mark Drawing
- (void)drawBackground
{
    // Pinto el fondo del color gris claro.
    [[UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1] setFill];
    UIRectFill(self.bounds);
    
    // Declaracion de variables.
    UIColor *textColor;
    UIFont *textFont = [UIFont boldSystemFontOfSize:18.0];
    NSUInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:flags fromDate:[self.day date]];
    NSDateComponents *componentsOfToday = [calendar components:flags fromDate:[NSDate date]];
    
    NSDate *date = [calendar dateFromComponents:components];
    NSDate *dateToday = [calendar dateFromComponents:componentsOfToday];

    // Si este dia no esta siendo seleccionado.
    if (self.selectionState == DSLCalendarDayViewNotSelected) {
        if (self.isInCurrentMonth)
        {
            textColor = [UIColor blackColor];
        }
        else
        {
            textColor = [UIColor colorWithWhite:110.0/255.0 alpha:1.0];
        }
        
        // Checar si el dia que dibujo pertenece a un evento.
        if([myCalendar.eventDayList containsObject: date])
        {
            textColor = [UIColor whiteColor];
            NSInteger index = [myCalendar.eventDayList indexOfObject:date];
            
            // Evento tipo Misc.
            if ([myCalendar.eventTypeList[(int)index/2] isEqualToString:@"0"])
            {
                [[[UIImage imageNamed:@"diaEvento3"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)] drawInRect:self.bounds];
            }
            // Evento tipo Reclutamiento.
            else if ([myCalendar.eventTypeList[(int)index/2] isEqualToString:@"1"])
            {
                [[[UIImage imageNamed:@"diaEvento1"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)] drawInRect:self.bounds];
            }
            // Evento tipo Platica / Conferencia.
            else if ([myCalendar.eventTypeList[(int)index/2] isEqualToString:@"2"])
            {
                [[[UIImage imageNamed:@"diaEvento2"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)] drawInRect:self.bounds];
            }
        }
    }
    // Checa dia de hoy.
    if ([date isEqualToDate:dateToday])
    {
        textFont = [UIFont boldSystemFontOfSize:25.0];
        if (![myCalendar.eventDayList containsObject: date])
            textColor = [UIColor colorWithRed:21.0/255.0 green:170.0/255.0 blue:237.0/255.0 alpha:1];
    }
    // Si este dia esta siendo seleccionado.
    if (self.selectionState != DSLCalendarDayViewNotSelected)
    {
        textColor = [UIColor whiteColor];
        [[[UIImage imageNamed:@"diaSeleccionado"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)] drawInRect:self.bounds];
    }
    // Escribir el num. de dia.
    [textColor set];
    CGSize textSize = [_labelText sizeWithFont:textFont];
    CGRect textRect = CGRectMake(ceilf(CGRectGetMidX(self.bounds) - (textSize.width / 2.0)), ceilf(CGRectGetMidY(self.bounds) - (textSize.height / 2.0)), textSize.width, textSize.height);
    [_labelText drawInRect:textRect withFont:textFont];
}

#pragma GCC diagnostic warning "-Wdeprecated-declarations"
@end