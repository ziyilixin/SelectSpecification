//
//  Specification.h
//  SelectSpecification
//
//  Created by Mac on 2021/3/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Specification : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *value;
@end

NS_ASSUME_NONNULL_END
