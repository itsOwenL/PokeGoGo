//
//  Pokemon.m
//  PokeGoGo
//
//  Created by Owen Liang on 7/26/16.
//  Copyright © 2016 Owen Liang. All rights reserved.
//

#import "Pokemon.h"

@implementation Pokemon

-(id) initPokemon :(NSString*)Name lat:(float)lat lng:(float)lng time:(int)time{
   self = [super init];
   _name = Name;
   _time = time;
   _lat = lat;
   _lng = lng;
   return self;
}

-(void) countDown{
   _time--;
}

-(int) getTimeInSec{
   return _time;
}

-(NSString*) getName{
   return _name;
}

-(NSString*) getTime
{
    _min = _time/60;
   _sec = _time%60;
   NSString *timeFormat = [NSString stringWithFormat:(@"%02d:%02d"), _min, _sec];
   return timeFormat;
}

-(float) getLat{
   return _lat;
}

-(float) getLng{
   return _lng;
}



@end