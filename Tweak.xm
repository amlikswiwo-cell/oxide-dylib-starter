#import <UIKit/UIKit.h>

// Safe starter entry point. No game hooks, memory inspection/modification,
// gameplay automation, or anti-cheat bypass is implemented here.
%ctor {
    NSLog(@"[OxideOverlayStarter] Loaded. UI integration is not configured.");
}
