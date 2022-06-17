//
//  DetailsViewController.m
//  Flixter
//
//  Created by Laura Jankowski on 6/15/22.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TrailerViewController.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *posterDetail;
@property (weak, nonatomic) IBOutlet UILabel *titleDetail;
@property (weak, nonatomic) IBOutlet UILabel *synopsisDetail;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleDetail.text = self.detailDict[@"title"];
    self.synopsisDetail.text = self.detailDict[@"overview"];
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.detailDict[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    self.posterDetail.image = nil;
    [self.posterDetail setImageWithURL:posterURL];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITapGestureRecognizer *tap = sender;
    TrailerViewController *trailerViewController = [segue destinationViewController];
    NSDictionary *dataToPass = self.detailDict;
    trailerViewController.trailerDict = dataToPass;
    
    
    
}

////In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    //Get the new view controller using [segue destinationViewController].
//    //Pass the selected object to the new view controller.
//   MovieCollectionCell *cell = sender;
//   NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
//   //do cell for row at index path to get the dictionary
//   NSDictionary *movie = self.movies[indexPath.row];
//   NSDictionary *dataToPass = self.movies[indexPath.row];
//   DetailsViewController *detailVC = [segue destinationViewController];
//   detailVC.detailDict = dataToPass;
//}


@end
