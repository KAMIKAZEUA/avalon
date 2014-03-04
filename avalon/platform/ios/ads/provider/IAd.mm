#ifdef AVALON_CONFIG_ADS_PROVIDER_IAD_ENABLED

#include <avalon/ads/provider/IAd.h>

#include <avalon/utils/assert.hpp>
#include <list>
#import <iAd/iAd.h>
#import "AppController.h"
#import "RootViewController.h"

static std::list<ADBannerView*> iadActiveBannerObjects;

@interface IAdDelegate : NSObject<ADBannerViewDelegate>
{
}
- (void)bannerViewDidLoadAd:(ADBannerView*)banner;
- (void)bannerView:(ADBannerView*)banner didFailToReceiveAdWithError:(NSError*)error;
- (BOOL)bannerViewActionShouldBegin:(ADBannerView*)banner willLeaveApplication:(BOOL)willLeave;
+ (void)removeBannerView:(ADBannerView*)banner;
@end

@implementation IAdDelegate
- (void)bannerViewDidLoadAd:(ADBannerView*)banner
{
    AppController* appController = (AppController*) [UIApplication sharedApplication].delegate;
    [appController->viewController.view addSubview:banner];
}

- (void)bannerView:(ADBannerView*)banner didFailToReceiveAdWithError:(NSError*)error
{
    NSLog(@"[IAd] bannerView didFailToReceiveAdWithError: %d %@", error.code, error.localizedDescription);
    [IAdDelegate removeBannerView:banner];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView*)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

+ (void)removeBannerView:(ADBannerView*)banner
{
    [banner setHidden:YES];
    [banner cancelBannerViewAction];
    [banner removeFromSuperview];

    [banner.delegate release];
    banner.delegate = nil;
    [banner release];

    iadActiveBannerObjects.remove(banner);
}
@end

namespace avalon {
namespace ads {
namespace provider {

IAd::IAd()
{
}

void IAd::init()
{
}

void IAd::hideAds()
{
    for (ADBannerView* adView : iadActiveBannerObjects) {
        [IAdDelegate removeBannerView:adView];
    }
}

void IAd::showBanner()
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    bool isPortrait = (orientation == UIInterfaceOrientationPortrait) || (orientation == UIInterfaceOrientationPortraitUpsideDown);

    ADBannerView* adView;
    // On iOS 6 ADBannerView introduces a new initializer, use it when available.
    if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)]) {
        adView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    } else {
        adView = [[ADBannerView alloc] init];
    }
    adView.delegate = [[IAdDelegate alloc] init];
    iadActiveBannerObjects.push_back(adView);

    // As of iOS 6.0, the banner will automatically resize itself based on its width.
    // To support iOS 5.0 however, we continue to set the currentContentSizeIdentifier appropriately.
    if (isPortrait) {
        adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
        adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    } else {
        adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierLandscape];
        adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    }

    // Move it to the bottom
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect adFrame = adView.frame;
    if (isPortrait) {
        adFrame.origin.y = screenRect.size.height - adView.frame.size.height;
    } else {
        adFrame.origin.y = screenRect.size.width  - adView.frame.size.height;
    }
    adView.frame = adFrame;
}

} // namespace provider
} // namespace ads
} // namespace avalon

#endif /* AVALON_CONFIG_ADS_PROVIDER_IAD_ENABLED */