//
//  BarrageView.m
//  ios_temp
//
//  Created by W E on 2020/7/29.
//  Copyright © 2020 W E. All rights reserved.
//

#import "BarrageView.h"

#define ScreenW  [UIScreen mainScreen].bounds.size.width

@interface BarrageView()<UITableViewDataSource>
@property (strong , nonatomic) NSMutableArray * dataArray;
@end

@implementation BarrageView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.transform = CGAffineTransformMakeScale (1,-1);
        [self registerClass:[BarrageCell class] forCellReuseIdentifier:@"barrageCell"];
        self.dataArray = [NSMutableArray array];
        self.backgroundColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)receiveMsg:(NSString *)msg {
    [self.dataArray insertObject:msg atIndex:0];
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    [self insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationTop];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    BarrageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"barrageCell"];
    cell.content = self.dataArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

@end

@implementation BarrageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.transform = CGAffineTransformMakeScale(1, -1);
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [self randomColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 10.0;
        label.layer.masksToBounds = true;
        [self addSubview:label];
        self.contentLabel = label;
    }
    return self;
}

- (void)setContent:(NSString *)content {
    _content = content;
    self.contentLabel.text = content;
    
    CGRect f = self.bounds;
    f.size.width = [self strWidth:content];
    f.size.height -= 10;
    self.contentLabel.frame = f;
}

- (UIColor *)randomColor {
    CGFloat r = arc4random()%256/255.0;
    CGFloat g = arc4random()%256/255.0;
    CGFloat b = arc4random()%256/255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

- (CGFloat)strWidth:(NSString *)content {
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],};
    CGSize textSize = [content boundingRectWithSize:CGSizeMake(ScreenW-10, 40) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    return textSize.width+10;
}

@end
