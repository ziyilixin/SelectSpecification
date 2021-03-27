//
//  SpecificationCell.m
//  SelectSpecification
//
//  Created by Mac on 2021/3/26.
//

#import "SpecificationCell.h"

@implementation SpecificationCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = RGB_COLOR(@"#666666", 1.0);
        titleLabel.font = [UIFont systemFontOfSize:14.0];
        titleLabel.layer.cornerRadius = 4.0;
        titleLabel.layer.masksToBounds = YES;
        titleLabel.layer.borderColor = RGB_COLOR(@"#EAEAEA", 1.0).CGColor;
        titleLabel.layer.borderWidth = 1.0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.backgroundColor = RGB_COLOR(@"#FF5403", 1.0);
    }
    else {
        self.titleLabel.textColor = RGB_COLOR(@"#666666", 1.0);
        self.titleLabel.backgroundColor = [UIColor whiteColor];
    }
}

@end
