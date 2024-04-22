//
//  MarkersDataSource.h
//  PlaceReminder
//
//  Created by Rocco Gualtieri on 02/10/23.
//

#import <Foundation/Foundation.h>
#import "MarkerList.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MarkersDataSource <NSObject>

-(MarkerList *)getMarkers;

- (void) insertMarker:(Marker*) marker;

- (void) deleteMarker:(Marker*) marker;

@end

NS_ASSUME_NONNULL_END
