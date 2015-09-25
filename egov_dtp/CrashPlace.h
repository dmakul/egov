#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CrashPlace : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;

- (instancetype) initWithCoordinate:(CLLocationCoordinate2D) coordinate;
//123
@end
