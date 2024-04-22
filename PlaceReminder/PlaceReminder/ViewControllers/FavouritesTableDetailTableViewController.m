//
//  FavouritesTableDetailTableViewController.m
//  PlaceReminder
//
//  Created by Rocco Gualtieri on 08/11/23.
//

#import "FavouritesTableDetailTableViewController.h"
#import "MarkerList.h"
#import "MarkerListDataSource.h"

@interface FavouritesTableDetailTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateCreationLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptLabel;

@end

@implementation FavouritesTableDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.theMarker.name;
    self.nameLabel.text = self.theMarker.name;
    self.addressLabel.text = self.theMarker.address;
    self.latitudeLabel.text = [NSString stringWithFormat:@"%f", self.theMarker.latitude];
    self.longitudeLabel.text = [NSString stringWithFormat:@"%f", self.theMarker.longitude];
    self.dateCreationLabel.text = self.theMarker.dateCreation;
    self.descriptLabel.text = self.theMarker.descript;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
