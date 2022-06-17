//
//  TrailerViewController.m
//  Flixter
//
//  Created by Laura Jankowski on 6/17/22.
//

#import "TrailerViewController.h"
#import "YTPlayerView.h"

@interface TrailerViewController ()

@property (weak, nonatomic) IBOutlet YTPlayerView *playerView;
@property (nonatomic, strong) NSArray *trailers;
@property (weak, nonatomic) NSString *movieID;
@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.movieID = @"U6quJDpAOIY";
    [self fetchTrailer];
   
}

-(void)fetchTrailer {
    //1. create URL
    NSString *startBaseURLString = @"https://api.themoviedb.org/3/movie/";
    NSString *endBaseURLString = @"/videos?api_key=1c3b31f35c17c0776605c9bf660a633d&language=en-US";
    NSString *movieDictID = self.trailerDict[@"id"];
    NSString *fullPosterURLString = [NSString stringWithFormat:@"%@/%@/%@", startBaseURLString, movieDictID, endBaseURLString];
    NSLog(@"%@", fullPosterURLString);
    
    NSURL *url = [NSURL URLWithString:fullPosterURLString];
    
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
               self.trailers = dataDictionary[@"results"];
               for (NSDictionary *trailer in self.trailers) {
                   if([trailer[@"name"]  isEqual: @"Official Trailer"] && [trailer[@"site"]  isEqual: @"YouTube"]){
                       self.movieID = trailer[@"key"];
                   }
               }
               NSLog(@"name of movie");
               NSLog(@"%@", self.movieID);
               NSLog(@"key at almost end of fetch movies");
               NSLog(@"%@", self.movieID);
               [self.playerView loadWithVideoId: self.movieID];

               
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
               
           }
       }];
    NSLog(@"here is the key below");
    NSLog(@"%@", self.movieID);
    
    [task resume];
    
    
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
