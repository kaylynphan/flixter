//
//  MovieCell.h
//  Flixter
//
//  Created by Kaylyn Phan on 6/15/22.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface MovieCell : UITableViewCell

@property (strong, nonatomic) Movie *movie;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImage;

- (void)setMovie:(Movie *)movie;

@end

NS_ASSUME_NONNULL_END
