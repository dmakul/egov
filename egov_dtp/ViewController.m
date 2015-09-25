#import <MISDropdownViewController/MISDropdownViewController.h>
#import <MISDropdownViewController/MISDropdownMenuView.h>
#import <ChameleonFramework/Chameleon.h>
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
    [self downloadList];
}

- (void) setUpScreen {
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    CLLocation *initialLocation = [[CLLocation alloc] initWithLatitude:43.247702 longitude:76.911064];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate, 10000.0, 10000.0);
    [self.mapView setRegion:region];
    [self.view addSubview:self.mapView];
       
    CrashPlace *place = [[CrashPlace alloc] initWithCoordinate:CLLocationCoordinate2DMake(43.241001, 76.954880)];
    [self.mapView addAnnotation:place];
    
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
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.crashList = [objects mutableCopy];
            NSLog(@"%lu" , self.crashList.count);
        } else {

        }
    }];

}


#pragma mark - Helper methods

- (void)dropMenuChanged:(MISDropdownMenuView *)dropDownMenuView {
    [self.dropdownViewController dismissDropdownAnimated:YES];
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
