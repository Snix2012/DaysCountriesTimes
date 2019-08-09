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
       
    __weak IBOutlet UILabel *raceCourseNameLbl;
    __weak IBOutlet UIView *raceInfoContainerView;
    
    NSDictionary *today;
    NSDictionary *tomorrow;
    NSDictionary *thursday;
    NSDictionary *friday;
    
    NSDictionary *ukRaces;
    NSDictionary *usaRaces;
    
    NSDictionary *FairmountRaceCourse;
    NSArray *FairmountRaces;
    NSDictionary *EvangelineRaceCourse;
    NSArray *EvangelineRaces;
    
    NSDictionary *NewburyRaceCourse;
    NSArray *NewburyRaces;
    NSDictionary *CatterickRaceCourse;
    NSArray *CatterickRaces;
    
    NSMutableArray *daysDataSourceArray;
    NSMutableArray *countriesDataSourceArray;
    NSMutableArray *raceCoursesDataSourceArray;
    NSMutableArray *raceDataSourceArray;
    
    NSDictionary *raceCourses;
    NSDictionary *countries;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    raceCourseNameLbl.text = @"";
    raceInfoContainerView.layer.cornerRadius = 20;
    [self clearSelectedIndexPaths];
    
    countriesDataSourceArray = [[NSMutableArray alloc]init];
    raceCoursesDataSourceArray = [[NSMutableArray alloc]init];
    raceDataSourceArray = [[NSMutableArray alloc]init];

    [self parseJson];
}

-(void)clearSelectedIndexPaths {
    
    self.daysSelectedIndexPath = nil;
    self.countrySelectedIndexPath = nil;
    self.coursesSelectedIndexPath = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:3 inSection:0];
//    [self.daysCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
//    [self collectionView:self.daysCollectionView didSelectItemAtIndexPath:indexPath];
}


-(void)parseJson {
    
    NSDictionary *dict = [self getJSONFromFile];
   // NSLog(@"JSON: %@", dict);
    
    //days
    daysDataSourceArray = [NSMutableArray arrayWithArray:[dict[@"meeting"] allKeys]];
    //NSLog(@"daysDataSourceArray: %@", daysDataSourceArray);
    

    for (NSString *country in dict[@"meeting"][daysDataSourceArray[0]]){
        //Countries
        [countriesDataSourceArray addObject:country];
    }
    
    for(int i=0; i < countriesDataSourceArray.count; i++) {
        raceCourses = dict[@"meeting"][daysDataSourceArray[i]][countriesDataSourceArray[i]];
        NSLog(@"raceCourses: %@", raceCourses);
        
        countries = dict[@"meeting"][daysDataSourceArray[i]];
        
        NSDictionary *d = [countries objectForKey:countriesDataSourceArray[i]];
        NSDictionary *dd = [[d allValues] firstObject];;
        
        //raceCourses
        raceCoursesDataSourceArray = [NSMutableArray arrayWithArray:[raceCourses allKeys]];
        
        
        
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
        [dateformatter setLocale:[NSLocale currentLocale]];
        [dateformatter setDateFormat:@"dd-MM-yyyy"];
        
         for(int j=0; j < countriesDataSourceArray.count; j++) {
             
             NSString *courseName = [raceCoursesDataSourceArray objectAtIndex:j];
             NSDictionary *theCourse = [raceCourses objectForKey:courseName];
             
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
}

-(void)getRaceCoursePerCountry:(NSString *)countryName {
    
    //NSMutableArray *d = [[raceCourses allValues] mutableCopy];
    
    NSString *s = [raceCourses objectForKey:countryName];
    
//    if([[d valueForKey:countryName] isEqualToString:countryName]) {
//        NSArray *t = [NSMutableArray arrayWithArray:[raceCourses valueForKey:countryName]];
//        NSLog(@"courses in country = %@",t );
//    }
    [self.raceCoursesCollectionView reloadData];
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
        course =  [raceCoursesDataSourceArray objectAtIndex:self.coursesSelectedIndexPath.row];
    }
   
    raceCourseNameLbl.text = [NSString stringWithFormat:@" %@ - %@ - %@", day, country, course];
}


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


- (NSDictionary *)getJSONFromFile {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"racing_test" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

#pragma mark - CollectionView
- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CustomCollectionViewCell *cell;
    
    cell.selectedBackgroundView.backgroundColor = [UIColor redColor];
    
    if(collectionView == self.daysCollectionView)  {
        cell = (CustomCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"DaysCell" forIndexPath:indexPath];
        cell.dataLabel.text = [daysDataSourceArray objectAtIndex:indexPath.row];
    } else if(collectionView == self.countriesCollectionView) {
        cell = (CustomCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CountriesCell" forIndexPath:indexPath];
        cell.dataLabel.text = [countriesDataSourceArray objectAtIndex:indexPath.row];
    } else if(collectionView == self.raceCoursesCollectionView) {
        cell = (CustomCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"raceCourceCell" forIndexPath:indexPath];
        
        if(_countrySelectedIndexPath.row == 0){
           
        } else if(_countrySelectedIndexPath.row == 1){
            
        }
        
        cell.dataLabel.text = [raceCoursesDataSourceArray objectAtIndex:indexPath.row];
    } else if(collectionView == self.racesCollectionView) {
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
