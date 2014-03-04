#ifndef AVALON_PHYSICS_CONTACTCONTAINER_H
#define AVALON_PHYSICS_CONTACTCONTAINER_H

#include "Box2D/Box2D.h"
#include <avalon/utils/utility.hpp>

namespace avalon { namespace physics { class Box2dContainer; } }
namespace avalon { namespace physics { class CollisionManager; } }

namespace avalon {
namespace physics {

class ContactContainer : public avalon::noncopyable
{
private:
    friend CollisionManager;

    b2Contact* contact = nullptr;
    Box2dContainer* container = nullptr;
    bool iAmInFixtureA = false;

public:
    ContactContainer(Box2dContainer* container, b2Contact* contact, bool meInFixtureA);

    Box2dContainer& getContainer();
    const Box2dContainer& getContainer() const;

    b2Contact& getContact();
    const b2Contact& getContact() const;

    b2Fixture& getMyFixture();
    const b2Fixture& getMyFixture() const;

    b2Fixture& getOpponentFixture();
    const b2Fixture& getOpponentFixture() const;

    const int32 getMyChildIndex() const;
    const int32 getOpponentChildIndex() const;
};

} // namespace physics
} // namespace avalon

#endif /* AVALON_PHYSICS_CONTACTCONTAINER_H */
