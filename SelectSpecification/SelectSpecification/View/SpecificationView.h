//
//  SpecificationView.h
//  SelectSpecification
//
//  Created by Mac on 2021/3/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SpecificationBlock)(NSString *specification, NSString *count);
@interface SpecificationView : UIView
@property (nonatomic, copy) SpecificationBlock block;
@end

NS_ASSUME_NONNULL_END
