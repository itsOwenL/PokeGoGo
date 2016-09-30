//
//  Pokemon.h
//  PokeGoGo
//
//  Created by Owen Liang on 7/26/16.
//  Copyright © 2016 Owen Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pokemon : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) float lat;
@property (nonatomic) float lng;
@property (nonatomic) int time;
@property (nonatomic) int sec;
@property (nonatomic) int min;

-(id) initPokemon:(NSString*)Name lat:(float)lat lng:(float)lng time:(int)time;
-(NSString*) getName;
-(NSString*) getTime;

-(void) countDown;

-(int) getTimeInSec;

-(float) getLat;
-(float) getLng;
@end
