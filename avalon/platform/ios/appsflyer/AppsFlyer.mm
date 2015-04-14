//
//  AppsFlyerTracker.h
//  AppsFlyerLib
//
//  AppsFlyer iOS SDK v2.5.3.14
//  08-Mar-2015
//  Copyright (c) 2013 AppsFlyer Ltd. All rights reserved.
//
//  Please read AppsFlyer's iOS SDK documentation before integrating this library in your app:
//  http://support.appsflyer.com/entries/25458906-iOS-SDK-Integration-Guide-v2-5-3-x-New-API-
//

#include "avalon/AppsFlyer.h"
#include "avalon/platform/ios/utils/utils.h"
#import "AppsFlyerTracker.h"

namespace avalon {
const std::string AppsFlyerTracker::EventLevelAchieved = "af_level_achieved";
const std::string AppsFlyerTracker::EventAddPaymentInfo = "af_add_payment_info";
const std::string AppsFlyerTracker::EventAddToCart = "af_add_to_cart";
const std::string AppsFlyerTracker::EventAddToWishlist = "af_add_to_wishlist";
const std::string AppsFlyerTracker::EventCompleteRegistration = "af_complete_registration";
const std::string AppsFlyerTracker::EventTutorial_completion = "af_tutorial_completion";
const std::string AppsFlyerTracker::EventInitiatedCheckout = "af_initiated_checkout";
const std::string AppsFlyerTracker::EventPurchase = "af_purchase";
const std::string AppsFlyerTracker::EventRate = "af_rate";
const std::string AppsFlyerTracker::EventSearch = "af_search";
const std::string AppsFlyerTracker::EventSpentCredits = "af_spent_credits";
const std::string AppsFlyerTracker::EventAchievementUnlocked = "af_achievement_unlocked";
const std::string AppsFlyerTracker::EventContentView = "af_content_view";
const std::string AppsFlyerTracker::EventListView = "af_list_view";
const std::string AppsFlyerTracker::EventTravelBooking = "af_travel_booking";
const std::string AppsFlyerTracker::EventShare = "af_share";
const std::string AppsFlyerTracker::EventInvite = "af_invite";
const std::string AppsFlyerTracker::EventLogin = "af_login";
const std::string AppsFlyerTracker::EventReEngage = "af_re_engage";
const std::string AppsFlyerTracker::EventUpdate = "af_update";
const std::string AppsFlyerTracker::EventOpenedFromPushNotification = "af_opened_from_push_notification";

// In app event parameter names
const std::string AppsFlyerTracker::EventParamLevel = "af_level";
const std::string AppsFlyerTracker::EventParamScore = "af_score";
const std::string AppsFlyerTracker::EventParamSuccess = "af_success";
const std::string AppsFlyerTracker::EventParamPrice = "af_price";
const std::string AppsFlyerTracker::EventParamContentType = "af_content_type";
const std::string AppsFlyerTracker::EventParamContentId = "af_content_id";
const std::string AppsFlyerTracker::EventParamCurrency = "af_currency";
const std::string AppsFlyerTracker::EventParamQuantity = "af_quantity";
const std::string AppsFlyerTracker::EventParamRegistrationMethod = "af_registration_method";
const std::string AppsFlyerTracker::EventParamPaymentInfoAvailable = "af_payment_info_available";
const std::string AppsFlyerTracker::EventParamMaxRatingValue = "af_max_rating_value";
const std::string AppsFlyerTracker::EventParamRatingValue = "af_rating_value";
const std::string AppsFlyerTracker::EventParamSearchString = "af_search_string";
const std::string AppsFlyerTracker::EventParamDateA = "af_date_a";
const std::string AppsFlyerTracker::EventParamDateB = "af_date_b";
const std::string AppsFlyerTracker::EventParamDestinationA = "af_destination_a";
const std::string AppsFlyerTracker::EventParamDestinationB = "af_destination_b";
const std::string AppsFlyerTracker::EventParamDescription = "af_description";
const std::string AppsFlyerTracker::EventParamClass = "af_class";
const std::string AppsFlyerTracker::EventParamEventStart = "af_event_start";
const std::string AppsFlyerTracker::EventParamEventEnd = "af_event_end";
const std::string AppsFlyerTracker::EventParamLat = "af_lat";
const std::string AppsFlyerTracker::EventParamLong = "af_long";
const std::string AppsFlyerTracker::EventParamCustomerUserId = "af_customer_user_id";
const std::string AppsFlyerTracker::EventParamValidated = "af_validated";
const std::string AppsFlyerTracker::EventParamRevenue = "af_revenue";
const std::string AppsFlyerTracker::EventParamReceiptId = "af_receipt_id";
const std::string AppsFlyerTracker::EventParam1 = "af_param_1";
const std::string AppsFlyerTracker::EventParam2 = "af_param_2";
const std::string AppsFlyerTracker::EventParam3 = "af_param_3";
const std::string AppsFlyerTracker::EventParam4 = "af_param_4";
const std::string AppsFlyerTracker::EventParam5 = "af_param_5";
const std::string AppsFlyerTracker::EventParam6 = "af_param_6";
const std::string AppsFlyerTracker::EventParam7 = "af_param_7";
const std::string AppsFlyerTracker::EventParam8 = "af_param_8";
const std::string AppsFlyerTracker::EventParam9 = "af_param_9";
const std::string AppsFlyerTracker::EventParam10 = "af_param_10";
    
class iOSAppsFlyerTracker: public AppsFlyerTracker
{
public:
    virtual std::string getCustomerUserID() const override
    {
        return "";
    }

