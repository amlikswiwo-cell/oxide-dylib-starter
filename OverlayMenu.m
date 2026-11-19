#import <UIKit/UIKit.h>

@interface OxideOverlayMenu : UIView
@property(nonatomic, strong) UIVisualEffectView *panel;
@end

@implementation OxideOverlayMenu
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    self.backgroundColor = UIColor.clearColor;
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemMaterialDark];
    self.panel = [[UIVisualEffectView alloc] initWithEffect:blur];
    self.panel.frame = CGRectMake(18, 90, 260, 300);
    self.panel.layer.cornerRadius = 18;
    self.panel.clipsToBounds = YES;
    [self addSubview:self.panel];
    UIView *content = self.panel.contentView;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(16, 12, 228, 28)];
    title.text = @"OXIDE • MOD MENU";
    title.textColor = UIColor.whiteColor;
    title.font = [UIFont boldSystemFontOfSize:16];
    [content addSubview:title];
    NSArray<NSString *> *names = @[@"ESP (UI demo)", @"Aim (UI demo)", @"Farm (UI demo)"];
    for (NSInteger i = 0; i < names.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 54 + i * 56, 170, 32)];
        label.text = names[i]; label.textColor = UIColor.whiteColor;
        label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        [content addSubview:label];
        UISwitch *toggle = [[UISwitch alloc] initWithFrame:CGRectZero];
        toggle.on = NO; toggle.transform = CGAffineTransformMakeScale(0.82, 0.82);
        toggle.center = CGPointMake(220, 70 + i * 56);
        [toggle addTarget:self action:@selector(demoToggleChanged:) forControlEvents:UIControlEventValueChanged];
        [content addSubview:toggle];
    }
    UILabel *note = [[UILabel alloc] initWithFrame:CGRectMake(16, 238, 228, 44)];
    note.text = @"Demo UI only — toggles do not affect the game.";
    note.numberOfLines = 2; note.textColor = [UIColor colorWithWhite:1 alpha:0.7];
    note.font = [UIFont systemFontOfSize:11]; [content addSubview:note];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragPanel:)];
    [self.panel addGestureRecognizer:pan]; self.panel.userInteractionEnabled = YES;
    return self;
}
- (void)demoToggleChanged:(UISwitch *)sender { /* UI-only placeholder */ }
- (void)dragPanel:(UIPanGestureRecognizer *)gesture {
    CGPoint delta = [gesture translationInView:self];
    self.panel.center = CGPointMake(self.panel.center.x + delta.x, self.panel.center.y + delta.y);
    [gesture setTranslation:CGPointZero inView:self];
}
@end
