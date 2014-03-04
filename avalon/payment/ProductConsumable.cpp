#include <avalon/payment/ProductConsumable.h>

#include <avalon/utils/assert.hpp>

namespace avalon {
namespace payment {

ProductConsumable::ProductConsumable(const char* const productId, const float quantityPerPurchase)
: Product(productId)
, quantityPerPurchase(quantityPerPurchase)
{
}

ProductConsumable::~ProductConsumable()
{
    AVALON_ASSERT_MSG(getQuantity() == 0, "unused consumable quantity detected!");
}

void ProductConsumable::consume()
{
    Product::consume();
    purchasedCounter = 0;
}

float ProductConsumable::getQuantity() const
{
    return (purchasedCounter * quantityPerPurchase);
}

} // namespace payment
} // namespace avalon
