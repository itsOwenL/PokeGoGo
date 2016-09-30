//
//  CustomAnnotation.h
//  PokeGoGo
//
//  Created by Owen Liang on 7/27/16.
//  Copyright © 2016 Owen Liang. All rights reserved.
//

#import <MapKit/MapKit.h>


@interface CustomAnnotation : MKPointAnnotation

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subtitle;
@property(nonatomic) int time;

- (void) updateTime;
- (void) setTime: (int)time;
- (int) getTime;
- (NSString*) getTitle;
@end

