//
//  FavouritesTableViewController.m
//  PlaceReminder
//
//  Created by Rocco Gualtieri on 08/11/23.
//

#import "FavouritesTableViewController.h"
#import "FavouritesTableDetailTableViewController.h"
#import "MapViewController.h"
#import "AddMarkerViewController.h"
#import "MarkerList.h"
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>

@interface FavouritesTableViewController ()<CLLocationManagerDelegate>

@property (nonatomic, strong) MarkerList *list;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) UNUserNotificationCenter *center;

- (void) startMonitoringRegion;
- (void) stopMonitoringAllRegions;
- (void) generateLocalNotification: (NSString *) markerName;
- (void) refreshTableView;
- (void) accessoryButtonPressed:(id) sender;

@end

@implementation FavouritesTableViewController

// used to instantiate the location manager only when it is needed

- (CLLocationManager *)locationManager {
    if(!_locationManager)
        _locationManager = [[CLLocationManager alloc] init];
    return _locationManager;
}

//  Inizia monitoraggio della regione del marker in testa alla lista
- (void)startMonitoringRegion {
    Marker *marker = [self.list getAtIndex:0];
    CLLocationCoordinate2D markerCoordinate = CLLocationCoordinate2DMake(marker.latitude, marker.longitude);
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:markerCoordinate
                                                                 radius:200.0
                                                             identifier:marker.name];
    [self.locationManager startMonitoringForRegion:region];
    NSLog(@"Inizio a monitorare la regione: %@", region.identifier);
}

//  Interrompe il monitoraggio di tutte le regioni monitorate dal locationManager
- (void)stopMonitoringAllRegions {
    for (CLRegion *monitoredRegion in self.locationManager.monitoredRegions) {
        [self.locationManager stopMonitoringForRegion:monitoredRegion];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"I miei luoghi";
    
    self.dataSource = [[MarkerListDataSource alloc] init];
    if(self.dataSource != nil)
        self.list = [self.dataSource getMarkers];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.delegate = self;
    [self stopMonitoringAllRegions];
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
    self.center = [UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions options = UNAuthorizationOptionAlert+UNAuthorizationOptionSound;
    [self.center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"Autorizzazione ottenuta");
        } else {
            if (error) {
                NSLog(@"Errore durante la richiesta di autorizzazione: %@", error.localizedDescription);
            } else {
                NSLog(@"L'utente ha negato l'autorizzazione");
            }
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTableView)
                                                 name:MarkerListChangedNotification object:nil];
    
}

#pragma mark - CLLocationManagerDelegate

//  Ingresso nella regione
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSString *markerName = region.identifier;
    NSLog(@"Sei entrato: %@", markerName);
    [self generateLocalNotification: markerName];
}

//  Genera una notifica locale
- (void)generateLocalNotification: (NSString *) markerName{
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString stringWithFormat:@"Hai raggiunto %@", markerName];
    content.body = @"Sei entrato nella geofence attiva.";
    content.sound = [UNNotificationSound defaultSound];
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    
    NSString *identifier = markerName;
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                          content:content
                                                                          trigger:trigger];
    
    [self.center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Errore nella programmazione della notifica: %@", error.localizedDescription);
        }
    }];
}

//  Errore nel locationManager
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Errore %@", error);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list size];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MarkerCell" forIndexPath:indexPath];
    Marker *m = [self.list getAtIndex:indexPath.row];
    cell.textLabel.text = m.name;
    UIImage* trashImage = [UIImage systemImageNamed:@"trash"];
    UIButton* trashButton = [UIButton systemButtonWithImage:trashImage
                                                     target:self
                                                     action:@selector(accessoryButtonPressed:)];
    trashButton.tag = indexPath.row;
    cell.accessoryView = trashButton;
    return cell;
}

//  Pressione sul bottone del cestino
- (void)accessoryButtonPressed:(id)sender {
    if([sender isKindOfClass:[UIButton class]]) {
        UIButton* button = (UIButton*) sender;
        long idx = button.tag;
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Rimuovi"
                                                                       message:@"Eliminare il luogo selezionato?"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* negativeAction = [UIAlertAction actionWithTitle:@"Annulla"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction* action) {}];
        UIAlertAction* positiveAction = [UIAlertAction actionWithTitle:@"Elimina"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction* action) {
            [self.dataSource deleteMarker:[self.list getAtIndex:idx]];
        }];
        [alert addAction:negativeAction];
        [alert addAction:positiveAction];
        [self presentViewController:alert
                           animated:YES
                         completion:nil];
    }
}

//  Ricarica i dati nella tabella, aggiorna la lista di Marker e inizia a monitorare la nuova regione
- (void)refreshTableView {
    self.list = [self.dataSource getMarkers];
    [self.tableView reloadData];
    if([self.list size] > 0)
        [self startMonitoringRegion];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ShowMarkerDetail"]){
        if([segue.destinationViewController isKindOfClass:[FavouritesTableDetailTableViewController class]]){
            FavouritesTableDetailTableViewController *vc = (FavouritesTableDetailTableViewController *)segue.destinationViewController;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            Marker *m = [self.list getAtIndex:indexPath.row];
            vc.theMarker = m;
        }
    }
    if([segue.identifier isEqualToString:@"ShowMap"]){
        if([segue.destinationViewController isKindOfClass:[MapViewController class]]){
            MapViewController *vc = (MapViewController *)segue.destinationViewController;
            vc.markers = [self.list getAll];
        }
    }
    if([segue.identifier isEqualToString:@"AddMarker"]) {
        if([segue.destinationViewController isKindOfClass:[AddMarkerViewController class]]) {
            AddMarkerViewController* destinationVC = (AddMarkerViewController*) segue.destinationViewController;
            destinationVC.dataSource = self.dataSource;
        }
    }

}

//  Deallocazione observer del refresh della tabella
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MarkerListChangedNotification object:nil];
}

@end
