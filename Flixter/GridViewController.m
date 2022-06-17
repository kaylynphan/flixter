//
//  GridViewController.m
//  Flixter
//
//  Created by Kaylyn Phan on 6/17/22.
//

#import "GridViewController.h"
#import "MovieCollectionViewCell.h"
#import "DetailsViewController.h"

@interface GridViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray *movies;
@property (strong, nonatomic) NSArray *filteredData;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation GridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    [self fetchMovies];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    
    //do I need this?
    /*
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MovieCollectionViewCell"];
     */
     
    
    // Do any additional setup after loading the view.
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
            // TODO: Reload your collection view data
            self.movies = dataDictionary[@"results"];
            self.filteredData = dataDictionary[@"results"];
            NSLog(@"%@", dataDictionary);
               
            // expected to get this information from itself
            
            [self.collectionView reloadData];
            [self.activityIndicator stopAnimating];
        }
    }];
    
    // 5. Resume task -> after setting up configurations (steps 1-4), now execute the task
    [task resume];
    
    // Initialize a UIRefreshControl
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView insertSubview:refreshControl atIndex:0];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *movie = self.movies[indexPath.item];
    NSString *posterURLString = [@"https://image.tmdb.org/t/p/w500" stringByAppendingString:movie[@"poster_path"]];
    cell.posterImage.image = nil;
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: posterURLString]];
    cell.posterImage.image = [UIImage imageWithData: imageData];
     
    return cell;
}

- (void)viewDidLayoutSubviews {
   [super viewDidLayoutSubviews];

    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

// MARK: UICollectionViewDelegateFlowLayout methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    int totalwidth = self.collectionView.bounds.size.width;
    int numberOfCellsPerRow = 3;
    int cellWidth = (CGFloat)(totalwidth / numberOfCellsPerRow);
    return CGSizeMake(cellWidth, cellWidth * 1.55);
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
            self.collectionView.dataSource = self;
            self.collectionView.delegate = self;
            
            // Reload the tableView now that there is new data
            [self.collectionView reloadData];
            
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
    NSIndexPath *myIndexPath = [self.collectionView indexPathForCell:cell];
    // Get the new view controller using [segue destinationViewController].
    NSDictionary *dataToPass = self.filteredData[myIndexPath.item];
    // Pass the selected object to the new view controller.
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.data = dataToPass;
}

@end
