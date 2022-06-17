//
//  gridViewController.m
//  Flixter
//
//  Created by Laura Jankowski on 6/16/22.
//

#import "gridViewController.h"
#import "MovieCollectionCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface gridViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *movies;

@end

@implementation gridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self fetchMovies];
}


- (void)fetchMovies {
    //1. create URL
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=1c3b31f35c17c0776605c9bf660a633d"];
    
    //2. Create Request
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    //3. Create session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    //4. Create session task
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            // Stop the activity indicator
            // Hides automatically if "Hides When Stopped" is enabled
        
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network Error"
                                                                                        message:@"Please establish a better network connection"
                                                                                 preferredStyle:UIAlertControllerStyleAlert];
               //We add buttons to the alert controller by creating UIAlertActions:
               UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:nil]; //You can use a block here to handle a press on this button
               [alertController addAction:actionOk];
               [self presentViewController:alertController animated:YES completion:nil];
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               NSLog(@"%@", dataDictionary);// log an object with the %@ formatter.
               // TODO: Get the array of movies
               self.movies = dataDictionary[@"results"];
               for (NSDictionary *movie in self.movies) {
                   NSLog(@"%@", movie[@"title"]);
               }
               [self.collectionView reloadData];
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
               
           }
       }];
    //5.
    [task resume];
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.movies.count;
}

- (UICollectionViewCell *)collectionView: (UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieCollectionCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    NSDictionary *movie = self.movies[indexPath.row];
    NSString *baseURLStringLarge = @"https://image.tmdb.org/t/p/original";
    NSString *baseURLStringSmall = @"https://image.tmdb.org/t/p/w45";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLStringLarge = [baseURLStringLarge stringByAppendingString:posterURLString];
    NSString *fullPosterURLStringSmall = [baseURLStringSmall stringByAppendingString:posterURLString];
    NSURL *requestLarge = [NSURL URLWithString:fullPosterURLStringLarge];
    NSURL *requestSmall = [NSURL URLWithString:fullPosterURLStringSmall];
    NSURLRequest  *largeRequest = [NSURLRequest requestWithURL:requestLarge];
    NSURLRequest  *smallRequest = [NSURLRequest requestWithURL:requestSmall];
    __weak MovieCollectionCell *weakSelf = cell;

    [cell.posterCollectionView setImageWithURLRequest:smallRequest
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *smallImage) {
                                       
                                       // smallImageResponse will be nil if the smallImage is already available
                                       // in cache (might want to do something smarter in that case).
                                       weakSelf.posterCollectionView.alpha = 0.0;
                                       weakSelf.posterCollectionView.image = smallImage;
                                       
                                       [UIView animateWithDuration:0.3
                                                        animations:^{
                                                            
                                                            weakSelf.posterCollectionView.alpha = 1.0;
                                                            
                                                        } completion:^(BOOL finished) {
                                                            // The AFNetworking ImageView Category only allows one request to be sent at a time
                                                            // per ImageView. This code must be in the completion block.
                                                            [weakSelf.posterCollectionView setImageWithURLRequest:largeRequest
                                                                                  placeholderImage:smallImage
                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage * largeImage) {
                                                                                                weakSelf.posterCollectionView.image = largeImage;
                                                                                  }
                                                                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                               // do something for the failure condition of the large image request
                                                                                               // possibly setting the ImageView's image to a default image
                                                                                           }];
                                                        }];
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       // do something for the failure condition
                                       // possibly try to get the large image
                                   }];
    return cell;
}

//In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //Get the new view controller using [segue destinationViewController].
    //Pass the selected object to the new view controller.
   MovieCollectionCell *cell = sender;
   NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
   //do cell for row at index path to get the dictionary
   NSDictionary *movie = self.movies[indexPath.row];
   NSDictionary *dataToPass = self.movies[indexPath.row];
   DetailsViewController *detailVC = [segue destinationViewController];
   detailVC.detailDict = dataToPass;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
