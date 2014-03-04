#ifndef AVALON_UTILS_SINGLETON_H
#define AVALON_UTILS_SINGLETON_H

#include <avalon/utils/utility.hpp>

namespace avalon {
namespace utils {

template <typename T>
class Singleton : private avalon::noncopyable
{
public:
    static T& getInstance()
    {
        static T staticInstance;
        return staticInstance;
    }

protected:
    Singleton() {}
    virtual ~Singleton() {}
};

} // namespace utils
} // namespace avalon

#endif /* AVALON_UTILS_SINGLETON_H */
