//
//  MovieAPIManager.h
//  Flixter
//
//  Created by Kaylyn Phan on 6/21/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieAPIManager : NSObject

@property (nonatomic, strong) NSURLSession *session;

- (id)init;
- (void)fetchNowPlaying:(void(^)(NSArray *movies, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
