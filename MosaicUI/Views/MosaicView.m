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

#define kMaxScrollPages_iPhone 4
#define kMaxScrollPages_iPad 4

@implementation MosaicView
@synthesize datasource, delegate;

#pragma mark - Private

- (void)setup{
    //  Add scrollview and set its position and size using autolayout constraints
    scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.backgroundColor = [UIColor blackColor];
    [self addSubview:scrollView];
    
    isFirstLayoutTime = YES;
}

- (NSInteger)maxScrollPages{
    NSInteger retVal = kMaxScrollPages_iPhone;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        retVal = kMaxScrollPages_iPad;
    }
    return retVal;
}

- (void)setupLayoutWithMosaicElements:(NSArray *)mosaicElements{
    
    NSInteger scrollHeight = 0;
    
    scrollView.frame = [self bounds];
    
    for (UIView *subView in scrollView.subviews){
        [subView removeFromSuperview];
    }
    
    CGSize packerSize = CGSizeMake(self.frame.size.width, self.frame.size.height * [self maxScrollPages]);
    EBPacker *packer = [[EBPacker alloc] initWithSize:packerSize];
    [packer fit:mosaicElements];
    
    MosaicDataView *lastModuleView = nil;
    
    for (MosaicData *aModule in mosaicElements){
        if (aModule.fit){
            
            float width = aModule.size.width;
            
            if (!aModule.fit.right.isUsed){
                width += aModule.fit.right.frame.size.width;
            }
            
            CGRect mosaicModuleRect = CGRectMake(aModule.fit.frame.origin.x,
                                                 aModule.fit.frame.origin.y,
                                                 width,
                                                 aModule.size.height);
            
            lastModuleView = [[MosaicDataView alloc] initWithFrame:mosaicModuleRect];
            lastModuleView.module = aModule;
            lastModuleView.mosaicView = self;
            
            [scrollView addSubview:lastModuleView];
            
            scrollHeight = MAX(scrollHeight, lastModuleView.frame.origin.y + lastModuleView.frame.size.height);
//            NSLog(@"#DEBUG Module %@ %@ (size %.0f %.0f) --- right: %@ down: %@", aModule.title, aModule.fit, aModule.size.width, aModule.size.height, aModule.fit.right, aModule.fit.down);
        }
    }
    
    //  Setup content size
    CGSize contentSize = CGSizeMake(scrollView.frame.size.width,scrollHeight);
    scrollView.contentSize = contentSize;
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
