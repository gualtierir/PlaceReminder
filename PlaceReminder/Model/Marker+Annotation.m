//
//  Marker+Annotation.m
//  PlaceReminder
//
//  Created by Rocco Gualtieri on 03/10/23.
//
//  Dati del marker sulla mappa

#import "Marker+Annotation.h"

@implementation Marker(Annotation)

-(CLLocationCoordinate2D) coordinate{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.latitude;
    coordinate.longitude = self.longitude;
    return coordinate;
}

- (NSString *)title {
    return self.name;
}

- (NSString *)subtitle{
    return [NSString stringWithFormat:@"Aggiunto il %@", self.dateCreation];
}

@end
