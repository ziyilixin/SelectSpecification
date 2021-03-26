//
//  SpecificationHeadView.m
//  SelectSpecification
//
//  Created by Mac on 2021/3/26.
//

#import "SpecificationHeadView.h"

@implementation SpecificationHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = RGB_COLOR(@"#333333", 1.0);
        titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}


@end
