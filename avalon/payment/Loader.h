#ifndef AVALON_PAYMENT_LOADER_H
#define AVALON_PAYMENT_LOADER_H

#include <avalon/utils/utility.hpp>
#include <avalon/io/IniReader.h>

namespace avalon {
namespace payment {

class Manager;

/**
 * Translates the content of the given ini-file into the right setup of
 * payment::Manager with payment::Product and/or payment::ProductConsumable.
 */
class Loader : avalon::noncopyable
{
public:
    static std::shared_ptr<Manager> globalManager;

    explicit Loader(const char* iniFile);
    std::shared_ptr<Manager> getManager() const;

private:
    std::shared_ptr<Manager> manager;
    io::IniReader config;

    const char* detectProductId(const char* section);
};

} // namespace payment
} // namespace avalon

#endif /* AVALON_PAYMENT_LOADER_H */
