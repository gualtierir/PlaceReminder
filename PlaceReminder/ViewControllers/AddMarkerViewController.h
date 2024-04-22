//
//  AddMarkerViewController.h
//  PlaceReminder
//
//  Created by Rocco Gualtieri on 11/11/23.
//

#import <UIKit/UIKit.h>
#import "MarkerListDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddMarkerViewController : UIViewController

@property (strong, nonatomic) MarkerListDataSource *dataSource;

@end

NS_ASSUME_NONNULL_END
