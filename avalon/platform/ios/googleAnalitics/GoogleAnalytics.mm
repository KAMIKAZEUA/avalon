#include "avalon/GoogleAnalytics.h"
#import "GAI.h"
#import "GAITracker.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"


namespace avalon {

static std::map<int,std::string> _contentGroups;
static std::map<int,std::string> _customDimensions;
static std::map<int,std::string> _customMetrics;
    
const std::string &GAIFields::getContentGroup(int index)
{
    auto it = _contentGroups.find(index);
    if(it != _contentGroups.end())
        return it->second;
    auto ret = _contentGroups.insert(std::make_pair(index, [[::GAIFields contentGroupForIndex:index] cStringUsingEncoding:NSUTF8StringEncoding]));
    return ret.first->second;
}
    
const std::string &GAIFields::getCustomDimension(int index)
{
    auto it = _customDimensions.find(index);
    if(it != _customDimensions.end())
        return it->second;
    auto ret = _customDimensions.insert(std::make_pair(index, [[::GAIFields customDimensionForIndex:index] cStringUsingEncoding:NSUTF8StringEncoding]));
    return ret.first->second;
}
    
const std::string &GAIFields::getCustomMetric(int index)
{
    auto it = _customMetrics.find(index);
    if(it != _customMetrics.end())
        return it->second;
    auto ret = _customMetrics.insert(std::make_pair(index, [[::GAIFields customMetricForIndex:index] cStringUsingEncoding:NSUTF8StringEncoding]));
    return ret.first->second;
}

    
class IOSGAITracker: public GoogleAnalyticsTracker
{
public:
    virtual void setParameter(const std::string &name, const std::string &value) override
    {
        [_tracker set:[NSString stringWithCString:name.c_str() encoding:NSUTF8StringEncoding] value:[NSString stringWithCString:value.c_str() encoding:NSUTF8StringEncoding]];
    }
    
    virtual std::string getParameter(const std::string &name) const override
    {
        NSString *ret = [_tracker get:[NSString stringWithCString:name.c_str() encoding:NSUTF8StringEncoding]];
        if(ret)
            return [ret cStringUsingEncoding:NSUTF8StringEncoding];
        else
            return "";
    }
    
    virtual void setSampleRate(float value) override
    {
        [_tracker set:kGAISampleRate value:[NSString stringWithFormat:@"%f", value]];
    }

    virtual float GetSampleRate() const override
    {
        NSString *ret = [_tracker get:kGAISampleRate];
        if(ret)
            return [ret floatValue];
        else
            return 100.0;
    }
    
    virtual const std::string &getTrackerId() const override
    {
        return _trackerId;
    }

    
    virtual void sendAppView(const std::string &name) override
    {
        [_tracker set:kGAIScreenName value:[NSString stringWithCString:name.c_str() encoding:NSUTF8StringEncoding]];
        [_tracker send:[[GAIDictionaryBuilder createAppView] build]];
    }

    virtual void sendEvent(const std::string &category, const std::string &action, const std::string &label, long value) override
    {
        [_tracker send:[[GAIDictionaryBuilder
                         createEventWithCategory:[NSString stringWithCString:category.c_str() encoding:NSUTF8StringEncoding]
                         action:[NSString stringWithCString:action.c_str() encoding:NSUTF8StringEncoding]
                         label:[NSString stringWithCString:label.c_str() encoding:NSUTF8StringEncoding]
                         value:[NSNumber numberWithLong:value]] build]];
    }

    virtual void sendException(const std::string &description, bool fatal) override
    {
        [_tracker send:[[GAIDictionaryBuilder
                         createExceptionWithDescription:[NSString stringWithCString:description.c_str() encoding:NSUTF8StringEncoding]
                         withFatal:[NSNumber numberWithBool:fatal]] build]];
    }

    virtual void sendItem(const std::string &transactionId, const std::string &name, const std::string &sku,const std::string &category, double price, long quantity, const std::string &currencyCode) override
    {
        [_tracker send:[[GAIDictionaryBuilder
                         createItemWithTransactionId:[NSString stringWithCString:transactionId.c_str() encoding:NSUTF8StringEncoding]
                         name:[NSString stringWithCString:name.c_str() encoding:NSUTF8StringEncoding]
                         sku:[NSString stringWithCString:sku.c_str() encoding:NSUTF8StringEncoding]
                         category:[NSString stringWithCString:category.c_str() encoding:NSUTF8StringEncoding]
                         price:[NSNumber numberWithDouble:price]
                         quantity:[NSNumber numberWithLong:quantity]
                         currencyCode:[NSString stringWithCString:currencyCode.c_str() encoding:NSUTF8StringEncoding]] build]];
    }

