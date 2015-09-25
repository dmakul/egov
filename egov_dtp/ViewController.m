#import <ChameleonFramework/Chameleon.h>
#import "RatingViewController.h"
#import <Masonry/Masonry.h>
#import "UIColor+Helpers.h"
#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "CrashPlace.h"

@interface ViewController ()

@property (nonatomic) MKMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Карта";
    [self setUpScreen];
}

- (void) setUpScreen {
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    CLLocation *initialLocation = [[CLLocation alloc] initWithLatitude:43.241001 longitude:76.954880];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate, 5000.0, 5000.0);
    [self.mapView setRegion:region];
    [self.view addSubview:self.mapView];
    
    CrashPlace *place = [[CrashPlace alloc] initWithCoordinate:CLLocationCoordinate2DMake(43.241001, 76.954880)];
    [self.mapView addAnnotation:place];
    
    
}


@end
