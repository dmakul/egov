#import <MapKit/MapKit.h>

@interface CustomAnnotationView : MKAnnotationView <MKAnnotation>

@property (nonatomic) UILabel *label;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (void) setClusterText:(NSString *)text;

@end