    virtual void sendSocial(const std::string &network, const std::string &action, const std::string &target) override
    {
        [_tracker send:[[GAIDictionaryBuilder
                         createSocialWithNetwork:[NSString stringWithCString:network.c_str() encoding:NSUTF8StringEncoding]
                         action:[NSString stringWithCString:action.c_str() encoding:NSUTF8StringEncoding]
                         target:[NSString stringWithCString:target.c_str() encoding:NSUTF8StringEncoding]] build]];
    }

    virtual void sendTiming(const std::string &category, long intervalMillis, const std::string &name, const std::string &label) override
    {
        [_tracker send:[[GAIDictionaryBuilder
                         createTimingWithCategory:[NSString stringWithCString:category.c_str() encoding:NSUTF8StringEncoding]
                         interval:[NSNumber numberWithLong:intervalMillis]
                         name:[NSString stringWithCString:name.c_str() encoding:NSUTF8StringEncoding]
                         label:[NSString stringWithCString:label.c_str() encoding:NSUTF8StringEncoding]] build]];
    }

    virtual void sendTransaction(const std::string &transactionId, const std::string &affiliation, double revenue, double tax, double shipping, const std::string &currencyCode) override
    {
        [_tracker send:[[GAIDictionaryBuilder
                         createTransactionWithId:[NSString stringWithCString:transactionId.c_str() encoding:NSUTF8StringEncoding]
                         affiliation:[NSString stringWithCString:affiliation.c_str() encoding:NSUTF8StringEncoding]
                         revenue:[NSNumber numberWithDouble:revenue]
                         tax:[NSNumber numberWithDouble:tax]
                         shipping:[NSNumber numberWithDouble:shipping]
                         currencyCode:[NSString stringWithCString:currencyCode.c_str() encoding:NSUTF8StringEncoding]] build]];
    }

    IOSGAITracker(const std::string &trackerId, id<GAITracker> tracker):_tracker(tracker),_trackerId(trackerId)
    {
        
    }
    ~IOSGAITracker()
    {
        
    }
    
private:
    id< GAITracker > _tracker;
    std::string _trackerId;
};
    
void GoogleAnalytics::setDispatchInterval(double value)
{
    [GAI sharedInstance].dispatchInterval = value;
}
double GoogleAnalytics::getDispatchInterval() const
{
    return [GAI sharedInstance].dispatchInterval;
}
    
void GoogleAnalytics::setTrackUncaughtExceptions(bool value)
{
    [GAI sharedInstance].trackUncaughtExceptions = value;
}
bool GoogleAnalytics::getTrackUncaughtExceptions() const
{
    return [GAI sharedInstance].trackUncaughtExceptions;
}

void GoogleAnalytics::setDryRun(bool value)
{
    [GAI sharedInstance].dryRun = value;
}
bool GoogleAnalytics::getDryRun() const
{
    return [GAI sharedInstance];
}

void GoogleAnalytics::setOptOut(bool value)
{
    [GAI sharedInstance].optOut = value;
}
bool GoogleAnalytics::getOptOut() const
{
    return [GAI sharedInstance].optOut;
}

GoogleAnalytics *GoogleAnalytics::getInstance()
{
    static GoogleAnalytics* instance = new GoogleAnalytics();
    return instance;
}

GoogleAnalyticsTracker* GoogleAnalytics::getTracker(const std::string &trackingId)
{
    auto it = _trackers.find(trackingId);
    if(it != _trackers.end())
        return it->second;
    IOSGAITracker *ret = new IOSGAITracker(trackingId, [[GAI sharedInstance] trackerWithTrackingId:[NSString stringWithCString:trackingId.c_str() encoding:NSUTF8StringEncoding]]);
    _trackers.insert(std::make_pair(trackingId, ret));
    return ret;
}
void GoogleAnalytics::removeTracker(GoogleAnalyticsTracker *tracker)
{
    if(tracker)
    {
        const std::string &trackerId = tracker->getTrackerId();
        [[GAI sharedInstance] removeTrackerByName:[NSString stringWithCString:trackerId.c_str() encoding:NSUTF8StringEncoding]];
        _trackers.erase(trackerId);
    }
}

void GoogleAnalytics::dispatch()
{
    [[GAI sharedInstance] dispatch];
}

GoogleAnalytics::GoogleAnalytics()
{
    
}
GoogleAnalytics::~GoogleAnalytics()
{
    
}

}
