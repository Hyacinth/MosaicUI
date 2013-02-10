//
//  MosaivView.m
//  MosaicUI
//
//  Created by Ezequiel Becerra on 11/26/12.
//  Copyright (c) 2012 betzerra. All rights reserved.
//

#import "MosaicView.h"
#import "MosaicData.h"
#import "MosaicDataView.h"

#define kColumnsQuantity 4
#define kDoubleColumnProbabilityLandscape 40
#define kDoubleColumnProbabilityPortrait 10

@implementation MosaicView
@synthesize datasource, delegate;

#pragma mark - Private

- (float)columnWidth{
    float retVal = roundf(scrollView.frame.size.width / kColumnsQuantity);
    return retVal;
}

- (UIView *)shorterColumnModule{
    //  Returns the last added view from the shortest column
    UIView *retVal = nil;

    float lowerHeight = 0;
    
    for (UIView *columnModule in columns){
        if (!retVal){
            //  Take the first column as the shortest. Next iteration will compare with it
            lowerHeight = columnModule.frame.origin.y + columnModule.frame.size.height;
            retVal = columnModule;
        }else{
            float height = columnModule.frame.origin.y + columnModule.frame.size.height;
            if (height < lowerHeight){
                lowerHeight = height;
                retVal = columnModule;
            }
        }
    }
    
    return retVal;
}

-(CGSize)sizeForMosaicData:(MosaicData *)mosaicData{
    /*  Returns the size for the MosaicDataView, the width it's always the same since the number of 
     *  columns it's fixed. The height is variable. */
    
    CGSize retVal = CGSizeZero;
    
    UIImage *img = [UIImage imageNamed:mosaicData.imageFilename];
    retVal.width = [self columnWidth];
    retVal.height = roundf([self columnWidth] * img.size.height / img.size.width);

    return retVal;
}

- (void)setup{
    columns = [[NSMutableArray alloc] init];
    
    //  Add scrollview and set its position and size using autolayout constraints
    scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.backgroundColor = [UIColor blackColor];
    [self addSubview:scrollView];    
}

- (BOOL)canUseDoubleColumn:(UIView *)columnDataView usingModule:(MosaicData *)module{
    BOOL retVal = NO;
    
    NSUInteger index = [columns indexOfObject:columnDataView];
    
    //  If the column index is not the last one, then it's possible to get a double column space
    if (index < kColumnsQuantity -1){
        UIView *nextColumnDataView = [columns objectAtIndex:index+1];
        float heightColumn = columnDataView.frame.origin.y + columnDataView.frame.size.height;
        float heightNextColumn = nextColumnDataView.frame.origin.y + nextColumnDataView.frame.size.height;

        //  If the next 2 columns have the same height, then it's possible to get a double column space
        
        if (heightColumn == heightNextColumn){
            /*  Define by random chance. 
             *  Portrait photos have kDoubleColumnProbabilityPortrait percent of chances of getting a double column.
             *  Landscape photos have kDoubleColumnProbabilityLandscape percent of chances. */
            
            NSUInteger minChance = kDoubleColumnProbabilityPortrait;
            
            UIImage *anImage = [UIImage imageNamed:module.imageFilename];
            if (anImage.size.width > anImage.size.height){
                minChance = kDoubleColumnProbabilityLandscape;
            }
            
            NSUInteger random = arc4random() % 100;
            if (random < minChance){
                retVal = YES;
            }
        }
    }
    
    return retVal;
}

- (void)setupLayoutWithMosaicElements:(NSArray *)mosaicElements{
    
    scrollView.frame = [self bounds];
    
    for (UIView *subView in scrollView.subviews){
        [subView removeFromSuperview];
    }
    
    [columns removeAllObjects];
    
    float height = 0;
    
    for (MosaicData *aMosaicData in mosaicElements){

        MosaicDataView *aMosaicDataView = nil;
        CGSize mosaicSize = [self sizeForMosaicData:aMosaicData];
        
        if ([columns count] < kColumnsQuantity){
            //  First kColumnsQuantity items layout
            CGRect viewRect = CGRectMake([columns count] * [self columnWidth], 0, mosaicSize.width, mosaicSize.height);

            //  Set the view as the last column item
            aMosaicDataView = [[MosaicDataView alloc] initWithFrame:viewRect];
            aMosaicDataView.module = aMosaicData;
            [columns addObject:aMosaicDataView];
        }else{
            UIView *lastColumnDataView = [self shorterColumnModule];
            NSUInteger index = [columns indexOfObject:lastColumnDataView];
            
            if ([self canUseDoubleColumn:lastColumnDataView usingModule:aMosaicData]){
                //  Double column layout
                CGRect viewRect = CGRectMake(index * [self columnWidth],
                                             lastColumnDataView.frame.origin.y + lastColumnDataView.frame.size.height,
                                             mosaicSize.width * 2,
                                             roundf(mosaicSize.height * 1.5));

                //  Set the view as the 2 last columns item
                aMosaicDataView = [[MosaicDataView alloc] initWithFrame:viewRect];
                aMosaicDataView.module = aMosaicData;
                columns[index] = aMosaicDataView;
                columns[index+1] = aMosaicDataView;
            }else{
                //  Single column layout
                CGRect viewRect = CGRectMake(index * [self columnWidth],
                                             lastColumnDataView.frame.origin.y + lastColumnDataView.frame.size.height,
                                             mosaicSize.width,
                                             mosaicSize.height);

                //  Set the view as the last column item                
                aMosaicDataView = [[MosaicDataView alloc] initWithFrame:viewRect];
                aMosaicDataView.module = aMosaicData;
                columns[index] = aMosaicDataView;
            }
        }
        
        aMosaicDataView.mosaicView = self;
        [scrollView addSubview:aMosaicDataView];
        height = MAX(height, aMosaicDataView.frame.origin.y + aMosaicDataView.frame.size.height);
    }
    
    scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, height);
    
}

#pragma mark - Public

- (id)init{
    self = [super init];
    if (self){
        [self setup];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

- (void)refresh{
    NSArray *mosaicElements = [self.datasource mosaicElements];
    [self setupLayoutWithMosaicElements:mosaicElements];
}

- (void)layoutSubviews{
    [self refresh];
    [super layoutSubviews];
}

@end
