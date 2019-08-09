//
//  CustomCollectionViewCell.h
//  DaysCountriesTimes
//
//  Created by Claire Roughan on 08/08/2019.
//  Copyright © 2019 Claire Roughan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *dataLabel;

-(void)setCellSelected;
-(void)setCellDeselected;

@end


