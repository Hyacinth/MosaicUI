//
//  EBPackerNode.m
//  ExampleMosaicUI
//
//  Created by Ezequiel Becerra on 2/5/13.
//  Copyright (c) 2013 betzerra. All rights reserved.
//

#import "EBPackerNode.h"

@implementation EBPackerNode
@synthesize frame, right, down, isUsed;

-(id)initWithRect:(CGRect)aRect{
    self = [self init];
    if (self){
        //  avoid float values
        frame = CGRectIntegral(aRect);
    }
    return self;
}

-(NSString *)description{
    NSString *retVal = [NSString stringWithFormat:@"%.0f : %.0f - %.0f : %.0f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height];
    return retVal;
}

@end
