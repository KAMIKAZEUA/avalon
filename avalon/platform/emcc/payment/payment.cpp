#include "avalon/payment.h"

#include "emscripten.h"
#include "../cocos2d/external/json/document.h"


namespace avalon {
namespace payment {

void extFailProductsData(void* arg);
void extLoadProductsData(void* arg, void* ptr, int len);

class WindowsManager:public Manager
{
public:
    WindowsManager():_delegate(nullptr)
    {
    }
    ~WindowsManager()
    {
    }
    virtual void addProduct(const std::string &id, const std::string &productIdentifier, bool consumable) override
    {
        Product product;
        product.id = id;
        product.productIdentifier = productIdentifier;
        product.consumable = consumable;
        addProduct(product);
    }
    virtual void addProduct(const Product &product) override
    {
        printf("addProduct\n");
        _products.push_back(product);
    }

    virtual void clearProducts() override
    {
        printf("getProducts\n");
        _products.clear();
    }

    virtual void requestProductsData() override
    {

        emscripten_async_wget_data("shop.json", 0, extLoadProductsData, extFailProductsData);

        printf("requestProductsData\n");
    }

    void failProductsData(void* arg)
    {
        _delegate->onRequestProductsFail();
    }

    void loadProductsData(void* arg, void* ptr, int len)
    {
        char * json_data = new char[len + 1];
        memcpy(json_data, ptr, len);
        json_data[len] = 0;
        printf("parse json .........  %d \n",  len);

        rapidjson::Document json;
        std::string content = std::string((char *)ptr);
        json.Parse(json_data);
        if (json.HasParseError())
        {
            printf("parse error json \n*\n  %d, %d \n*\n", json.GetParseError(), json.GetErrorOffset());
            return;
        }
       
        auto& items = json["items"];
   //     printf("parse error json %d items  ok \n", items.Size());

        if (items.IsArray())
        {
            for (rapidjson::SizeType i = 0; i < items.Size(); i++)
            {
                auto& item = items[i];

   //             printf("parse  json item %s \n", item["ID"].GetString());

                for (auto &product : _products)
                {
//                    printf("parse  json item %s == %s \n", product.productIdentifier.c_str(), item["ID"].GetString());
                    if (product.productIdentifier == std::string(std::string("pokerist_test.") + std::string(item["ID"].GetString())))
                    {
//                        printf("parse  json item  == !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n");
                        product.localizedName = std::string(item["ID"].GetString());
                        product.localizedPrice = std::string(item["Price"].GetString());
                    }
                }

            }
        }

        _delegate->onRequestProductsSucceed();
        delete [] json_data;
    }

    virtual void setDelegate(ManagerDelegate *delegate) override
    {
        _delegate = delegate;
    }
    virtual ManagerDelegate *getDelegate() const override
    {
        return _delegate;
    }
    
    virtual const std::vector<Product>& getProducts() const override
    {
        printf("getProducts\n");
        return _products;
    }
    
    virtual const Product* getProduct(const std::string &id) const override
    {
        for(const auto &product:_products)
        {
            if(product.id == id)
                return &product;
        }
        return nullptr;
    }
    
    Product* getProductByProductIdentifier(const std::string &productIdentifier)
    {
        for(auto &product:_products)
        {
            if(product.productIdentifier == productIdentifier)
                return &product;
        }
        return nullptr;
    }
    
    const Product* getProductByProductIdentifier(const std::string &productIdentifier) const
    {
        for(const auto &product:_products)
        {
            if(product.productIdentifier == productIdentifier)
                return &product;
        }
        return nullptr;
    }
    


    void External_SendMessage(const char *arg1)
    {
        
            EM_ASM_ARGS(
            {
                var messageStr = Pointer_stringify($0);
              
                alert(messageStr);


            }, arg1);
        
    }

    virtual void purchase(const std::string &id) override
    {
        const avalon::payment::Product* productToPurchase = getProduct(id);
        if (!productToPurchase)
        {
            Transaction managerTransaction;
            managerTransaction.transactionState = TransactionState::Failed;
            managerTransaction.productId = id;
            _delegate->onPurchaseFail(managerTransaction, ManagerDelegateErrors::PRODUCT_UNKNOWN);
        }
        std::string buyitemscript = std::string("VKSocialObject.BuyItem('") + productToPurchase->id + std::string("')");
        emscripten_run_script(buyitemscript.c_str());

    }
    
    void onPurchaseSucceed(const char * order_id, const char * item_id)
    {
        if (_delegate)
        {
            Transaction managerTransaction;
            managerTransaction.transactionState = TransactionState::Purchased;
            managerTransaction.productId = std::string(item_id);
            std::string order_s = std::string(order_id);
            std::copy(order_s.begin(), order_s.end(), std::back_inserter(managerTransaction.receipt));
            _delegate->onPurchaseSucceed(managerTransaction);
        }
    }
    void onPurchaseFailed(const char * error_id, const char * id)
    {
        if (_delegate)
        {
            Transaction managerTransaction;
            managerTransaction.transactionState = TransactionState::Purchased;
            managerTransaction.productId = id;
            ManagerDelegateErrors error;
            error = ManagerDelegateErrors::PRODUCT_UNKNOWN;
            _delegate->onPurchaseFail(managerTransaction, error);
        }
    }
    void onPurchaseCanceled(const char * id)
    {
        if (_delegate)
        {
            Transaction managerTransaction;
            managerTransaction.transactionState = TransactionState::Purchased;
            managerTransaction.productId = id;
            ManagerDelegateErrors error;
            error = ManagerDelegateErrors::PAYMENT_CANCELLED;
            _delegate->onPurchaseFail(managerTransaction, error);
        }
    }
    
    virtual bool isPurchaseReady() const override
    {
        return true;
    }
    
    virtual void restorePurchases() const override
    {
        std::vector<Transaction> managerTransactions;
        if (_delegate) {
            _delegate->onRestoreSucceed(managerTransactions);
        }
    }
    
    virtual void startService(const std::string &data)
    {
        if(!_started)
        {
            _started = true;
            if (_delegate) {
                _delegate->onServiceStarted();
            }
        }
    }
    
    virtual void stopService() override
    {
        if(_started)
            _started = false;
    }
    
    virtual bool isStarted() const override
    {
        return _started;
    }
    
private:
    std::vector<Product> _products;
    ManagerDelegate *_delegate;
    bool _started;
};

Manager *Manager::getInstance()
{
    static WindowsManager *manager = nullptr;
    if(!manager)
    {
        manager = new WindowsManager();
    }
    return manager;
}

void extFailProductsData(void* arg)
{
    ((WindowsManager*)Manager::getInstance())->failProductsData(arg);
}

void extLoadProductsData(void* arg, void* ptr, int len)
{
    ((WindowsManager*)Manager::getInstance())->loadProductsData(arg, ptr, len);
}

extern "C" {
    int EMSCRIPTEN_KEEPALIVE extOnOrderSuccess(const char * order_id, const char * item_id)
    {
       ((WindowsManager*) Manager::getInstance())->onPurchaseSucceed(order_id, item_id);
       return 0;
    }    
    int EMSCRIPTEN_KEEPALIVE extOnOrderFail(char * error_id, char * item_id)
    {
        ((WindowsManager*)Manager::getInstance())->onPurchaseFailed(error_id, item_id);
        return 0;
    }
    int EMSCRIPTEN_KEEPALIVE extOnOrderCancel( char * item_id)
    {
        ((WindowsManager*)Manager::getInstance())->onPurchaseCanceled(item_id);
        return 0;
    }
}

} // namespace payment
} // namespace avalon
