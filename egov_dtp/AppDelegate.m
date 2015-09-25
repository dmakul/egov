#import <ChameleonFramework/Chameleon.h>
#import "RatingViewController.h"
#import "UIImage+Helpers.h"
#import "ViewController.h"
#import "UIColor+Helpers.h"
#import "AppDelegate.h"
#import "Macros.h"

@interface AppDelegate ()

@property (nonatomic) ViewController *mapVC;
@property (nonatomic) RatingViewController *ratingVC;
@property (nonatomic) UINavigationController *mapNavVC;
@property (nonatomic) UINavigationController *ratingNavVC2;
@property (nonatomic) UITabBarController *tabBarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    
    //Create view controllers
    self.mapVC = [[ViewController alloc] init];
    self.ratingVC = [[RatingViewController alloc] init];
    
    //create first navigation controllers
    self.mapNavVC = [[UINavigationController alloc] init];
    [self.mapNavVC setViewControllers:[NSArray arrayWithObject:self.mapVC]];
    
    //create second navigation controller
    self.ratingNavVC2 = [[UINavigationController alloc] init];
    [self.ratingNavVC2 setViewControllers:[NSArray arrayWithObject:self.ratingVC]];
    
    //create tab bar
    self.tabBarController = [[UITabBarController alloc] init];
    NSArray* controllers = [NSArray arrayWithObjects:self.mapNavVC, self.ratingNavVC2, nil];
    self.tabBarController.viewControllers = controllers;

    //setups
    [self setUpTabBar];
    [self setUpNavigationBar];
    
    [self.window setRootViewController:self.tabBarController];
    
    return YES;
}

- (void)setUpNavigationBar {
    [[UINavigationBar appearance] setTintColor:[UIColor flatOrangeColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor flatBlackColor],
                                                            NSFontAttributeName: [UIFont fontWithName:FontRegular size:ButtonFontSize]
                                                            }];
}

- (void) setUpTabBar {
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:FontMedium size:13.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBar appearance] setTintColor:[UIColor colorFromHexString:@"#FF6A30"]];
    
    int index = 0;
    for(UITabBarItem *item in self.tabBarController.tabBar.items) {
        if(index == 0) {
            UIImage *image = [[UIImage imageNamed:@"map"] scaledToSize:CGSizeMake(25, 25)];
            item.image = image;
        } else {
            UIImage *image = [[UIImage imageNamed:@"rating"] scaledToSize:CGSizeMake(25, 25)];
            item.title = @"Рейтинг";
            item.image = image;
        }
        index++;
    }
}

@end
