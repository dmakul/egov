#import "ViewController.h"
#import "AppDelegate.h"
#import "Macros.h"

@interface AppDelegate ()

@property (nonatomic) ViewController *VC;
@property (nonatomic) UINavigationController *navVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    
    self.VC = [[ViewController alloc] init];
    self.navVC = [[UINavigationController alloc] init];
    [self.navVC setViewControllers:[NSArray arrayWithObject:self.VC]];
    [self.window setRootViewController:self.navVC];
    [self setUpNavigationBar];
    
    
    return YES;
}

- (void)setUpNavigationBar {
//    [[UINavigationBar appearance] setBackIndicatorImage:[[UIImage imageNamed:@"back"] scaledToSize:CGSizeMake(25, 20)]];
//    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[[UIImage imageNamed:@"back"] scaledToSize:CGSizeMake(25, 20)]];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor blackColor],
                                                            NSFontAttributeName: [UIFont fontWithName:FontMedium size:ButtonFontSize]
                                                            }];
}

@end
