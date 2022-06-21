//
//  MovieCell.m
//  Flixter
//
//  Created by Kaylyn Phan on 6/15/22.
//

#import "MovieCell.h"

@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setMovie:(Movie *)movie {
    _movie = movie;
    self.titleLabel.text = self.movie.title;
    self.synopsisLabel.text = self.movie.synopsis;
    //self.posterImage = nil;
    
    self.posterImage.image = nil;
    if (self.movie.posterUrl != nil) {
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: movie.posterUrl];
        self.posterImage.image = [UIImage imageWithData: imageData];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
