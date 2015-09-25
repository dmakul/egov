#import <ChameleonFramework/Chameleon.h>
#import "RatingViewController.h"
#import "UIColor+Helpers.h"
#import "Macros.h"

@interface RatingViewController ()

@end

@implementation RatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpScreen];
    self.title = @"Рейтинг";
}

- (void) setUpScreen {
    [self.view setBackgroundColor:[UIColor colorFromHexString:MainColor]];

}

@end
