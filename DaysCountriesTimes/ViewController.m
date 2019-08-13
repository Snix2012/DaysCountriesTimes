//
//  ViewController.m
//  DaysCountriesTimes
//
//  Created by Claire Roughan on 06/08/2019.
//  Copyright © 2019 Claire Roughan. All rights reserved.
//

#import "ViewController.h"
#import "CustomCollectionViewCell.h"

@interface ViewController ()

@end

@implementation ViewController {
    
    NSMutableArray *allRaceItemArray;
    NSMutableArray *daysDataSourceArray;
    NSMutableArray *countriesDataSourceArray;
    NSMutableArray *raceCoursesDataSourceArray;
    NSMutableArray *raceDataSourceArray;
    
    NSDictionary *raceCourses;
    NSDictionary *countries;
    NSArray *coursesData;
    NSMutableArray *coursePerCountry;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.raceCourseNameLbl.text = @"";
    self.raceInfoContainerView.layer.cornerRadius = 20;
    [self clearSelectedIndexPaths];
    
    allRaceItemArray = [[NSMutableArray alloc]init];
    daysDataSourceArray = [[NSMutableArray alloc]init];
    countriesDataSourceArray = [[NSMutableArray alloc]init];
    raceCoursesDataSourceArray = [[NSMutableArray alloc]init];
    raceDataSourceArray = [[NSMutableArray alloc]init];
    coursePerCountry = [[NSMutableArray alloc]init];
    raceCourses = [[NSMutableDictionary alloc]init];
    
    [self parseJson];
}

-(void)clearSelectedIndexPaths {
    
    self.daysSelectedIndexPath = nil;
    self.countrySelectedIndexPath = nil;
    self.coursesSelectedIndexPath = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [self.daysCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    [self collectionView:self.daysCollectionView didSelectItemAtIndexPath:indexPath];
    
    [self.countriesCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    [self collectionView:self.countriesCollectionView didSelectItemAtIndexPath:indexPath];

}


-(void)parseJson {
    
    NSDictionary *dict = [self getJSONFromFile];
    NSLog(@"JSON: %@", dict);
    
    NSArray *data = [NSMutableArray arrayWithArray:dict[@"meeting"]];
    NSLog(@"data: %@", data);
    
    for(NSDictionary *d in data) {

        [allRaceItemArray addObject:d];
        [daysDataSourceArray addObject:d[@"date"]];
        [countriesDataSourceArray addObject:d[@"country"]];
        [raceCoursesDataSourceArray addObject:d[@"subCatName"]];
    }

    daysDataSourceArray = [daysDataSourceArray valueForKeyPath:@"@distinctUnionOfObjects.self"];
    countriesDataSourceArray = [countriesDataSourceArray valueForKeyPath:@"@distinctUnionOfObjects.self"];
    raceCoursesDataSourceArray = [raceCoursesDataSourceArray valueForKeyPath:@"@distinctUnionOfObjects.self"];
    
    
}

-(void)getRaceCoursePerCountry:(NSString *)countryName {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    
    for(int i = 0; i < allRaceItemArray.count; i++) {
        
        dict = [allRaceItemArray objectAtIndex:i];
        if([dict[@"country"] isEqualToString:countryName]) {
            [temp addObject:dict];
        }
        [raceCourses setValue:temp forKey:countryName];
    }
    
    NSArray *arr = [[raceCourses allValues] objectAtIndex:0];
    NSMutableDictionary *d  = [[NSMutableDictionary alloc]init];
    for(int i = 0; i < arr.count; i++) {
        d = [arr objectAtIndex:i];
        NSString *s = d[@"subCatName"];
        [coursePerCountry addObject:s];
    }
}

    
-(void)setRaceCourseNameLblText {
    
    NSString *day = @"";
    NSString *country = @"";
    NSString *course = @"";
    
    if(self.daysSelectedIndexPath != nil) {
         day =  [daysDataSourceArray objectAtIndex:self.daysSelectedIndexPath.row];
    }
    if(self.countrySelectedIndexPath != nil) {
        country =  [countriesDataSourceArray objectAtIndex:self.countrySelectedIndexPath.row];
    }
    if(self.coursesSelectedIndexPath != nil) {
        course =  [coursePerCountry objectAtIndex:self.coursesSelectedIndexPath.row];
    }
   
    self.raceCourseNameLbl.text = [NSString stringWithFormat:@" %@ - %@ - %@", day, country, course];
}


- (NSDictionary *)getJSONFromFile {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"racing_test" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

#pragma mark - CollectionView
- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CustomCollectionViewCell *cell;

    if(collectionView == self.daysCollectionView)  {
        cell = (CustomCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"DaysCell" forIndexPath:indexPath];
        cell.dataLabel.text = [daysDataSourceArray objectAtIndex:indexPath.row];
    } if(collectionView == self.countriesCollectionView) {
        cell = (CustomCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CountriesCell" forIndexPath:indexPath];
        cell.dataLabel.text = [countriesDataSourceArray objectAtIndex:indexPath.row];
    } if(collectionView == self.raceCoursesCollectionView) {
        cell = (CustomCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"raceCourceCell" forIndexPath:indexPath];
        NSString *country = [coursePerCountry objectAtIndex:indexPath.row];
        cell.dataLabel.text = country;
    } if(collectionView == self.racesCollectionView) {
        cell = (CustomCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"raceTimeCell" forIndexPath:indexPath];
        cell.dataLabel.text = [raceDataSourceArray objectAtIndex:indexPath.row];
    }
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger sections = 0;
    
    if(collectionView == self.daysCollectionView) {
        sections = daysDataSourceArray.count;
    } else if(collectionView == self.countriesCollectionView) {
        sections = countriesDataSourceArray.count;
    } else if(collectionView == self.raceCoursesCollectionView) {
        sections = raceCoursesDataSourceArray.count;
    } else if(collectionView == self.racesCollectionView) {
        sections = raceDataSourceArray.count;
    }
    return sections;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"INDEXPATH:-%ld",(long)indexPath.row);
    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [cell setCellSelected];

    if(collectionView == self.daysCollectionView) {
         self.daysSelectedIndexPath = indexPath;
    } else if(collectionView == self.countriesCollectionView) {
         self.countrySelectedIndexPath = indexPath;
         [self getRaceCoursePerCountry:[countriesDataSourceArray objectAtIndex:self.countrySelectedIndexPath.row]];
         [self.countriesCollectionView reloadData];
    } else if(collectionView == self.raceCoursesCollectionView) {
         self.coursesSelectedIndexPath = indexPath;
    }
    
    [self setRaceCourseNameLblText];

}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setCellDeselected];
    
    [self clearSelectedIndexPaths];
}

