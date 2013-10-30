//
//  ViewController.m
//  datascript
//
//  Created by Kalai Wei on 10/28/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//
// A simple brute force algorithm to parse muni stops
// data from the Nextbus API
// Output to file in this form:
// [Stops stopsId:@"5645" title:@"Market St & 5th St" sId:@"15645" dTag:@"F__IBCTRO" rId:@"F"],


#import "ViewController.h"
#import "Data.h"
#import "Stops.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *url = [[NSURL alloc] initWithString:@"http://webservices.nextbus.com/service/publicXMLFeed?command=routeConfig&a=sf-muni"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    // this will perform a synchronous GET operation passing the values you specified in the header (typically you want asynchrounous, but for simplicity of answering the question it works)
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSString *route;
    NSString *direction;
    NSString *name;
    NSString *title;
    NSString *stopid;
    NSScanner *theScanner = [NSScanner scannerWithString:responseString];
    while ([theScanner isAtEnd] == NO) {
        [theScanner scanUpToString:@"route tag=\"" intoString:NULL];
        [theScanner scanString:@"route tag=\"" intoString:NULL];
        [theScanner scanUpToString:@"\"" intoString:&route];
    
        if ([theScanner isAtEnd] == NO) {
            NSString *tmp;
            NSString *path;
            [theScanner scanUpToString:@"direction tag=\"" intoString:&tmp];
            NSScanner *tmpScanner = [NSScanner scannerWithString:tmp];
            NSMutableArray *rarray = [[NSMutableArray alloc] init];
            [tmpScanner scanUpToString:@"stop tag" intoString:NULL];
            
            // this will generate an array of stops for the routes
            while ([tmpScanner isAtEnd] == NO) {
                [tmpScanner scanString:@"stop tag=\"" intoString:NULL];
                [tmpScanner scanUpToString:@"\"" intoString:&name];
                [tmpScanner scanString:@"\" title=\"" intoString:NULL];
                [tmpScanner scanUpToString:@"\"" intoString:&title];
                [tmpScanner scanUpToString:@"stopId" intoString:NULL];
                [tmpScanner scanString:@"stopId=\"" intoString:NULL];
                [tmpScanner scanUpToString:@"\"" intoString:&stopid];
                // tmp contains stops detail info
                [rarray addObject:[Stops stopsId:name title:title stopid:stopid]];
                [tmpScanner scanUpToString:@"stop tag" intoString:NULL];
            }
            
            // got the stops detail for the route, now parse the stops for each
            // of its directions
            [theScanner scanString:@"direction tag=\"" intoString:NULL];
            [theScanner scanUpToString:@"\"" intoString:&direction];
            if ([direction length] <= 0)
                break;
            // this will generate an array of stops for the direction,
            // and we will look up the detailed information using rarray
            while ([direction hasPrefix:route] || [direction hasPrefix:[NSString stringWithFormat:@"0%@", route]]) {
                NSString *tmp2;
                [theScanner scanUpToString:@"</direction>" intoString:&tmp2];
                NSScanner *tmpScanner2 = [NSScanner scannerWithString:tmp2];
                // tmp contains stops for current direction
                NSMutableArray *darray = [[NSMutableArray alloc] init];
                [tmpScanner2 scanUpToString:@"stop tag" intoString:NULL];
                while ([tmpScanner2 isAtEnd] == NO) {
                    [tmpScanner2 scanString:@"stop tag=\"" intoString:NULL];
                    [tmpScanner2 scanUpToString:@"\"" intoString:&name];
                    // tmp contains stops detail info
                    [darray addObject:name];
                    [tmpScanner2 scanUpToString:@"stop tag" intoString:NULL];
                }
                //search for the title, direction, and stop id for the matching stop
                for (NSInteger ii = 0; ii < [darray count]; ii++) {
                    Data* current = [[Data alloc] init];
                    current.name = [darray objectAtIndex:ii];
                    current.direction = direction;
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name MATCHES %@", current.name];
                    NSArray *results = [rarray filteredArrayUsingPredicate:predicate];
                    current.title = [[[results objectAtIndex:0] title] stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
                    current.stopid = [[results objectAtIndex:0] stopid];
                    [darray setObject:[NSString stringWithFormat:@"[Stops stopsId:@\"%@\" title:@\"%@\" sId:@\"%@\" dTag:@\"%@\" rId:@\"%@\"]",current.name,current.title,current.stopid,current.direction,route] atIndexedSubscript:ii];
                }

                NSString* arrayToFile = [darray componentsJoinedByString:@",\n"];
                [Data writeToTextFile:arrayToFile dir:direction];
                
                [theScanner scanString:@"</direction>" intoString:NULL];
                [theScanner scanString:@"<path>" intoString:&path];
                if ([path isEqualToString:@"<path>"]) {
                    break;
                }
                [theScanner scanUpToString:@"direction tag" intoString:&tmp2];
                [theScanner scanString:@"direction tag=\"" intoString:NULL];
                [theScanner scanUpToString:@"\"" intoString:&direction];
                if ([direction length] <= 0)
                    break;
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
