//
//  ViewController.m
//  BSMoveAnno
//
//  Created by VanRyan on 15/5/10.
//  Copyright (c) 2015年 VRyan. All rights reserved.
//

@import MapKit;
#import "ViewController.h"
#import "BSCore.h"

#define ARC4RANDOM_MAX 0x100000000 // 4294967296; Better accuracy than RAND_MAX, i.e. 0x7fffffff (2147483647)

static CLLocationCoordinate2D const mapViewDefaultCenter = (CLLocationCoordinate2D){ 39.985793, 116.357346 };
static CLLocationDistance const mapViewDefaultSpanInMeters = 3000;
static NSUInteger const planesNum = 11;

@interface ViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (assign, nonatomic) MKCoordinateRegion region;

@property (strong, nonatomic) MovingPlanesAnimator *animator;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupMapView];
    [self setupPlanes];
    [self.animator startAnimating];
}

- (void)setupMapView {
    // Define the MKMapView's delegate. Inneglectable basis for the customization of the MKAnnotationView
    self.mapView.delegate = self;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(mapViewDefaultCenter, mapViewDefaultSpanInMeters,mapViewDefaultSpanInMeters);
    [self.mapView setRegion:region];
    self.region = region;
    
}

- (void)setupPlanes {
    self.animator = [[MovingPlanesAnimator alloc] init];
    
    for(NSInteger i=0;i<planesNum;i++){
        MovePath *path = [[MovePath alloc] init];
        
        CLLocationCoordinate2D start = [self randomCoordinateInRegion:self.region];
        CLLocationCoordinate2D end = [self randomCoordinateInRegion:self.region];
        
        [path addSegment:movePathSegmentMake(start, end, [self randomDoubleBetweenMin:5 max:10])];
        
        MovingPlane *plane =[[MovingPlane alloc] init];
        
        plane.coordinate = start; //initiate the plane's position
        plane.movePath   = path;
        
        //KVO for the moving status of the plane
        [plane addObserver:self forKeyPath:@"moving" options:NSKeyValueObservingOptionNew context:NULL];
        
        //Draw the plane
        [self.mapView addAnnotation:plane];
        
        plane.title = @"Aeroplane";
        plane.subtitle = [NSString stringWithFormat:@"No.%ld",i];
    
        //MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        //[[self.mapView viewForAnnotation:point] setTag:1];
        //UIImage *image = [UIImage imageNamed:@"plane.png"];
        //[[self.mapView viewForAnnotation:plane] setImage:image];
        
        //[self.animator addAnnotation:plane];
        [self.animator addPlane:plane];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    else if ([annotation isKindOfClass:[MovingPlane class]]) //Check if the custom annotation class
    {
        NSString * const identifier = @"MovingPlane";
        
        MovingPlane *customAnno = (MovingPlane *)annotation;
        
        MKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView)
        {
            annotationView.annotation = annotation;
        }
        else
        {
            //annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView = customAnno.planeAnnoView;
        }
        
        // set your annotationView properties
        //
        //annotationView.image = [UIImage imageNamed:@"plane.png"];
        //annotationView.canShowCallout = YES;
        
        // if you add QuartzCore to your project, you can set shadows for your image
        //
        [annotationView.layer setShadowColor:[UIColor blackColor].CGColor];
        [annotationView.layer setShadowOpacity:1.0f];
        [annotationView.layer setShadowRadius:5.0f];
        [annotationView.layer setShadowOffset:CGSizeMake(0, 0)];
        //[annotationView setBackgroundColor:[UIColor whiteColor]];
        
        return annotationView;
    }
    
    return nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"moving"]) {
        BOOL moving = [change[NSKeyValueChangeNewKey] boolValue];
        if (!moving) {
            MovingPlane *plane = object;
            if ([plane.movePath isEmpty] && movePathSegmentIsNull(plane.currentSegment)) {
                movePathSegment segment = movePathSegmentMake(plane.coordinate, [self randomCoordinateInRegion:self.region], [self randomDoubleBetweenMin:5 max:10]);
                [plane.movePath addSegment:segment];
            }
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (double)randomDoubleBetweenMin:(double)min max:(double)max {
    return ((double)arc4random() / ARC4RANDOM_MAX) * (max - min) + min;
}

- (CLLocationCoordinate2D)randomCoordinateInRegion:(MKCoordinateRegion)region {
    CLLocationDegrees minLat = region.center.latitude - region.span.latitudeDelta / 2.;
    CLLocationDegrees maxLat = region.center.latitude + region.span.latitudeDelta / 2.;
    CLLocationDegrees minLon = region.center.longitude - region.span.longitudeDelta / 2.;
    CLLocationDegrees maxLon = region.center.longitude + region.span.longitudeDelta / 2.;
    return CLLocationCoordinate2DMake([self randomDoubleBetweenMin:minLat max:maxLat],
                                      [self randomDoubleBetweenMin:minLon max:maxLon]);
}
@end
