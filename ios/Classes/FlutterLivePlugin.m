#import "FlutterLivePlugin.h"
#import "LFViewController.h"

@interface FlutterLivePlugin ()
@property (nonatomic) FlutterEventSink eventSink;
@end

@implementation FlutterLivePlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"flutter/live/methodChannel" binaryMessenger:[registrar messenger]];

  FlutterEventChannel* eventChannel = [FlutterEventChannel eventChannelWithName:@"flutter/live/eventChannel" binaryMessenger:[registrar messenger]];

  FlutterLivePlugin* instance = [[FlutterLivePlugin alloc] init];

  [eventChannel setStreamHandler:instance];

  [registrar addMethodCallDelegate:instance channel:channel];
}

#pragma mark - FlutterStreamHandler

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    _eventSink = nil;
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    _eventSink = events;
    return nil;
}


- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSDictionary * dict = call.arguments;

  if ([call.method isEqualToString:@"startLive"]) {
      LFViewController *liveVC = [[LFViewController alloc] init];
      liveVC.liveUrl = dict[@"url"];
      liveVC.eventSink = _eventSink;
      liveVC.modalPresentationStyle = UIModalPresentationFullScreen;

      UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
      [viewController presentViewController:liveVC animated:YES completion:nil];
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
