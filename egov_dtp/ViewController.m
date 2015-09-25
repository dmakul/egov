#import <MISDropdownViewController/MISDropdownViewController.h>
#import <MISDropdownViewController/MISDropdownMenuView.h>
#import <ChameleonFramework/Chameleon.h>
#import <JTProgressHUD/JTProgressHUD.h>
#import "RatingViewController.h"
#import <Masonry/Masonry.h>
#import "UIColor+Helpers.h"
#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "CrashPlace.h"
#import "Macros.h"

@interface ViewController ()

@property (nonatomic) MKMapView *mapView;
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
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
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
    PFQuery *query = [PFQuery queryWithClassName:@"Geoposition"];
    query.limit = 1000;
    [query whereKey:@"type" equalTo:@"Автомобильная авария"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.carCrashList = [objects mutableCopy];
            [self drawAnnotationsFrom:self.carCrashList];
        } else {
            NSLog(@"error");
        }
    }];
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"Geoposition"];
    query2.limit = 1000;
    [query2 whereKey:@"type" equalTo:@"Столкновение с пешеходом"];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.pedestrianCrashList = [objects mutableCopy];
            [JTProgressHUD hideWithTransition:JTProgressHUDTransitionFade];
        } else {
            NSLog(@"error");
        }
    }];
}

#pragma mark - Map View Methods

- (void) drawAnnotationsFrom:(NSMutableArray *) list {
    for(PFObject *object in list) {
        PFGeoPoint *point = object[@"location"];
        CrashPlace *place = [[CrashPlace alloc] initWithCoordinate:CLLocationCoordinate2DMake(point.latitude, point.longitude)];
        [self.mapView addAnnotation:place];
    }
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
