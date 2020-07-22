#import "FlutterLivePlugin.h"
#import "LFViewController.h"

@interface FlutterLivePlugin ()
@property(strong, nonatomic) UIViewController *viewController;
@end

@implementation FlutterLivePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_live_plugin"
            binaryMessenger:[registrar messenger]];

  UIViewController *viewController =
    [UIApplication sharedApplication].delegate.window.rootViewController;

  FlutterLivePlugin* instance = [[FlutterLivePlugin alloc] initWithViewController:viewController];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
  self = [super init];
  if (self) {
    self.viewController = viewController;
  }
  return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSDictionary * dict = call.arguments;

  if ([call.method isEqualToString:@"startLive"]) {
      LFViewController *liveVC = [[LFViewController alloc] init];
      liveVC.liveUrl = dict[@"url"];
      liveVC.modalPresentationStyle = UIModalPresentationFullScreen;
      [self.viewController presentViewController:liveVC animated:YES completion:nil];
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
