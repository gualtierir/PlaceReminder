//
//  MarkerListDataSource.m
//  PlaceReminder
//
//  Created by Rocco Gualtieri on 02/10/23.
//

#import "MarkerListDataSource.h"
#import "MarkerList.h"

NSString *const MarkerListChangedNotification = @"MarkerListChangedNotification";

@interface MarkerListDataSource()

@property (strong, nonatomic) MarkerList *list;

@end

@implementation MarkerListDataSource

-(instancetype)init {
    if(self = [super init]) {
        _list = [[MarkerList alloc] init];
    }
    return self;
}

//Ottiene tutti i marker
-(MarkerList *)getMarkers {
    return self.list;
}

//Inserimento marker e notifica della modifica
- (void)insertMarker:(nonnull Marker *)marker {
    [self.list addMarker:marker];
    [[NSNotificationCenter defaultCenter] postNotificationName:MarkerListChangedNotification
                                                        object:self];
}

//Rimozione marker e notifica della modifica
- (void)deleteMarker:(nonnull Marker *)marker {
    [self.list removeMarker:marker];
    [[NSNotificationCenter defaultCenter] postNotificationName:MarkerListChangedNotification
                                                        object:self];
}

@end
