#ifndef __ADSMANAGER_H__
#define __ADSMANAGER_H__

#include <functional>
#include <vector>
#include <memory>
#include <chrono>
#include "Ads.h"

namespace avalon {
    
class BannerManager: public BannerDelegate
{
public:
    void add(Banner* banner);
    
    bool show();
    bool hide();
    void clear();
    
    BannerManager(BannerDelegate *delegate);
    ~BannerManager();
    
    void setBannerParams(int x, int y, int width, int height, BannerScaleType scaleType, BannerGravityType gravity);
    
private:
    virtual void bannerReceiveAd(Banner *banner) override;
    virtual void bannerClick(Banner *banner) override;
    virtual void bannerFailedToReceiveAd(Banner *banner, AdsErrorCode error, int nativeCode, const std::string &message) override;
    std::vector<Banner*> _banners;
    bool _needToShowBanner;
    int _x;
    int _y;
    int _width;
    int _height;
    BannerScaleType _scaleType;
    BannerGravityType _gravity;
    Banner* _visibleBanner;
    BannerDelegate *_delegate;
};

class InterstitialManager: public InterstitialDelegate
{
public:
    void add(Interstitial* interstitial);
    
    bool show(bool ignoreCounter, bool ignoreTimer);
    void clear();
    
    InterstitialManager(InterstitialDelegate *delegate);
    ~InterstitialManager();
    
    void setMinFrequency(int minFrequency);
    int getMinFrequency() const;
    void setMinDelay(float minDelay);
    float getMinDelay() const;
    void setMinDelayOnSameNetwork(float minDelayOnSameNetwork);
    float getMinDelayOnSameNetwork() const;
    
private:
    virtual void interstitialReceiveAd(Interstitial *interstitial) override;
    virtual void interstitialFailedToReceiveAd(Interstitial *interstitial, AdsErrorCode error, int nativeCode, const std::string &message) override;
    virtual void interstitialClose(Interstitial *interstitial) override;
    virtual void interstitialClick(Interstitial *interstitial) override;
    std::vector<Interstitial*> _interstitials;
    InterstitialDelegate *_delegate;
    std::chrono::steady_clock::time_point _prevShowTime;
    Interstitial* _lastInterstitial;
    int _interstitialCounter;
    int _minFrequency;
    float _minDelay;
    float _minDelayOnSameNetwork;
};

}

#endif /* __ADSMANAGER_H__ */
