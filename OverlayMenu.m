#import <UIKit/UIKit.h>

@interface OxideOverlayMenu : UIView
@property(nonatomic, strong) UIVisualEffectView *panel;
@end

@implementation OxideOverlayMenu
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    self.backgroundColor = UIColor.clearColor;

    self.panel = [[UIVisualEffectView alloc] initWithEffect:
        [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemMaterialDark]];
    self.panel.frame = CGRectMake(18, 90, 276, 300);
    self.panel.layer.cornerRadius = 18;
    self.panel.clipsToBounds = YES;
    self.panel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
                                  UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:self.panel];

    UIView *content = self.panel.contentView;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(16, 12, 244, 28)];
    title.text = @"OXIDE • UI DEMO";
    title.textColor = UIColor.whiteColor;
    title.font = [UIFont boldSystemFontOfSize:16];
    [content addSubview:title];

    NSArray<NSString *> *names = @[
        @"FPS indicator (demo)",
        @"Crosshair preview (demo)",
        @"Status panel (demo)"
    ];
    for (NSInteger i = 0; i < names.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 54 + i * 56, 190, 32)];
        label.text = names[i];
        label.textColor = UIColor.whiteColor;
        label.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
        [content addSubview:label];

        UISwitch *toggle = [[UISwitch alloc] initWithFrame:CGRectZero];
        toggle.on = NO;
        toggle.transform = CGAffineTransformMakeScale(0.82, 0.82);
        toggle.center = CGPointMake(238, 70 + i * 56);
        [toggle addTarget:self action:@selector(demoToggleChanged:)
         forControlEvents:UIControlEventValueChanged];
        [content addSubview:toggle];
    }

    UILabel *note = [[UILabel alloc] initWithFrame:CGRectMake(16, 238, 244, 44)];
    note.text = @"Visual prototype only. Switches do not change gameplay.";
    note.numberOfLines = 2;
    note.textColor = [UIColor colorWithWhite:1 alpha:0.72];
    note.font = [UIFont systemFontOfSize:11];
    [content addSubview:note];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]
        initWithTarget:self action:@selector(dragPanel:)];
    [self.panel addGestureRecognizer:pan];
    self.panel.userInteractionEnabled = YES;
    return self;
}

// Keep the rest of the game window interactive outside the demo panel.
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint panelPoint = [self convertPoint:point toView:self.panel];
    if (![self.panel pointInside:panelPoint withEvent:event]) return nil;
    return [super hitTest:point withEvent:event];
}

- (void)demoToggleChanged:(UISwitch *)sender {
    // Deliberately UI-only; no game state is read or changed.
    NSLog(@"[OxideOverlayStarter] Demo switch changed: %@", sender.on ? @"on" : @"off");
}

- (void)dragPanel:(UIPanGestureRecognizer *)gesture {
    CGPoint delta = [gesture translationInView:self];
    self.panel.center = CGPointMake(self.panel.center.x + delta.x,
                                    self.panel.center.y + delta.y);
    [gesture setTranslation:CGPointZero inView:self];
}
@end
