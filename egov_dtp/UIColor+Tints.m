#import "UIColor+Tints.h"
@implementation UIColor (Tints)
#define AGEColorImplement(COLOR_NAME,RED,GREEN,BLUE,ALPHA)    \
+ (UIColor *)COLOR_NAME{    \
static UIColor* COLOR_NAME##_color;    \
static dispatch_once_t COLOR_NAME##_onceToken;   \
dispatch_once(&COLOR_NAME##_onceToken, ^{    \
COLOR_NAME##_color = [UIColor colorWithRed:RED green:GREEN blue:BLUE alpha:ALPHA];  \
}); \
return COLOR_NAME##_color;  \
}
+(instancetype)primaryColor{
    return [UIColor flatMintColor];
}
+(instancetype)secondaryColor{
    return [[UIColor flatMintColor] colorWithAlphaComponent:0.8f];
}
+(instancetype)thirdColor{
    return [[UIColor flatMintColor] colorWithAlphaComponent:0.6f];
}
//AGEColorImplement(primaryColor, 22.f/255.f, 118.f/255.f, 165.f/255.f, 1.0);
//AGEColorImplement(headerColor, 22.f/255.f, 118.f/255.f, 165.f/255.f, 0.8);
@end