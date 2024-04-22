//
//  AddMarkerViewController.m
//  PlaceReminder
//
//  Created by Rocco Gualtieri on 11/11/23.
//

#import "AddMarkerViewController.h"
#import "MarkerListDataSource.h"


@interface AddMarkerViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *optionsControl;
@property (weak, nonatomic) IBOutlet UITextField *markerNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *markerDescriptTextField;
@property (weak, nonatomic) IBOutlet UITextField *markerAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *markerLatitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *markerLongitudeTextField;

@end

@implementation AddMarkerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Nuovo Luogo";
        
    self.markerLatitudeTextField.hidden = YES;
    self.markerLongitudeTextField.hidden = YES;
}

//  Gestione della selezione del segmentedControl
- (IBAction)segmentedControlValueChanges:(UISegmentedControl *)sender {
    self.markerLatitudeTextField.hidden = YES;
    self.markerLongitudeTextField.hidden = YES;
    self.markerAddressTextField.hidden = YES;
    if (sender.selectedSegmentIndex == 0) {
        self.markerAddressTextField.hidden = NO;
    } else {
        self.markerLatitudeTextField.hidden = NO;
        self.markerLongitudeTextField.hidden = NO;
    }
}

//  Creazione di un nuovo Marker
- (IBAction)saveMarker:(UIBarButtonItem *)sender {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Errore"
                                                                   message:@"Inserisci i campi obbligatori"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:okAction];
    
    NSString* markerName = self.markerNameTextField.text;
    NSString* markerDescription = self.markerDescriptTextField.text;
    
    if(self.optionsControl.selectedSegmentIndex == 0){
        NSString* markerAddress = self.markerAddressTextField.text;
        if (markerName.length == 0 || markerAddress.length == 0) {
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        Marker* marker = [[Marker alloc] initWithName:markerName
                                              address:markerAddress
                                             descript:markerDescription];
        [self.dataSource insertMarker:marker];
        
    } else {
        NSString* markerLatitudeString = self.markerLatitudeTextField.text;
        NSString* markerLongitudeString = self.markerLongitudeTextField.text;
        if (markerName.length == 0 || markerLatitudeString.length == 0 || markerLongitudeString.length == 0) {
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setDecimalSeparator:@"."];
        NSNumber *markerLatitudeNumber = [formatter numberFromString:markerLatitudeString];
        NSNumber *markerLongitudeNumber = [formatter numberFromString:markerLongitudeString];

        if (!markerLatitudeNumber || !markerLongitudeNumber) {
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        
        double markerLatitude = [markerLatitudeNumber doubleValue];
        double markerLongitude = [markerLongitudeNumber doubleValue];
        
        Marker* marker = [[Marker alloc] initWithName:markerName
                                               latitude:markerLatitude
                                            longitude:markerLongitude
                                              descript:markerDescription];
        [self.dataSource insertMarker:marker];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
