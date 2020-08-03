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

  FlutterLivePlugin* instance = [[FlutterLivePlugin alloc] initWithViewController:viewController];

  [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar{
    self = [super init];
    if (self) {
        _registrar = registrar;
        _liveVC = [[LFViewController alloc] init];

        FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"flutter/live/eventChannel" binaryMessenger:[_registrar messenger]];
        [eventChannel setStreamHandler:_liveVC];
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSDictionary * dict = call.arguments;

  UIViewController *viewController =
    [UIApplication sharedApplication].delegate.window.rootViewController;

  if ([call.method isEqualToString:@"startLive"]) {
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