    virtual void setCustomerUserID(const std::string &customerUserID) override
    {
        
    }

    virtual std::string getAppsFlyerDevKey() const override
    {
        return "";
    }

    virtual void setAppsFlyerDevKey(const std::string &appsFlyerDevKey) override
    {
        
    }

    virtual std::string getAppleAppID() const override
    {
        return "";
    }

    virtual void setAppleAppID(const std::string &appleAppID) override
    {
        
    }

    virtual std::string getCurrencyCode() const override
    {
        return "";
    }

    virtual void setCurrencyCode(const std::string &currencyCode) override
    {
        
    }
    
    virtual bool getHTTPS() const override
    {
        return false;
    }

    virtual void setHTTPS(bool value) override
    {
        
    }
    
    virtual bool getDisableAppleAdSupportTracking() const override
    {
        return false;
    }

    virtual void setDisableAppleAdSupportTracking(bool value) override
    {
        
    }

    virtual bool getIsDebug() const override
    {
        return false;
    }

    virtual void setIsDebug(bool value) override
    {
        
    }

    virtual bool getDeviceTrackingDisabled() const override
    {
        return false;
    }

    virtual void setDeviceTrackingDisabled(bool value) override
    {
        
    }
    
    virtual bool getDisableIAdTracking() const override
    {
        return false;
    }

    virtual void setDisableIAdTracking(bool value) override
    {
        
    }

    virtual AppsFlyerTrackerDelegate* getDelegate() const override
    {
        return nullptr;
    }

    virtual void setDelegate(AppsFlyerTrackerDelegate *delegate) override
    {
        
    }
    
    virtual bool getUseReceiptValidationSandbox() const override
    {
        return false;
    }

    virtual void setUseReceiptValidationSandbox(bool value) override
    {
        
    }

    virtual void trackAppLaunch() override
    {
        
    }
    
    virtual void trackEvent(const std::string &eventName, const std::string &value) override
    {
        
    }

    virtual void trackEvent(const std::string &eventName, const utils::ValueMap &values) override
    {
        
    }

    virtual void validateAndTrackInAppPurchase(const std::string &eventNameIfSuucceed,
                                               const std::string &failedEventName,
                                               const std::string &value,
                                               const std::string &productIdentifier,
                                               double price,
                                               const std::string &currency,
                                               std::function<void(NSDictionary *response)> &successCallback,
                                               std::function<void(NSError *error, id reponse)> failedCallback) override
    {
        
    }

    
    virtual std::string getAppsFlyerUID() const override
    {
        return "";
    }
};
    
    
AppsFlyerTracker* AppsFlyerTracker::getInstance()
{
    static iOSAppsFlyerTracker* instance = new iOSAppsFlyerTracker();
    return instance;
}

}