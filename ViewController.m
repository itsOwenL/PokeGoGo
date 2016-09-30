//
//  ViewController.m
//  PokeGoGo
//
//  Created by Owen Liang on 7/25/16.
//  Copyright © 2016 Owen Liang. All rights reserved.
//

#import "ViewController.h"
#import "CustomAnnotation.h"
#import "Pokemon.h"

@implementation ViewController

CLLocationManager *locationManager;

static NSString *urlStart = @"https://pokegogo.herokuapp.com/load?lat=";
static NSString *urlMid = @"&level=16&lng=";
static NSString *urlEnd = @"&radius=500";
NSMutableArray *localPokemon;
int globalTime;

@synthesize mapView = _mapView;

- (void)viewDidLoad {
   [super viewDidLoad];
   globalTime = 0;
   [NSTimer scheduledTimerWithTimeInterval:1.0
                                    target:self
                                  selector:@selector(timeUpdate)
                                  userInfo:nil
                                   repeats:YES];
   
   localPokemon = [NSMutableArray array];
   self.mapView.delegate = self;
   
   [self start];
   
   UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
   [refreshButton addTarget:self
              action:@selector(start)
    forControlEvents:UIControlEventTouchUpInside];
   [refreshButton setTitle:@"Refresh" forState:UIControlStateNormal];
   refreshButton.frame = CGRectMake(0, 0, 160.0, 40.0);
   refreshButton.backgroundColor = [UIColor whiteColor];
   refreshButton.layer.cornerRadius = 10;
   [refreshButton setTitleColor:[UIColor grayColor] forState:normal];
   [[refreshButton layer] setBorderWidth:1.0f];
   [[refreshButton layer] setBorderColor:[UIColor grayColor].CGColor];
   [self.view addSubview:refreshButton];
}

- (void) start
{
   NSString *url = @"";
   [localPokemon removeAllObjects];
   
   for (CustomAnnotation *annotation in _mapView.annotations)
      [_mapView removeAnnotation:annotation];
   

   [locationManager requestWhenInUseAuthorization];
   locationManager = [[CLLocationManager alloc] init];
   locationManager.delegate = self;
   locationManager.desiredAccuracy = kCLLocationAccuracyBest;
   [locationManager startUpdatingLocation];
   float latitude = locationManager.location.coordinate.latitude;
   float longitude = locationManager.location.coordinate.longitude;
   
   url = [self createUrlWith:latitude and:longitude];
   NSLog(@"%@",url);
   
   
   
   self.responseData = [NSMutableData data];
   NSURLRequest *request = [NSURLRequest requestWithURL:
                            [NSURL URLWithString: url]];
   //[[NSURLConnection alloc] initWithRequest:request delegate:self];
   
   
}

- (void) timeUpdate
{
   globalTime++;
   int count = 0;
   if([localPokemon count] != 0)
   {
      for(CustomAnnotation *annotaiton in _mapView.annotations)
      {
         if([annotaiton isKindOfClass:[CustomAnnotation class]])
         {
            [localPokemon[count] countDown];
            if([localPokemon[count] getTimeInSec] == 0)
            {
               [localPokemon removeObjectAtIndex:count];
               count--;
            }
            if ([annotaiton getTime] == 0)
            {
               [_mapView removeAnnotation:annotaiton];
            }
            else
            {
               [annotaiton updateTime];
               count++;
            }
         }
      }
   }
   if (globalTime%300 == 0)
   {
      [self start];
   }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(CustomAnnotation*)annotation{
   // If it's the user location, just return nil.
   if ([annotation isKindOfClass:[MKUserLocation class]])
      return nil;
   
   // Handle any custom annotations.
   if ([annotation isKindOfClass:[CustomAnnotation class]])
   {
      // Try to dequeue an existing pin view first.
      MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
      //if (!pinView)
      {
         // If an existing pin view was not available, create one.
         pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
         pinView.canShowCallout = YES;
         NSString *pokemonName = [NSString stringWithFormat:@"%@.png", [annotation getTitle]];
         pinView.image = [UIImage imageNamed:pokemonName];
      }
//      else
//      {
//         pinView.annotation = annotation;
//      }
      return pinView;
   }
   return nil;
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
   MKCoordinateRegion mapRegion;
   mapRegion.center = mapView.userLocation.coordinate;
   mapRegion.span.latitudeDelta = 0.02;
   mapRegion.span.longitudeDelta = 0.02;
   
   [mapView setRegion:mapRegion animated: NO];
}

- (NSString*)createUrlWith :(float)lat and:(float)lon{
   NSString *url = @"";

   url = [NSMutableString stringWithFormat:@"%@%f%@%f%@", urlStart, lat, urlMid, lon, urlEnd];
   return url;
}

- (void)didReceiveMemoryWarning {
   [super didReceiveMemoryWarning];
   // Dispose of any resources that can be recreated.
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
   NSLog(@"didReceiveResponse");
   [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
   [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
   NSLog(@"didFailWithError");
   NSLog(@"Connection failed: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
   NSLog(@"connectionDidFinishLoading");
   NSLog(@"Succeeded! Received %lu bytes of data",(unsigned long)[self.responseData length]);
   
   // convert to JSON
   NSError *myError = nil;
   NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
   
//    show all values
   for(id key in res) {
      
      id value = [res objectForKey:key];
      
      NSString *keyAsString = (NSString *)key;
      NSString *valueAsString = (NSString *)value;
      
      NSLog(@"key: %@", keyAsString);
      NSLog(@"value: %@", valueAsString);
   }
   
   // extract specific value...
   NSArray *results = [res objectForKey:@"pokemons"];
   
   for (NSDictionary *result in results) {
      NSString *name = [result objectForKey:@"name"];
      float lat = [[result objectForKey:@"lat"] floatValue];
      float lng = [[result objectForKey:@"lng"] floatValue];
      int time = [[result objectForKey:@"timeleft"] intValue];
      Pokemon *newPokemon = [[Pokemon alloc] initPokemon:name lat:lat lng:lng time:time];
      [localPokemon addObject:newPokemon];
   }
   [self pokemonPin];
}

- (void) pokemonPin
{
   for(id object in localPokemon)
   {
      CustomAnnotation *annotation = [[CustomAnnotation alloc] init];
      CLLocationCoordinate2D coordinates;
      coordinates.latitude = [object getLat];
      coordinates.longitude = [object getLng];
      [annotation setCoordinate:coordinates];
      //[annotation setSubtitle:[NSString stringWithFormat:@"Despawns in: %d", [object getTime]]];
      [annotation setTitle:[object getName]];
      [annotation setTime: [object getTimeInSec]];
      [self.mapView addAnnotation:annotation];
   }
}

@end
