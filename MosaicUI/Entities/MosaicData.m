//
//  MosaicModule.m
//  MosaicUI
//
//  Created by Ezequiel Becerra on 10/21/12.
//  Copyright (c) 2012 betzerra. All rights reserved.
//

#import "MosaicData.h"
#define kModuleSizeInPoints_iPhone 80
#define kModuleSizeInPoints_iPad 128

@implementation MosaicData
@synthesize imageFilename, title, moduleSize, fit, size;

#pragma mark - Private

- (CGSize)sizeForModuleSize:(NSUInteger)aSize{
    CGSize retVal = CGSizeZero;
    
    switch (aSize) {
            
        case 0:
            retVal = CGSizeMake(4, 4);
            break;
        case 1:
            retVal = CGSizeMake(2, 2);
            break;
        case 2:
            retVal = CGSizeMake(2, 1);
            break;
        case 3:
            retVal = CGSizeMake(1, 1);
            break;
            
        default:
            break;
    }
    
    return retVal;
}

- (NSInteger)moduleSizeInPoints{
    NSInteger retVal = kModuleSizeInPoints_iPhone;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        retVal = kModuleSizeInPoints_iPad;
    }
    
    return retVal;
}

#pragma mark - Public

-(id)initWithDictionary:(NSDictionary *)aDict{
    self = [self init];
    if (self){
        self.imageFilename = [aDict objectForKey:@"imageFilename"];
        self.moduleSize = [[aDict objectForKey:@"size"] integerValue];
        self.title = [aDict objectForKey:@"title"];
    }
    return self;
}

-(NSString *)description{
    NSString *retVal = [NSString stringWithFormat:@"%@ %@", [super description], self.title];
    return retVal;
}

-(void)setModuleSize:(NSInteger)aModuleSize{
    moduleSize = aModuleSize;
    NSInteger scalar = [self moduleSizeInPoints];
    CGSize sizeInModules = [self sizeForModuleSize:aModuleSize];
    self.size = CGSizeMake(sizeInModules.width * scalar, sizeInModules.height * scalar);
}

-(NSInteger)moduleSize{
    return moduleSize;
}

@end
