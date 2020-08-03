#import "FlutterLivePlugin.h"
#import "LFViewController.h"

@interface FlutterLivePlugin ()
@property(strong, nonatomic) LFViewController *liveVC;
@end

@implementation FlutterLivePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter/live/methodChannel"
            binaryMessenger:[registrar messenger]];

  FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"flutter/live/eventChannel" binaryMessenger:[registrar messenger]];

  LFViewController *liveVC = [[LFViewController alloc] init];
  [eventChannel setStreamHandler:liveVC];

  FlutterLivePlugin *instance = [[FlutterLivePlugin alloc] init];
  instance.liveVC = liveVC;
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSDictionary * dict = call.arguments;

  if ([call.method isEqualToString:@"startLive"]) {
      UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
      _liveVC.liveUrl = dict[@"url"];
      _liveVC.modalPresentationStyle = UIModalPresentationFullScreen;
      [viewController presentViewController:_liveVC animated:YES completion:nil];
      NSLog(@"流地址是 %@",dict[@"url"]);
  }
  else if ([call.method isEqualToString:@"sendBarrage"]) {
      [[NSNotificationCenter defaultCenter] postNotificationName:@"barrageNoti" object:dict[@"msg"]];
      NSLog(@"收到弹幕: %@",dict[@"msg"]);
  }
  else {
    result(FlutterMethodNotImplemented);
  }
}

@end
