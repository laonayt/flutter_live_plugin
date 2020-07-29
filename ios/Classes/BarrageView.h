//
//  BarrageView.h
//  ios_temp
//
//  Created by W E on 2020/7/29.
//  Copyright © 2020 W E. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BarrageView : UITableView
- (void)receiveMsg:(NSString *)msg;
@end

@interface BarrageCell : UITableViewCell
@property(nonatomic ,strong)UILabel *contentLabel;
@property(nonatomic ,copy) NSString *content;
@end

NS_ASSUME_NONNULL_END
