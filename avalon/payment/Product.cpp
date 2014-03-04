#include <avalon/payment/Product.h>

#include <avalon/payment/Manager.h>
#include <avalon/utils/assert.hpp>

namespace avalon {
namespace payment {

Product::Product(const char* const productId)
: price(0)
, localizedPrice()
, localizedName()
, localizedDescription()
, purchasedCounter(0)
, manager(NULL)
, productId(std::string(productId))
{
}

Product::~Product()
{
}

std::string Product::getProductId() const
{
    return productId;
}

bool Product::canBePurchased() const
{
    if (!manager || !manager->isPurchaseReady()) {
        return false;
    }

    return true;
}

void Product::purchase()
{
    if (!manager) {
        AVALON_ASSERT_MSG(false, "service has to be set");
        return;
    }

    manager->purchase(getProductId().c_str());
}

void Product::onHasBeenPurchased()
{
    ++purchasedCounter;
}

bool Product::hasBeenPurchased() const
{
    return (purchasedCounter > 0);
}

void Product::consume()
{
}

} // namespace payment
} // namespace avalon
