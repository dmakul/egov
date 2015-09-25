#import "CustomAnnotationView.h"
#import "Macros.h"

@implementation CustomAnnotationView

- (id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(4, 5, 26, 26)];
        [self addSubview:self.label];
        self.label.textColor = [UIColor whiteColor];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.font = [UIFont fontWithName:FontMedium size:13.0f];
        self.label.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void) setClusterText:(NSString *)text {
    self.label.text = text;
}

@end
