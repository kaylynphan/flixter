//
//  Movie.m
//  Flixter
//
//  Created by Kaylyn Phan on 6/21/22.
//

#import "Movie.h"

@implementation Movie

- (id)initWithDictionary:(NSDictionary *)dictionary {
 self = [super init];

 self.title = dictionary[@"title"];
 self.synopsis = dictionary[@"overview"];
 NSString *posterURLString = [@"https://image.tmdb.org/t/p/w500" stringByAppendingString:dictionary[@"poster_path"]];
 self.posterUrl = [NSURL URLWithString:posterURLString];
 return self;
}

+ (NSMutableArray *)moviesWithDictionaries:(NSArray *)dictionaries {
    NSMutableArray *movies = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in dictionaries) {
        //NSLog(@"%@", dictionary); // this is good
        Movie *movie = [[Movie alloc] initWithDictionary:dictionary];
        [movies addObject:movie];
    }
    return movies;
}

@end
