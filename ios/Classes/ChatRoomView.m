//
//  ChatRoomView.m
//  ios_temp
//
//  Created by W E on 2020/7/21.
//  Copyright © 2020 W E. All rights reserved.
//

#import "ChatRoomView.h"

@interface ChatRoomView()<UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property (strong , nonatomic) NSMutableArray * dataArray;
@end

@implementation ChatRoomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.dataArray = [NSMutableArray array];
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.tableView];
    }
    return self;
}

//这个方法相当于vc中的viewDidLoad
- (void)didMoveToWindow {
    if (self.window) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveBarrageMsg:) name:@"barrageNoti" object:nil];
    }
}

//从当前window删除 相当于-viewDidUnload
- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (newWindow == nil) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

#pragma mark 接收信息的代理
-(void)receiveBarrageMsg:(NSNotification *)noti {
    [self.dataArray addObject:noti.object];
    [self.tableView reloadData];
    
    if (self.dataArray.count > 20) {
        [self.dataArray removeObjectsInRange:NSMakeRange(0, 15)];
        [self.tableView reloadData];
        return;
    }
    
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count -1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chatCell"];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark - Lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 20;
    }
    return _tableView;
}

@end

//@implementation ChatCell
//
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        self.backgroundColor = [UIColor clearColor];
//        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, self.bounds.size.width-16, self.bounds.size.height-16)];
//        label.font = [UIFont systemFontOfSize:13];
//        label.textColor = [UIColor redColor];
//        label.backgroundColor = [UIColor yellowColor];
//        [self addSubview:label];
//        self.titleLabel = label;
//        
//    }
//    return self;
//}
//
//@end
