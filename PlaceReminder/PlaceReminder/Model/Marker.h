//
//  Marker.h
//  PlaceReminder
//
//  Created by Rocco Gualtieri on 27/09/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Marker : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property double latitude;
@property double longitude;
@property (strong, nonatomic) NSString *descript;
@property (strong, nonatomic) NSString *dateCreation;

-(instancetype) initWithName:(NSString *)name
                    latitude:(double) latitude
                   longitude:(double) longitude
                    descript:(NSString *)descript;

-(instancetype) initWithName:(NSString *)name
                    address:(NSString *) address
                    descript:(NSString *)descript;

@end

NS_ASSUME_NONNULL_END
