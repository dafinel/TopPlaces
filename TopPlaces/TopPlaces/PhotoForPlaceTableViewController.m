//
//  PhotoForPlaceTableViewController.m
//  TopPlaces
//
//  Created by Andrei-Daniel Anton on 28/07/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "PhotoForPlaceTableViewController.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"

@interface PhotoForPlaceTableViewController ()

@end

@implementation PhotoForPlaceTableViewController

#pragma mark - Initialization

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchPhoto];
}

static int const maxresults = 50;

- (void)fetchPhoto {
   // [self.refreshControl beginRefreshing];
    NSURL *url = [FlickrFetcher URLforPhotosInPlace:[self.place valueForKey:FLICKR_PLACE_ID] maxResults:maxresults];
    dispatch_queue_t photoForPlaceQ = dispatch_queue_create("PhotoForPlace", NULL);
    dispatch_async(photoForPlaceQ, ^{
        NSData *jsonResult = [NSData dataWithContentsOfURL:url];
        NSDictionary *propertyList = [NSJSONSerialization JSONObjectWithData:jsonResult
                                                                     options:0
                                                                       error:NULL];
        NSArray *photos = [propertyList valueForKeyPath:FLICKR_RESULTS_PHOTOS];
        dispatch_async(dispatch_get_main_queue(), ^{
            //[self.refreshControl endRefreshing];
            self.photos = photos;
        });
    });
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
     NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if ([segue.identifier isEqualToString:@"ShowImage"]) {
        if ([segue.destinationViewController isKindOfClass:[ImageViewController class]]) {
            ImageViewController *ivc = (ImageViewController *)segue.destinationViewController;
            ivc.imageURL = [FlickrFetcher URLforPhoto:self.photos[indexPath.row] format:FlickrPhotoFormatLarge];
            ivc.title =  [self.photos[indexPath.row] valueForKeyPath:FLICKR_PHOTO_TITLE];
        }
    }
}


@end
