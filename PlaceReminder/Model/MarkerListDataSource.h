//
//  MarkerListDataSource.h
//  PlaceReminder
//
//  Created by Rocco Gualtieri on 02/10/23.
//

#import <Foundation/Foundation.h>
#import "MarkersDataSource.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const MarkerListChangedNotification;

@interface MarkerListDataSource : NSObject<MarkersDataSource>

@end

NS_ASSUME_NONNULL_END