- (CGFloat)collectionView:(UICollectionView *) collectionView
                   layout:(UICollectionViewLayout *) collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger) section {
    return 5.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:   (UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(100, 50);
}

@end


/*
 NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
 [dateformatter setLocale:[NSLocale currentLocale]];
 [dateformatter setDateFormat:@"dd-MM-yyyy"];
 
 for(int j=0; j < countriesDataSourceArray.count; j++) {
 
 NSString *courseName = [raceCoursesDataSourceArray objectAtIndex:j];
 NSDictionary *theCourse = [raceCourses objectForKey:courseName];
 
 [coursePerCountry setObject:countryName forKey:@"country"];
 [coursePerCountry setValue:[dd valueForKey:@"subCatName"] forKey:@"subCatName"];
 
 double time = [[theCourse[@"race"][j] objectForKey:@"scheduledStart"]doubleValue]/1000;
 NSTimeInterval timestamp = (NSTimeInterval)time;
 NSDate *racedatetime = [NSDate dateWithTimeIntervalSince1970:timestamp];
 NSString *dateString = [dateformatter stringFromDate:racedatetime];
 
 NSDate *now = [NSDate date];
 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
 [dateFormatter setDateFormat:@"EEEE"];
 NSLog(@"%@",[dateFormatter stringFromDate:now]);
 
 }
 
 }
 NSLog(@"daysDataSourceArray: %@", daysDataSourceArray);
 NSLog(@"countriesDataSourceArray: %@", countriesDataSourceArray);
 NSLog(@"raceCoursesDataSourceArray: %@",  raceCoursesDataSourceArray);
 NSLog(@"races: %@", raceDataSourceArray);
 
 
 -(void)getRacesForDict:(NSDictionary *)dayDict {
 
 NSLog(@"All keys = %@", [dayDict allKeys]);
 
 for (NSString *place in dayDict) {
 NSLog(@"place: %@", place);
 
 if([place isEqualToString:@"UK"]) {
 ukRaces = [today objectForKey:@"UK"];
 
 NSArray*keys=[ukRaces allKeys];
 NSLog(@"All keys = %@", keys);
 
 for (NSString *ukRaceCourse in ukRaces) {
 if([ukRaceCourse isEqualToString:@"Newbury"]){
 NewburyRaceCourse = [ukRaces objectForKey:ukRaceCourse];
 NewburyRaces = [NewburyRaceCourse objectForKey:@"race"];
 }else if([ukRaceCourse isEqualToString:@"Catterick"]){
 CatterickRaceCourse = [ukRaces objectForKey:ukRaceCourse];
 CatterickRaces = [CatterickRaceCourse objectForKey:@"race"];
 }
 }
 } else if ([place isEqualToString:@"USA"]) {
 usaRaces = [today objectForKey:@"USA"];
 for (NSString *usaRaceCourse in usaRaces) {
 if([usaRaceCourse isEqualToString:@"Fairmount Park"]){
 FairmountRaceCourse = [usaRaces objectForKey:usaRaceCourse];
 FairmountRaces = [FairmountRaceCourse objectForKey:@"race"];
 }else if([usaRaceCourse isEqualToString:@"Evangeline Downs"]){
 EvangelineRaceCourse = [usaRaces objectForKey:usaRaceCourse];
 EvangelineRaces = [EvangelineRaceCourse objectForKey:@"race"];
 }
 }
 }
 }
 NSLog(@"FairmountRaces: %@ - %@", FairmountRaceCourse, FairmountRaces);
 NSLog(@"EvangelineRaces: %@ - %@", EvangelineRaceCourse, EvangelineRaces);
 NSLog(@"NewburyRaces: %@ - %@",  NewburyRaceCourse, NewburyRaces);
 NSLog(@"CatterickRaces:%@ - %@", CatterickRaceCourse, CatterickRaces);
 }
 */
