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
    
    [self setCellDeselected];
    self.layer.cornerRadius = 10;
    self.contentView.backgroundColor = [UIColor whiteColor];
}

-(void)setCellSelected {
    self.layer.borderColor = [UIColor redColor].CGColor;
    self.layer.borderWidth = 3;
}

-(void)setCellDeselected {
     self.layer.borderColor = [UIColor lightGrayColor].CGColor;
     self.layer.borderWidth = 1;
}

@end
