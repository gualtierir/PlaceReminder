//
//  FavouritesTableViewController.h
//  PlaceReminder
//
//  Created by Rocco Gualtieri on 08/11/23.
//

#import <UIKit/UIKit.h>
#import "MarkerListDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface FavouritesTableViewController : UITableViewController

@property (strong, nonatomic) MarkerListDataSource *dataSource;

@end

NS_ASSUME_NONNULL_END
