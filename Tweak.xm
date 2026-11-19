#import <UIKit/UIKit.h>

// UI-only demonstration entry point. This does not inspect or modify game state.
@interface OxideOverlayMenu : UIView
@end

static void OxideOverlayAttachMenu(void) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIApplication *application = UIApplication.sharedApplication;
        UIWindow *window = nil;
        if (@available(iOS 13.0, *)) {
            for (UIScene *scene in application.connectedScenes) {
                if (scene.activationState != UISceneActivationStateForegroundActive) continue;
                if (![scene isKindOfClass:UIWindowScene.class]) continue;
                for (UIWindow *candidate in ((UIWindowScene *)scene).windows) {
                    if (candidate.isKeyWindow) { window = candidate; break; }
                }
                if (window) break;
            }
        }
        if (!window) {
            for (UIWindow *candidate in application.windows) {
                if (candidate.isKeyWindow) { window = candidate; break; }
            }
        }
        if (!window) {
            NSLog(@"[OxideOverlayStarter] No active window; demo overlay not attached.");
            return;
        }
        for (UIView *subview in window.subviews) {
            if ([subview isKindOfClass:OxideOverlayMenu.class]) return;
        }
        OxideOverlayMenu *menu = [[OxideOverlayMenu alloc] initWithFrame:window.bounds];
        menu.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        menu.backgroundColor = UIColor.clearColor;
        [window addSubview:menu];
        NSLog(@"[OxideOverlayStarter] UI demo overlay attached.");
    });
}

%ctor {
    @autoreleasepool {
        NSLog(@"[OxideOverlayStarter] Loaded; UI-only demo mode.");
        dispatch_async(dispatch_get_main_queue(), ^{
            OxideOverlayAttachMenu();
            [NSNotificationCenter.defaultCenter
                addObserverForName:UIApplicationDidBecomeActiveNotification
                            object:nil
                             queue:NSOperationQueue.mainQueue
                        usingBlock:^(__unused NSNotification *notification) {
                OxideOverlayAttachMenu();
            }];
        });
    }
}
