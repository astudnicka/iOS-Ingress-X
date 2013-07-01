//
//  OpsViewController.m
//  Ingress
//
//  Created by Alex Studnička on 16.06.13.
//  Copyright (c) 2013 A&A Code. All rights reserved.
//

#import "OpsViewController.h"
#import "TTUIScrollViewSlidingPages.h"

@implementation OpsViewController {
	UIScrollView *buttonsScrollView;
	UIButton *selectedButton;
	UIViewController *selectedViewController;
}

- (void)setButtonStyle:(UIButton *)button selected:(BOOL)selected {
	if (selected) {
		CGRect frame = button.frame;
		frame.size.height = 48;
		button.frame = frame;
		
		UIImage *bgImage = [[UIImage imageNamed:@"opsButtonSelected.png"] stretchableImageWithLeftCapWidth:16 topCapHeight:16];
		[button setBackgroundImage:bgImage forState:UIControlStateNormal];
		
		UIColor *color = [UIColor colorWithRed:254./255. green:178./255. blue:26./255. alpha:1];
		[button setTitleColor:color forState:UIControlStateNormal];
		button.titleLabel.layer.shadowColor = color.CGColor;
	} else {
		CGRect frame = button.frame;
		frame.size.height = 44;
		button.frame = frame;
		
		UIImage *bgImage = [[UIImage imageNamed:@"opsButton.png"] stretchableImageWithLeftCapWidth:16 topCapHeight:16];
		[button setBackgroundImage:bgImage forState:UIControlStateNormal];
		
		UIColor *color = [UIColor colorWithRed:82./255. green:254./255. blue:254./255. alpha:1];
		[button setTitleColor:color forState:UIControlStateNormal];
		button.titleLabel.layer.shadowColor = color.CGColor;
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];

	[opsLabel setAttributedText:[[NSAttributedString alloc] initWithString:@"OPS" attributes:[Utilities attributesWithShadow:YES size:18 color:[UIColor colorWithRed:235./255. green:188./255. blue:74./255. alpha:1.0]]]];
	opsLabel.rightInset = 10;
	
	labelBackgroundImage.image = [[UIImage imageNamed:@"ops_background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 236)];
	
	CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width;
	NSArray *views = @[@"ITEMS", @"INTEL", @"MISSION", @"RECRUIT", @"DEVICE"];
	
	buttonsScrollView = [UIScrollView new];
	buttonsScrollView.bounces = NO;
	buttonsScrollView.clipsToBounds = NO;
	buttonsScrollView.alwaysBounceHorizontal = NO;
	buttonsScrollView.showsHorizontalScrollIndicator = NO;
	buttonsScrollView.frame = CGRectMake(0, 52, viewWidth, 44);
	
	int i = 0;
	CGFloat offset = 0;
	for (NSString *viewName in views) {
		UIButton *viewButton = [UIButton buttonWithType:UIButtonTypeCustom];
		viewButton.frame = CGRectMake(offset, 0, 130, 44);
		viewButton.tag = 10+i;
		viewButton.titleLabel.font = [UIFont fontWithName:[[[UILabel appearance] font] fontName] size:18];
		viewButton.titleLabel.layer.shadowOffset = CGSizeZero;
		viewButton.titleLabel.layer.shadowRadius = 18/5;
		viewButton.titleLabel.layer.shadowOpacity = 1;
		viewButton.titleLabel.layer.shouldRasterize = YES;
		viewButton.titleLabel.layer.masksToBounds = NO;
		[self setButtonStyle:viewButton selected:(i == 0)];
        [viewButton setTitle:viewName forState:UIControlStateNormal];
        [viewButton addTarget:self action:@selector(menuSelected:) forControlEvents:UIControlEventTouchUpInside];
        [buttonsScrollView addSubview:viewButton];
		offset += viewButton.frame.size.width;
		i++;
	}
	
	buttonsScrollView.contentSize = CGSizeMake(offset, 44);
	[self.view addSubview:buttonsScrollView];
	[self.view sendSubviewToBack:buttonsScrollView];
	
	[self menuSelected:(UIButton *)[buttonsScrollView viewWithTag:10]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)back {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:DeviceSoundToggleEffects]) {
        [[SoundManager sharedManager] playSound:@"Sound/sfx_ui_success.aif"];
    }

	if ([self.delegate respondsToSelector:@selector(willDismissOpsViewController:)]) {
		[self.delegate willDismissOpsViewController:self];
	}

	[self dismissViewControllerAnimated:YES completion:^{
		if ([self.delegate respondsToSelector:@selector(didDismissOpsViewController:)]) {
			[self.delegate didDismissOpsViewController:self];
		}
	}];
}

#pragma mark - Menu

- (void)menuSelected:(UIButton *)button {
	
	if ([button isEqual:selectedButton]) { return; }
	
	[self setButtonStyle:selectedButton selected:NO];
	[self setButtonStyle:button selected:YES];
	selectedButton = button;
	
	CGFloat x = (button.frame.origin.x-(buttonsScrollView.frame.size.width/2))+(button.frame.size.width/2);
	x = MIN(buttonsScrollView.contentSize.width-buttonsScrollView.frame.size.width, MAX(0, x));
	buttonsScrollView.contentOffset = CGPointMake(x, 0);
	
	[selectedViewController.view removeFromSuperview];
	[selectedViewController removeFromParentViewController];
	selectedViewController = nil;
	
    UIViewController *viewController;
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
	
	switch (button.tag-10) {
//		case 0:
//			viewController = [storyboard instantiateViewControllerWithIdentifier:@"ResourcesViewController"];
//			break;
//		case 1:
//			viewController = [storyboard instantiateViewControllerWithIdentifier:@"PortalKeysViewController"];
//			break;
//		case 2:
//			viewController = [storyboard instantiateViewControllerWithIdentifier:@"MediaItemsViewController"];
//			break;
		case 0:
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"ItemsViewController"];
			break;
        case 1:
			viewController = [storyboard instantiateViewControllerWithIdentifier:@"ScoreViewController"];
			break;
		case 2:
			viewController = [storyboard instantiateViewControllerWithIdentifier:@"MissionsViewController"];
			break;
		case 3:
			viewController = [storyboard instantiateViewControllerWithIdentifier:@"RecruitViewController"];
			break;
		case 4:
			viewController = [storyboard instantiateViewControllerWithIdentifier:@"DeviceViewController"];
			break;
	}
	
	CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width;
	CGFloat viewHeight = [UIScreen mainScreen].bounds.size.height;
	viewController.view.frame = CGRectMake(0, 96, viewWidth, viewHeight-96);
	
	[self.view addSubview:viewController.view];
	[self.view sendSubviewToBack:viewController.view];
	[self addChildViewController:viewController];
	selectedViewController = viewController;
}

@end
