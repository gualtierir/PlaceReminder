//
//  MarkerList.h
//  PlaceReminder
//
//  Created by Rocco Gualtieri on 28/09/23.
//

#import <Foundation/Foundation.h>
#import "Marker.h"

NS_ASSUME_NONNULL_BEGIN

@interface MarkerList : NSObject

-(void)addMarker:(Marker *)marker;

-(void)removeMarker:(Marker *)marker;

-(NSMutableArray *)getAll;

-(long)size;

-(Marker *)getAtIndex:(NSInteger)index;

-(BOOL)contains:(Marker *)marker;

@end

NS_ASSUME_NONNULL_END
