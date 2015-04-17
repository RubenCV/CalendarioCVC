//
//  DetailTableViewController.m
//  MWFeedParser
//
//  Copyright (c) 2010 Michael Waterfall
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  1. The above copyright notice and this permission notice shall be included
//     in all copies or substantial portions of the Software.
//  
//  2. This Software cannot be used to archive or collect data such as (but not
//     limited to) that of events, news, experiences and activities, for the 
//     purpose of any concept relating to diary/journal keeping.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "DetailTableViewController.h"
#import "NSString+HTML.h"
#import <EventKit/EventKit.h>

typedef enum { SectionHeader, SectionDetail } Sections;
typedef enum { SectionHeaderTitle, SectionHeaderDate, SectionHeaderPlace } HeaderRows;
typedef enum { SectionDetailSummary, SectionDetailInformes } DetailRows;

@implementation DetailTableViewController

@synthesize item, dateString, dateStartString, dateEndString, summaryString, placeString, titleString, informesString, descriptionString;

#pragma mark -
#pragma mark Initialization
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

- (id)initWithStyle:(UITableViewStyle)style {
    if ((self = [super initWithStyle:style])) {
		
    }
    return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	
	// Super
    [super viewDidLoad];

    // Default Values
    titleString = @"Evento CVC";
    dateString = @"Horario Pendiente.";
    placeString = @"Lugar:\nITESM";
    descriptionString = @"Descripcion Pendiente.";
    informesString = @"Informes:\n8358 2000 ext.3614\ncvc.mty@servicios.itesm.mx";
    _listaEventosAgregados = [NSMutableArray arrayWithObjects: nil];
    
    // Titulo
    if (item.title)
        titleString =  item.title;
    
	// Fecha
    if (item.summary)
    {
        NSString *haystack = [item.summary stringByConvertingHTMLToPlainText];
        NSString *prefix = @"Cuándo: ";
        NSString *suffix = @"CST";
        if ([haystack rangeOfString:suffix].location == NSNotFound) suffix = @"CDT";
        if ([haystack rangeOfString:suffix].location == NSNotFound) suffix = @"Quién: ";
        if ([haystack rangeOfString:suffix].location == NSNotFound) suffix = @"Dónde: ";
        if ([haystack rangeOfString:suffix].location == NSNotFound) suffix = @"Estado del Evento: ";
        if ([haystack rangeOfString:suffix].location == NSNotFound) suffix = @"Descripción del evento: ";
        if ([haystack rangeOfString:suffix].location == NSNotFound) suffix = @"Informes: ";
        if ([haystack rangeOfString:prefix].location != NSNotFound && [haystack rangeOfString:suffix].location != NSNotFound)
        {
            NSRange prefixRange = [haystack rangeOfString:prefix];
            NSRange suffixRange = [[haystack substringFromIndex:prefixRange.location+prefixRange.length] rangeOfString:suffix];
            NSRange needleRange = NSMakeRange(prefixRange.location+prefix.length, suffixRange.location);
            NSString *needle = [haystack substringWithRange:needleRange];
            
            NSString *auxiliarString = needle;
            prefix = @" a ";
            if ([auxiliarString rangeOfString:prefix].location != NSNotFound)
            {
                NSRange prefixRange = [auxiliarString rangeOfString:prefix];
                NSString *needle = [auxiliarString substringFromIndex:prefixRange.location+prefixRange.length];
                dateStartString = [@"Empieza: " stringByAppendingString: [auxiliarString substringWithRange:NSMakeRange(0, [auxiliarString rangeOfString:prefix].location)]];
                if (needle.length > 7)
                    dateEndString = [@"Finaliza: " stringByAppendingString: needle];
                else
                    dateEndString = [@"Finaliza: " stringByAppendingString: [[dateStartString substringWithRange:NSMakeRange(9,15)] stringByAppendingString: [@" " stringByAppendingString: needle]]];
                dateString = [dateStartString stringByAppendingString: [@"\n" stringByAppendingString: dateEndString]];
            }
            else
                dateString = [@"Empieza: " stringByAppendingString: auxiliarString];
        }
        else
        {
            haystack = item.summary;
            prefix = @"Cuándo: ";
            if ([haystack rangeOfString:@"<"].location != NSNotFound && [haystack rangeOfString:prefix].location != NSNotFound)
            {
                NSRange range = [haystack rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"<"]];
                haystack = [haystack substringWithRange:NSMakeRange(prefix.length, range.location-prefix.length)];
                dateString = [@"Empieza: " stringByAppendingString: haystack];
            }
        }
    }
    
    // Lugar
    if (item.summary)
    {
        NSString *haystack = [item.summary stringByConvertingHTMLToPlainText];
        NSString *prefix = @"Dónde: ";
        NSString *suffix = @"Estado";
        if ([haystack rangeOfString:prefix].location != NSNotFound && [haystack rangeOfString:suffix].location != NSNotFound)
        {
            NSRange prefixRange = [haystack rangeOfString:prefix];
            NSRange suffixRange = [[haystack substringFromIndex:prefixRange.location+prefixRange.length] rangeOfString:suffix];
            NSRange needleRange = NSMakeRange(prefixRange.location+prefixRange.length, suffixRange.location);
            NSString *needle = [haystack substringWithRange:needleRange];
            placeString = [@"Lugar:\n" stringByAppendingString: needle];
        }
    }
	
	// Descripcion
	if (item.summary)
    {
        NSString *haystack = [item.summary stringByConvertingHTMLToPlainText];
        NSString *prefix = @"Descripción del evento: ";
        NSString *suffix = @"Informes";
        if ([haystack rangeOfString:prefix].location != NSNotFound && [haystack rangeOfString:suffix].location != NSNotFound)
        {
            NSRange prefixRange = [haystack rangeOfString:prefix];
            NSRange suffixRange = [[haystack substringFromIndex:prefixRange.location+prefixRange.length] rangeOfString:suffix];
            NSRange needleRange = NSMakeRange(prefixRange.location+prefixRange.length, suffixRange.location);
            NSString *needle = [haystack substringWithRange:needleRange];
            descriptionString = [@"Descripción del evento:\n" stringByAppendingString: needle];
        }
        else
            descriptionString = [@"Descripción del evento:\n" stringByAppendingString: item.title];
    }
    
    // Informes
    if (item.summary)
    {
        NSString *haystack = [item.summary stringByConvertingHTMLToPlainText];
        NSString *prefix = @"Informes ";
        if ([haystack rangeOfString:prefix].location != NSNotFound)
        {
            NSRange prefixRange = [haystack rangeOfString:prefix];
            NSString *needle = [haystack substringFromIndex:prefixRange.location+prefixRange.length];
            informesString = [@"Informes:\n" stringByAppendingString: needle];
        }
    }
    
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	switch (section) {
		case 0: return 3;
		default: return 2;
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // Get cell
	static NSString *CellIdentifier = @"CellA";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	// Display
	cell.textLabel.textColor = [UIColor blackColor];
	cell.textLabel.font = [UIFont systemFontOfSize:15];
	if (item) {
		
		// Display
		switch (indexPath.section) {
			case SectionHeader: {
				
				// Header
				switch (indexPath.row) {
					case SectionHeaderTitle:
						cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
						cell.textLabel.text = titleString;
                        cell.textLabel.numberOfLines = 0;
						break;
					case SectionHeaderDate:
						cell.textLabel.text = dateString;
                        cell.textLabel.numberOfLines = 0;
						break;
                    case SectionHeaderPlace:
                        cell.textLabel.text = placeString;
                        cell.textLabel.numberOfLines = 0;
                        break;
				}
				break;
				
			}
			case SectionDetail: {
                switch (indexPath.row) {
                        
                    // Description
                    case SectionDetailSummary:
                        cell.textLabel.text = descriptionString;
                        cell.textLabel.numberOfLines = 0;
                    break;
                        
                    // Informes
                    case SectionDetailInformes:
                        cell.textLabel.text = informesString;
                        cell.textLabel.numberOfLines = 0;
                        break;
                }
			}
		}
	}
    
    return cell;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = @"Información Pendiente.";
    
    if(indexPath.section == SectionHeader)
    switch (indexPath.row)
    {
        case SectionHeaderTitle:
                text = titleString;
            break;
        case SectionHeaderDate:
                text = dateString;
            break;
        case SectionHeaderPlace:
                text = placeString;
            break;
    }
    
    else if (indexPath.section == SectionDetail)
    switch (indexPath.row)
    {
        case SectionDetailInformes:
                text = informesString;
            break;
        case SectionDetailSummary:
                text = descriptionString;
            break;
    }
    
    CGSize s = [text sizeWithFont:[UIFont systemFontOfSize:15]
                   constrainedToSize:CGSizeMake(self.view.bounds.size.width - 40, MAXFLOAT)  // - 40 For cell padding
                       lineBreakMode:NSLineBreakByWordWrapping];
    return s.height + 16; // Add padding
    
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (indexPath.row == SectionHeaderTitle) {
            EKEventStore *store = [[EKEventStore alloc] init];
            [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                if (!granted) { return; }
                EKEvent *event = [EKEvent eventWithEventStore:store];
                event.title = titleString;
                // TO DO: Usar dateStartString pasandolo por NSDateFormatter
                event.startDate = [NSDate date]; //today
                // TO DO: Usar dateEndString pasandolo por NSDateFormatter
                event.endDate = [event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
                [event setCalendar:[store defaultCalendarForNewEvents]];
                NSError *err = nil;
                [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
                [_listaEventosAgregados addObject:event.eventIdentifier];
                NSString *mensaje = [[NSString alloc] initWithFormat: @"Evento guardado exitosamente."];
                UIAlertView *alerta = [[UIAlertView alloc] initWithTitle: @"Aviso"
                                                                 message: mensaje
                                                                delegate: self
                                                       cancelButtonTitle: @"OK"
                                                       otherButtonTitles: nil];
                [alerta show];
                NSLog(@"Creado");
            }];
    }
    
	// Deselect
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark -
#pragma mark Memory management
#pragma GCC diagnostic warning "-Wdeprecated-declarations"

@end

