//
//  DetailsViewController.m
//  Flixter
//
//  Created by Kaylyn Phan on 6/16/22.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = self.data[@"title"];
    self.synopsisLabel.text = self.data[@"overview"];
    NSString *posterURLString = [@"https://image.tmdb.org/t/p/w500" stringByAppendingString:self.data[@"poster_path"]];
    self.posterImage.image = nil;
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: posterURLString]];
    self.posterImage.image = [UIImage imageWithData: imageData];
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
