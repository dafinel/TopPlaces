//
//  MyFlickr.m
//  TopPlaces
//
//  Created by Andrei-Daniel Anton on 28/07/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "MyFlickr.h"

@implementation MyFlickr

+ (NSString *)getCountry:(NSDictionary *)place{
    return [[[place valueForKey:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "] lastObject];
}

+ (NSDictionary *)placesByContries:(NSArray *)places {
    NSMutableDictionary *placesbyCountries = [NSMutableDictionary dictionary];
    for (NSDictionary *place in places) {
        NSString *country = [MyFlickr getCountry:place];
        NSMutableArray *placesOfCountry = placesbyCountries[country];
        if (!placesOfCountry) {
            placesOfCountry = [NSMutableArray array];
            placesbyCountries[country] = placesOfCountry;
        }
        [placesOfCountry addObject:place];
    }
    
    return placesbyCountries;
}

+ (NSArray *)countrieOfPlaces:(NSDictionary *)placesByContries {
    NSArray *countries = [placesByContries allKeys];
    countries = [countries sortedArrayUsingSelector:@selector(compare:)];
    return countries;
}

+ (void)loadPhotoForPlace:(NSDictionary *)place maxResults:(NSUInteger)maxresults {
    NSURL *url = [self URLforPhotosInPlace:[place valueForKey:FLICKR_PLACE_ID] maxResults:maxresults];
    dispatch_queue_t photoForPlaceQ = dispatch_queue_create("Photo For Place", NULL);
    dispatch_async(photoForPlaceQ, ^{
        NSData *jsonResult = [NSData dataWithContentsOfURL:url];
        NSDictionary *propertyList = [NSJSONSerialization JSONObjectWithData:jsonResult
                                                                     options:0
                                                                       error:NULL];
        NSArray *photos = [propertyList valueForKeyPath:FLICKR_PLACE_NAME];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
    
    
}

@end
