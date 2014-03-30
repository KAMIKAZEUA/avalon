#ifdef AVALON_CONFIG_PAIMENT_ENABLED
#include <avalon/payment/Backend.h>

#include <StoreKit/StoreKit.h>

#include <avalon/platform/ios/payment/BackendIos.h>
#include <avalon/payment/Manager.h>
#include <avalon/payment/ManagerDelegate.h>
#include <avalon/payment/Product.h>

namespace avalon {
namespace payment {

BackendIos* const __getIosBackend()
{
    static BackendIos* instance = nullptr;
    if (!instance) {
        instance = [[BackendIos alloc] init];
        instance->initialized = false;
    }
    return instance;
}

Backend::Backend(Manager& manager)
: manager(manager)
{
}

Backend::~Backend()
{
    shutdown();
}

bool Backend::isInitialized() const
{
    return __getIosBackend()->initialized;
}

void Backend::initialize()
{
    // configure BackendIos
    __getIosBackend()->initialized = true;
    __getIosBackend()->manager = &manager;
    __getIosBackend()->transactionDepth = 0;

    // register transcationObserver
    [[SKPaymentQueue defaultQueue] addTransactionObserver:__getIosBackend()];

    // convert Avalon::Payment::ProductList into NSMutableSet
    NSMutableSet* products = [[[NSMutableSet alloc] init] autorelease];
    for (const auto& pair : manager.getProducts()) {
        const char* const productId = pair.second->getProductId().c_str();
        [products addObject:[NSString stringWithUTF8String:productId]];
    }

    // fetch product details
    SKProductsRequest* request = [[SKProductsRequest alloc] initWithProductIdentifiers:products];
    request.delegate = __getIosBackend();
    [request start];
}

void Backend::shutdown()
{
    if (!isInitialized()) {
        return;
    }

    [[SKPaymentQueue defaultQueue] removeTransactionObserver:__getIosBackend()];
    __getIosBackend()->initialized = false;
    __getIosBackend()->manager = NULL;
}

void Backend::purchase(Product* const product)
{
    if (__getIosBackend()->transactionDepth == 0) {
        if (manager.delegate) {
            manager.delegate->onTransactionStart(&manager);
        }
    }
    __getIosBackend()->transactionDepth += 1;

    NSString* productId = [[[NSString alloc] initWithUTF8String:product->getProductId().c_str()] autorelease];
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:productId];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

bool Backend::isPurchaseReady() const
{
    return [SKPaymentQueue canMakePayments];
}

void Backend::restorePurchases() const
{
    if (__getIosBackend()->transactionDepth == 0) {
        if (manager.delegate) {
            manager.delegate->onTransactionStart(&manager);
        }
    }
    __getIosBackend()->transactionDepth += 1;

    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

} // namespace payment
} // namespace avalon
#endif //AVALON_CONFIG_PAIMENT_ENABLED
