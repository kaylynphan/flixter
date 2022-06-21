//
//  MovieViewController.m
//  Flixter
//
//  Created by Kaylyn Phan on 6/15/22.
//

#import "MovieViewController.h"
#import "MovieCell.h"
#import "DetailsViewController.h"
#import "Movie.h"

@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *movies;
@property (strong, nonatomic) NSMutableArray *filteredData;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 200;
    self.movies = [[NSMutableArray alloc] init];
    [self fetchMovies];
}


- (void) fetchMovies {
    self.filteredData = self.movies;
    
    UIAlertController *networkAlert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies" message:@"The internet connection appears to be offline." preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self fetchMovies];
    }];
    
    [networkAlert addAction:tryAgainAction];
    
    [self.activityIndicator startAnimating];

    // 1. Create URL
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=d1b12d7f1cc97f737543dc49de2d5f0d"];
    
    // 2. Create Request
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    // 3. Create Session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    // 4. Create our Session Task - this does the actual work of talking to the server and handling the response
    // pass in the request we created and the completion handler (the code we execute upon receiving a response)
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            
            [self presentViewController:networkAlert animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
            }];
            
            [self.activityIndicator stopAnimating];
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

            // TODO: Get the array of movies
            // TODO: Store the movies in a property to use elsewhere
            // TODO: Reload your table view data
            /*self.movies = dataDictionary[@"results"];
            self.filteredData = dataDictionary[@"results"];
            NSLog(@"%@", dataDictionary);
             */
            
            NSArray *dictionaries = dataDictionary[@"results"];
            for (NSDictionary *dictionary in dictionaries) {
                //NSLog(@"%@", dictionary); // this is good
                Movie *movie = [[Movie alloc] initWithDictionary:dictionary];
                [self.movies addObject:movie];
            }
            NSLog(@"%@", self.movies);
               
            // expected to get this information from itself
            
            [self.tableView reloadData];
            [self.activityIndicator stopAnimating];
        }
    }];
    
    // 5. Resume task -> after setting up configurations (steps 1-4), now execute the task
    [task resume];
    
    // Initialize a UIRefreshControl
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    
    Movie *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie.title;
    cell.synopsisLabel.text = movie.synopsis;
    //NSString *posterURLString = [@"https://image.tmdb.org/t/p/w500" stringByAppendingString:movie[@"poster_path"]];
    cell.posterImage.image = nil;
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: movie.posterUrl];
    cell.posterImage.image = [UIImage imageWithData: imageData];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Makes a network request to get updated data
// Updates the tableView with the new data
// Hides the RefreshControl
- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    
    // Create NSURL and NSURLRequest
    // 1. Create URL
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=d1b12d7f1cc97f737543dc49de2d5f0d"];
    
    // 2. Create Request
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    // Create Session instance
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    session.configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            self.movies = dataDictionary[@"results"];
            NSLog(@"%@", dataDictionary);
            
            // expected to get this information from itself
            self.tableView.dataSource = self;
            self.tableView.delegate = self;
            
            // Reload the tableView now that there is new data
            [self.tableView reloadData];
            
            // Tell the refreshControl to stop spinning
            [refreshControl endRefreshing];
        }
    }];
    [task resume];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController]
    UITableViewCell *cell = sender;
    NSIndexPath *myIndexPath = [self.tableView indexPathForCell:cell];
    // Get the new view controller using [segue destinationViewController].
    Movie *dataToPass = self.movies[myIndexPath.row];
    // Pass the selected object to the new view controller.
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.data = dataToPass;
}



@end
