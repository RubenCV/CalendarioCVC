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

@implementation DSLCalendarDayView {
    __strong NSCalendar *_calendar;
    __strong NSDate *_dayAsDate;
    __strong NSDateComponents *_day;
    __strong NSString *_labelText;
}

#pragma mark - Initialisation
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.backgroundColor = [UIColor whiteColor];
        _positionInWeek = DSLCalendarDayViewMidWeek;
    }
    
    return self;
}


#pragma mark Properties

- (void)setSelectionState:(DSLCalendarDayViewSelectionState)selectionState {
    _selectionState = selectionState;
    [self setNeedsDisplay];
}

- (void)setDay:(NSDateComponents *)day {
    _calendar = [day calendar];
    _dayAsDate = [day date];
    _day = nil;
    _labelText = [NSString stringWithFormat:@"%ld", (long)day.day];
}

- (NSDateComponents*)day {
    if (_day == nil) {
        _day = [_dayAsDate dslCalendarView_dayWithCalendar:_calendar];
    }
    
    return _day;
}

- (NSDate*)dayAsDate {
    return _dayAsDate;
}

- (void)setInCurrentMonth:(BOOL)inCurrentMonth {
    _inCurrentMonth = inCurrentMonth;
    [self setNeedsDisplay];
}


#pragma mark UIView methods

- (void)drawRect:(CGRect)rect {
    if ([self isMemberOfClass:[DSLCalendarDayView class]]) {
        // If this isn't a subclass of DSLCalendarDayView, use the default drawing
        [self drawBackground];
        [self drawBorders];
        [self drawDayNumber];
    }
}


#pragma mark Drawing
//AQUI PUEDO CAMBIAR EL COLOR DE FONDO PARA LOS DIAS QUE TIENEN EVENTO.
- (void)drawBackground {
    if (self.selectionState == DSLCalendarDayViewNotSelected) {
        
        
        NSUInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSDateComponents *components = [calendar components:flags fromDate:[self.day date]];
        NSDateComponents *componentsOfToday = [calendar components:flags fromDate:[NSDate date]];
        
        NSDate *date = [calendar dateFromComponents:components];
        NSDate *dateToday = [calendar dateFromComponents:componentsOfToday];
        
        // Declarar date formatter.
        NSDateFormatter *mmddccyy = [[NSDateFormatter alloc] init];
        mmddccyy.timeStyle = NSDateFormatterNoStyle;
        mmddccyy.dateFormat = @"dd/MM/yyyy";
        
        /* OBVIAMENTE AQUI HAY QUE HACER UN FEED DE QUE EVENTOS HAY, LOS QUE DECLARO ABAJO SON DE EJEMPLO */
        
        // Cursos
        NSMutableArray *listaCursos;
        NSDate *curso1 = [mmddccyy dateFromString:@"04/03/2015"];
        NSDate *curso2 = [mmddccyy dateFromString:@"13/03/2015"];
        NSDate *curso3 = [mmddccyy dateFromString:@"22/03/2015"];
        listaCursos =  [[NSMutableArray alloc] initWithObjects: curso1, curso2, curso3, nil];
        
        // Conferencias
        NSMutableArray *listaConferencias;
        NSDate *conf1 = [mmddccyy dateFromString:@"18/03/2015"];
        NSDate *conf2 = [mmddccyy dateFromString:@"30/03/2015"];
        listaConferencias =  [[NSMutableArray alloc] initWithObjects: conf1, conf2, nil];
        
        /* TERMINO DECLRAR FECHAS DE EVENTOS */
        
        if (self.isInCurrentMonth) {
            [[UIColor colorWithWhite:245.0 / 255.0 alpha:1.0] setFill];
        }
        else {
                [[UIColor colorWithWhite:225.0 / 255.0 alpha:1.0] setFill];
            }
        
        // Checha dia de hoy.
        if ([date isEqualToDate:dateToday]) {
            [[UIColor lightGrayColor] setFill];
        }
        
        
        // Pseudocodigo para obtener los items
        /*
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
         
         */
        
        
        // Pseudogodigo para agregar a lista de feed
        /*
         
            for(int i = 0; i < listacursos.count; i++){
                if(fechaSeleccionada == listacursos(i).getFechaInicio)
                    addTo array;
         }
         
            array.count = ?
         }
         
         */
        
        // Checa Cursos.
        if([listaCursos containsObject: date]) {
            [[UIColor orangeColor] setFill];
        }
        
        // Checa Conerencias.
        if([listaConferencias containsObject: date]) {
            [[UIColor redColor] setFill];
        }
        
        UIRectFill(self.bounds);
    }
    else {
        switch (self.selectionState) {
            case DSLCalendarDayViewNotSelected:
                break;
                
            case DSLCalendarDayViewStartOfSelection:
                [[[UIImage imageNamed:@"DSLCalendarDaySelection-left"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)] drawInRect:self.bounds];
                break;
                
            case DSLCalendarDayViewEndOfSelection:
                [[[UIImage imageNamed:@"DSLCalendarDaySelection-right"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)] drawInRect:self.bounds];
                break;
                
            case DSLCalendarDayViewWithinSelection:
                [[[UIImage imageNamed:@"DSLCalendarDaySelection-middle"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)] drawInRect:self.bounds];
                break;
                
            case DSLCalendarDayViewWholeSelection:
                [[[UIImage imageNamed:@"DSLCalendarDaySelection"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)] drawInRect:self.bounds];
                break;
        }
    }
}

- (void)drawBorders {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.0);
    
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:255.0/255.0 alpha:1.0].CGColor);
    CGContextMoveToPoint(context, 0.5, self.bounds.size.height - 0.5);
    CGContextAddLineToPoint(context, 0.5, 0.5);
    CGContextAddLineToPoint(context, self.bounds.size.width - 0.5, 0.5);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    if (self.isInCurrentMonth) {
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:205.0/255.0 alpha:1.0].CGColor);
    }
    else {
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:185.0/255.0 alpha:1.0].CGColor);
    }
    CGContextMoveToPoint(context, self.bounds.size.width - 0.5, 0.0);
    CGContextAddLineToPoint(context, self.bounds.size.width - 0.5, self.bounds.size.height - 0.5);
    CGContextAddLineToPoint(context, 0.0, self.bounds.size.height - 0.5);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

- (void)drawDayNumber {
    if (self.selectionState == DSLCalendarDayViewNotSelected) {
        [[UIColor colorWithWhite:66.0/255.0 alpha:1.0] set];
    }
    else {
        [[UIColor whiteColor] set];
    }
    
    UIFont *textFont = [UIFont boldSystemFontOfSize:17.0];
    CGSize textSize = [_labelText sizeWithFont:textFont];
    
    CGRect textRect = CGRectMake(ceilf(CGRectGetMidX(self.bounds) - (textSize.width / 2.0)), ceilf(CGRectGetMidY(self.bounds) - (textSize.height / 2.0)), textSize.width, textSize.height);
    [_labelText drawInRect:textRect withFont:textFont];
}

#pragma GCC diagnostic warning "-Wdeprecated-declarations"
@end
