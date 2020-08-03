//
//  LFViewController.h
//  LFDemo
//
//  Created by W E on 2020/2/5.
//  Copyright © 2020 zonekey. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFViewController : UIViewController<FlutterStreamHandler>
@property (nonatomic ,copy) NSString *liveUrl;
@property (nonatomic) FlutterEventSink eventSink;
@end

NS_ASSUME_NONNULL_END
