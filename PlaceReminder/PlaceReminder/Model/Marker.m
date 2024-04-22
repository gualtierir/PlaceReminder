//
//  Marker.m
//  PlaceReminder
//
//  Created by Rocco Gualtieri on 27/09/23.
//

#import "Marker.h"
#import <CoreLocation/CoreLocation.h>

@implementation Marker

//Inizializzatore con coordinate
-(instancetype) initWithName:(NSString *)name
                    latitude:(double)latitude
                   longitude:(double)longitude
                    descript:(NSString *)descript {
    if(self = [super init]) {
        _name = [name copy];
        _latitude = latitude;
        _longitude = longitude;
        _descript = [descript copy];
        
        //Reverse geocode
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude 
                                                          longitude:longitude];
        [geocoder reverseGeocodeLocation:location
                       completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error) {
                NSLog(@"Geocode fallito: %@", error);
                return;
            }
            if (placemarks.count > 0) {
                CLPlacemark *placemark = [placemarks firstObject];
                self->_address = [placemark.addressDictionary[@"FormattedAddressLines"]
                                  componentsJoinedByString:@", "];
            }
        }];
                
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"it_IT"]];
        [formatter setDateFormat:@"d MMMM yyyy '-' h:mm"];
        _dateCreation = [formatter stringFromDate:currentDate];
    }
    return self;
}

//Inizializzatore con indirizzo
-(instancetype) initWithName:(NSString *)name
                    address:(NSString *)address
                    descript:(NSString *)descript{
    if(self = [super init]) {
        _name = [name copy];
        _address = [address copy];
        _descript = [descript copy];
        
        //Geocode
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:address
                     completionHandler:^(NSArray *placemarks, NSError *error) {
            if (placemarks.count > 0) {
                CLPlacemark *placemark = [placemarks firstObject];
                // Estrai le coordinate dal placemark
                CLLocation *location = placemark.location;
                self->_latitude = location.coordinate.latitude;
                self->_longitude = location.coordinate.longitude;
            }
        }];
        
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"it_IT"]];
        [formatter setDateFormat:@"d MMMM yyyy '-' HH:mm"];
        _dateCreation = [formatter stringFromDate:currentDate];
    }
    return self;
}

@end
