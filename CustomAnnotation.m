//
//  CustomAnnotation.m
//  PokeGoGo
//
//  Created by Owen Liang on 7/27/16.
//  Copyright © 2016 Owen Liang. All rights reserved.
//

#import "CustomAnnotation.h"


@implementation CustomAnnotation

@synthesize title, subtitle;

- (void)updateTime{
   _time--;
   int min = _time/60;
   int sec = _time%60;
   NSString *timeFormat = [NSString stringWithFormat:(@"%02d:%02d"), min, sec];
   self.subtitle = [NSString stringWithFormat:@"Despawns in: %@ ",timeFormat];
}

- (void) setTime:(int)time {
   _time = time;
}

- (NSString* ) getTitle{
   return title;
}

- (int) getTime{
   return _time;
}




@end