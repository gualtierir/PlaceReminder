//
//  MapViewController.m
//  PlaceReminder
//
//  Created by Rocco Gualtieri on 09/11/23.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "Marker+Annotation.h"
#import "FavouritesTableDetailTableViewController.h"

@interface MapViewController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (void) centerMapToLocation:(CLLocationCoordinate2D)location
                        zoom:(double)zoom;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    //  Centra la mappa sull'ultimo marker inserito
    if([self.markers count] > 0){
        Marker *lastMarker = [self.markers objectAtIndex:0];
        CLLocationCoordinate2D lastMarkerCoordinate = CLLocationCoordinate2DMake(lastMarker.latitude, lastMarker.longitude);
        [self centerMapToLocation:lastMarkerCoordinate zoom:10.0];
    }
    
    //  Aggiunge le annotazioni ai marker
    [self.markers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[Marker class]]){
            Marker *m = (Marker *)obj;
            [self.mapView addAnnotation:m];
        }
    }];
}

//  Restituzione di una vista di annotazione
- (MKAnnotationView *) mapView:(MKMapView *)mapView
             viewForAnnotation:(id<MKAnnotation>)annotation{
    
    static NSString *AnnotationIdentifer = @"MapAnnotationView";
    
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifer];
    
    if(!view){
        view = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation
                                               reuseIdentifier:AnnotationIdentifer];
        view.canShowCallout = YES;
    }
    
    view.annotation = annotation;
    
    view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoDark];
    
    return view;
    
}

//  Transizione dopo il tocco sul bottone info
- (void) mapView:(MKMapView *)mapView
        annotationView:(MKAnnotationView *)view
        calloutAccessoryControlTapped:(UIControl *)control{
    if([control isEqual:view.rightCalloutAccessoryView]){
        [self performSegueWithIdentifier:@"ShowMarkerFromMap" sender:view];
    }
}

//  Centra la mappa
- (void) centerMapToLocation:(CLLocationCoordinate2D)location
                        zoom:(double)zoom{
    MKCoordinateRegion mapRegion;
    mapRegion.center = location;
    mapRegion.span.latitudeDelta = zoom;
    mapRegion.span.longitudeDelta = zoom;
    [self.mapView setRegion:mapRegion];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ShowMarkerFromMap"]){
        if([segue.destinationViewController isKindOfClass:[FavouritesTableDetailTableViewController class]]){
            FavouritesTableDetailTableViewController *vc = (FavouritesTableDetailTableViewController *)segue.destinationViewController;
            if([sender isKindOfClass:[MKAnnotationView class]]){
                MKAnnotationView *view = (MKAnnotationView *)sender;
                id<MKAnnotation> annotation = view.annotation;
                if([annotation isKindOfClass:[Marker class]]){
                    Marker *m = (Marker *)annotation;
                    vc.theMarker = m;
                }
            }
        }
    }
}

@end
