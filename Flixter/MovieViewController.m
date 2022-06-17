//
//  MovieViewController.m
//  Flixter
//
//  Created by Laura Jankowski on 6/15/22.
//
//  ViewController.h
#import <UIKit/UIKit.h>

#import "MovieViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@property (strong, nonatomic) NSArray *filteredMovies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UISearchBar *movieSearchBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Start the activity indicator
    [self.activityIndicator startAnimating];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.movieSearchBar.delegate = self;
    // Do any additional setup after loading the view.
    [self fetchMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
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
               [self.activityIndicator stopAnimating];
               // TODO: Get the array of movies
               self.movies = dataDictionary[@"results"];
               for (NSDictionary *movie in self.movies) {
                   NSLog(@"%@", movie[@"title"]);
               }
               self.filteredMovies = self.movies;
               [self.tableView reloadData];
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
               
           }
        [self.refreshControl endRefreshing];
       }];
    //5.
    [task resume];
}

- (void)didRecieveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredMovies.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    NSDictionary *movie = self.filteredMovies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    cell.posterView.image = nil;
    [cell.posterView setImageWithURL:posterURL];
    //cell.textLabel.text = movie[@"title"];
    
    return cell;
}


#pragma mark - Navigation

 //In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     //Get the new view controller using [segue destinationViewController].
     //Pass the selected object to the new view controller.
    MovieCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    //do cell for row at index path to get the dictionary
    NSDictionary *movie = self.filteredMovies[indexPath.row];
    NSDictionary *dataToPass = self.filteredMovies[indexPath.row];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.detailDict = dataToPass;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject[@"title"] containsString:searchText];
        }];
        self.filteredMovies = [self.movies filteredArrayUsingPredicate:predicate];
        
        NSLog(@"%@", self.filteredMovies);
        
    }
    else {
        self.filteredMovies = self.movies;
    }
    
    [self.tableView reloadData];
 
}

@end
