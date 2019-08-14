//
//  CustomCollectionViewCell.m
//  DaysCountriesTimes
//
//  Created by Claire Roughan on 08/08/2019.
//  Copyright © 2019 Claire Roughan. All rights reserved.
//

#import "CustomCollectionViewCell.h"

@implementation CustomCollectionViewCell

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 10;
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)styleSelected:(BOOL)selected {

    self.layer.borderColor = selected ? [UIColor redColor].CGColor : [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = selected ? 3 : 1;
    
    self.selectedBackgroundView.backgroundColor = selected ? [UIColor yellowColor] : [UIColor clearColor];
}

@end
