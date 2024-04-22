//
//  MarkerList.m
//  PlaceReminder
//
//  Created by Rocco Gualtieri on 28/09/23.
//

#import "MarkerList.h"

@interface MarkerList()

@property (strong, nonatomic) NSMutableArray *list;

@end

@implementation MarkerList

-(instancetype)init {
    if(self = [super init])
        _list = [[NSMutableArray alloc] init];
    return self;
}

// Inserimento del marker in testa alla lista
-(void)addMarker:(Marker *)marker {
    if([self contains:marker])
            return;
    [self.list insertObject:marker atIndex:0];
}

//Rimozione marker
-(void)removeMarker:(Marker *)marker {
    [self.list removeObject:marker];
}

//Ottiene tutti gli elementi della lista
-(NSArray *)getAll {
    return self.list;
}

//Dimensione lista
-(long)size {
    return self.list.count;
}

//Ottiene un marker dall'indice
-(Marker *)getAtIndex:(NSInteger)index {
    return (Marker *) [self.list objectAtIndex:index];
}

//Cerca un marker nella lista
-(BOOL)contains:(Marker *)marker {
    for(Marker *m in self.list)
        if([m.name isEqual:marker.name])
            return YES;
    return NO;
}

@end
