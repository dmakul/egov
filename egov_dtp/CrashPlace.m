#import "CrashPlace.h"

@implementation CrashPlace

-(instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    
    if(self) {
        self.coordinate = coordinate;
    }
    
    return self;
}

@end
