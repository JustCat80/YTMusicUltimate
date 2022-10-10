#import <Foundation/Foundation.h>
#include "Imports.h"

%group SettingsPage
%hook YTMAvatarAccountView
%property(nonatomic,strong) YTMUltimateSettingsController *YTMUltimateController;

- (void)setAccountMenuUpperButtons:(id)arg1 lowerButtons:(id)arg2 {
    
    UIImage *icon;
    if (@available(iOS 13, *)) {
        icon = [UIImage systemImageNamed:@"flame"];
    } else {
        icon = nil;
    }
    
    //Create the YTMusicUltimate button
    YTMAccountButton *button = [[%c(YTMAccountButton) alloc] initWithTitle:@"YTMusicUltimate" identifier:@"ytmult" icon:icon actionBlock:^(BOOL arg4) {
        //Push YTMusicUltimate view controller.

        self.YTMUltimateController = [[YTMUltimateSettingsController alloc] init];
        [self._viewControllerForAncestor presentViewController:self.YTMUltimateController animated:YES completion:nil];
    }];

    button.tintColor = [UIColor redColor];

    //Add our custom button to the list.
    NSMutableArray *arrDown = [[NSMutableArray alloc] init];
    [arrDown addObjectsFromArray:arg2];
    [arrDown addObject:button];

    //Remove the subscribe to premium button.
    NSMutableArray *arrUp = [[NSMutableArray alloc] init];
    for (YTMAccountButton *yt_button in arg1) {
        if (![[yt_button.titleLabel text] containsString:@"Premium"]) {
            [arrUp addObject:yt_button];
        }
    }

    //Continue the function with our own parameters.
    %orig(arrUp, arrDown);
}
%end
%end

%ctor {
    %init(SettingsPage);
}