//
//  PlacesTableViewController.m
//  TopPlaces
//
//  Created by Andrei-Daniel Anton on 28/07/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "PlacesTableViewController.h"
#import "FlickrFetcher.h"
#import "MyFlickr.h"
#import "PhotoForPlaceTableViewController.h"

@interface PlacesTableViewController ()

@property (nonatomic, strong) NSDictionary *placesByCountrie;
@property (nonatomic, strong) NSArray *countries;
@end

@implementation PlacesTableViewController

#pragma mark - Proprieties

- (void)setPlaces:(NSArray *)places {
    _places = places;
    self.placesByCountrie = [MyFlickr placesByContries:_places];
    self.countries = [MyFlickr countrieOfPlaces:self.placesByCountrie];
    [self.tableView reloadData];
}

#pragma mark -Initialization

/*- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

- (void)awakeFromNib {
    NSLog(@"Awake from nib");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchPhotos];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)fetchPhotos {
    //[self.refreshControl beginRefreshing];
    NSURL *url = [FlickrFetcher URLforTopPlaces];
    dispatch_queue_t fetchQ = dispatch_queue_create("fetch flickr", NULL);
    dispatch_async(fetchQ, ^{
        NSData *jsonResult = [NSData dataWithContentsOfURL:url];
        NSDictionary *propertyList = [NSJSONSerialization JSONObjectWithData:jsonResult
                                                                     options:0
                                                                       error:NULL];

        NSArray *placesResult = [propertyList valueForKeyPath:FLICKR_RESULTS_PLACES];
        dispatch_async(dispatch_get_main_queue(), ^{
            //[self.refreshControl endRefreshing];
            self.places = placesResult;
        });
        
    });
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [self.countries count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.countries[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.placesByCountrie[self.countries[section]] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Places Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *place = self.placesByCountrie[self.countries[indexPath.section]][indexPath.row];
    NSString *name = [place valueForKey:FLICKR_PLACE_NAME];
    NSArray *elementOfName = [name componentsSeparatedByString:@", "];
    cell.textLabel.text = elementOfName[0];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",elementOfName[1]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

 //In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   if ([segue.identifier isEqualToString:@"Photo For Place"]) {
       if ([segue.destinationViewController isKindOfClass:[PhotoForPlaceTableViewController class]]) {
           PhotoForPlaceTableViewController *pvc = (PhotoForPlaceTableViewController *)segue.destinationViewController;
           NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
           pvc.place = self.placesByCountrie[self.countries[indexPath.section]][indexPath.row];
           pvc.title = [self.placesByCountrie[self.countries[indexPath.section]][indexPath.row] valueForKey:FLICKR_PLACE_NAME];
       }
    }
}

@end
