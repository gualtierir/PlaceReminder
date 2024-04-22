//
//  FavouritesTableDetailTableViewController.h
//  PlaceReminder
//
//  Created by Rocco Gualtieri on 08/11/23.
//

#import <UIKit/UIKit.h>
#import "Marker.h"
#import "MarkerListDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface FavouritesTableDetailTableViewController : UITableViewController

@property (nonatomic, strong) Marker *theMarker;

@end

NS_ASSUME_NONNULL_END
