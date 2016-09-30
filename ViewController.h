//
//  ViewController.h
//  PokeGoGo
//
//  Created by Owen Liang on 7/25/16.
//  Copyright © 2016 Owen Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property NSMutableData *responseData;

@property(strong, nonatomic) IBOutlet MKMapView *mapView;

@end




