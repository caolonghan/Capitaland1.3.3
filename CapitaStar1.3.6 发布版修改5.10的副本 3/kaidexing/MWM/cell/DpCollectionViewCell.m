//
//  DpCollectionViewCell.m
//  kaidexing
//
//  Created by dwolf on 16/5/21.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "DpCollectionViewCell.h"

@implementation DpCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"DpCollectionViewCell" owner:self options: nil];
        if(arrayOfViews.count < 1){return nil;}
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];

    }
    
    return self;
}


@end
