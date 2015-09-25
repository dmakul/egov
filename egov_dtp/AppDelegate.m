#import <ChameleonFramework/Chameleon.h>
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
    [[UINavigationBar appearance] setTintColor:[UIColor flatOrangeColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor flatBlackColor],
                                                            NSFontAttributeName: [UIFont fontWithName:FontRegular size:ButtonFontSize]
                                                            }];
}

@end
