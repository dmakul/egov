#import <MISDropdownViewController/MISDropdownViewController.h>
#import <MISDropdownViewController/MISDropdownMenuView.h>
#import <ChameleonFramework/Chameleon.h>
#import <JTProgressHUD/JTProgressHUD.h>
#import <REVClusterMap/REVClusterMap.h>
#import "CustomAnnotationView.h"
#import "RatingViewController.h"
#import <Masonry/Masonry.h>
#import "UIColor+Helpers.h"
#import "UIImage+Helpers.h"
#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "CrashPlace.h"
#import "Macros.h"

@interface ViewController () <MKMapViewDelegate>

@property (nonatomic) REVClusterMapView *mapView;
//@property (nonatomic) MKMapView *mapView;
@property (strong, nonatomic) MISDropdownViewController *dropdownViewController;
@property (strong, nonatomic) MISDropdownMenuView *dropdownMenuView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Карта";
    [self setUpScreen];
    [JTProgressHUD showWithTransition:JTProgressHUDTransitionFade];
    [self downloadList];
}

- (void) setUpScreen {
//    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:self.mapView];
    
    self.mapView = [[REVClusterMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    CLLocation *initialLocation = [[CLLocation alloc] initWithLatitude:43.247702 longitude:76.911064];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate, 15000.0, 15000.0);
    [self.mapView setRegion:region];
    [self.view addSubview:self.mapView];

    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Фильтр" style:UIBarButtonItemStyleDone target:self action:@selector(toggleMenu:)];
    [leftButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:FontRegular size:TextFieldFontSize], NSFontAttributeName,
                                        nil] 
                              forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    self.dropdownMenuView = [[MISDropdownMenuView alloc] initWithItems:@[@"Автомобильная авария", @"Столкновение с пешеходом"]];
    self.dropdownMenuView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.dropdownMenuView addTarget:self action:@selector(dropMenuChanged:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Parse methods

- (void) downloadList {
    self.carCrashList = [NSMutableArray new];
    PFQuery *query = [PFQuery queryWithClassName:@"Geoposition"];
    query.limit = 1000;
    [query whereKey:@"type" equalTo:@"Автомобильная авария"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for(PFObject *object in objects) {
                REVClusterPin *pin = [[REVClusterPin alloc] init];
                PFGeoPoint *point = object[@"location"];
                pin.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude);
                [self.carCrashList addObject:pin];
            }
            [self drawAnnotationsFrom:self.carCrashList];
            [JTProgressHUD hideWithTransition:JTProgressHUDTransitionFade];
        } else {
            NSLog(@"error");
        }
    }];
    
    self.pedestrianCrashList = [NSMutableArray new];
    PFQuery *query2 = [PFQuery queryWithClassName:@"Geoposition"];
    query2.limit = 1000;
    [query2 whereKey:@"type" equalTo:@"Столкновение с пешеходом"];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for(PFObject *object in objects) {
                REVClusterPin *pin = [[REVClusterPin alloc] init];
                PFGeoPoint *point = object[@"location"];
                pin.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude);
                [self.pedestrianCrashList addObject:pin];
            }
            [JTProgressHUD hideWithTransition:JTProgressHUDTransitionFade];
        } else {
            NSLog(@"error");
        }
    }];
}

#pragma mark - Map View Methods

- (void) drawAnnotationsFrom:(NSMutableArray *) list {
    [self.mapView addAnnotations:list];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation class] == MKUserLocation.class) {
        //userLocation = annotation;
        return nil;
    }
    
    REVClusterPin *pin = (REVClusterPin *)annotation;
    
    CustomAnnotationView *annView;
    
    if( [pin nodeCount] > 0 ){
        pin.title = @"___";
        
        [mapView dequeueReusableAnnotationViewWithIdentifier:@"cluster"];
        
        if( !annView )
            annView = (CustomAnnotationView*)
            [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"cluster"];
        
        if([pin nodeCount] < 30) {
            annView.image = [[UIImage imageNamed:@"green"] scaledToSize:CGSizeMake(35, 35)];
        } else if ([pin nodeCount] <= 50) {
            annView.image = [[UIImage imageNamed:@"orange"] scaledToSize:CGSizeMake(35, 35)];
        } else {
            annView.image = [[UIImage imageNamed:@"red"] scaledToSize:CGSizeMake(35, 35)];
        }
        
        [(CustomAnnotationView*)annView setClusterText:
         [NSString stringWithFormat:@"%lu",(unsigned long)[pin nodeCount]]];
        
        annView.canShowCallout = NO;
    } else {
        annView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
        
        if( !annView )
            annView = (CustomAnnotationView *)[[MKAnnotationView alloc] initWithAnnotation:annotation
                                                    reuseIdentifier:@"pin"];
        
        annView.image = [[UIImage imageNamed:@"point"] scaledToSize:CGSizeMake(17, 30)];
        annView.canShowCallout = YES;
        
        annView.calloutOffset = CGPointMake(-6.0, 0.0);
    }
    return annView;
}


#pragma mark - Helper methods

- (void)dropMenuChanged:(MISDropdownMenuView *)dropDownMenuView {
    [self.dropdownViewController dismissDropdownAnimated:YES];
    NSInteger selectedItemIndex = [dropDownMenuView selectedItemIndex];
    if (selectedItemIndex == 1) {
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self drawAnnotationsFrom:self.pedestrianCrashList];
    } else {
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self drawAnnotationsFrom:self.carCrashList];
    }
}

- (void)toggleMenu:(id)sender {
    if (self.dropdownViewController == nil) {
        // Prepare content view
        CGFloat width = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 320.0 : self.view.bounds.size.width;
        CGSize size = [self.dropdownMenuView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
        self.dropdownMenuView.frame = CGRectMake(self.dropdownMenuView.frame.origin.x, self.dropdownMenuView.frame.origin.y, size.width, size.height);
        
        self.dropdownViewController = [[MISDropdownViewController alloc] initWithPresentationMode:MISDropdownViewControllerPresentationModeAutomatic];
        self.dropdownViewController.contentView = self.dropdownMenuView;
    }
    
    // Show/hide dropdown view
    if ([self.dropdownViewController isDropdownVisible]) {
        [self.dropdownViewController dismissDropdownAnimated:YES];
        return;
    }
    
    // Sender is UIBarButtonItem
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        [self.dropdownViewController presentDropdownFromBarButtonItem:sender inViewController:self position:MISDropdownViewControllerPositionTop];
        return;
    }
    
    // Sender is UIButton
    CGRect rect = [sender convertRect:[sender bounds] toView:self.view];
    [self.dropdownViewController presentDropdownFromRect:rect inViewController:self position:MISDropdownViewControllerPositionBottom];
}


@end
