//
//  ViewController.h
//  DaysCountriesTimes
//
//  Created by Claire Roughan on 06/08/2019.
//  Copyright © 2019 Claire Roughan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *daysCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *countriesCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *raceCoursesCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *racesCollectionView;

@property (nonatomic, retain) NSIndexPath *daysSelectedIndexPath;
@property (nonatomic, retain) NSIndexPath *countrySelectedIndexPath;
@property (nonatomic, retain) NSIndexPath *coursesSelectedIndexPath;
@property (nonatomic, retain) NSIndexPath *racesSelectedIndexPath;


@end

